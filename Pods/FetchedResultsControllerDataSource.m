//
// Created by Chris Eidhof
//

#import "FetchedResultsControllerDataSource.h"

@interface FetchedResultsControllerDataSource ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FetchedResultsControllerDataSource

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.dataSource = self;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(__unused UITableView *)tableView {
    return (NSInteger)self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[(NSUInteger)sectionIndex];
    return (NSInteger)section.numberOfObjects;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectAtIndexPath:indexPath];
    id cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    id<FetchedResultsControllerDataSourceDelegate> strongDelegate = self.delegate;
    [strongDelegate configureCell:cell withObject:object];
    return cell;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (BOOL)tableView:(__unused UITableView*)tableView canEditRowAtIndexPath:(__unused NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(__unused UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    id<FetchedResultsControllerDataSourceDelegate> strongDelegate = self.delegate;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [strongDelegate deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(__unused NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(__unused NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(__unused NSFetchedResultsController *)controller didChangeObject:(__unused id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath {
    id<FetchedResultsControllerDataSourceDelegate> strongDelegate = self.delegate;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [strongDelegate configureCell:[self.tableView cellForRowAtIndexPath:indexPath]
                              withObject: anObject];
            break;

        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath
                                   toIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            NSAssert(NO,@"");
            break;
    }
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController {
    NSAssert(_fetchedResultsController == nil, @"TODO: you can currently only assign this property once");
    _fetchedResultsController = fetchedResultsController;
    fetchedResultsController.delegate = self;
    
    NSError *error;
    
    if(![fetchedResultsController performFetch:&error]) {
         NSLog(@"error: %@", error.localizedDescription);
    }
}


- (id)selectedItem {
    NSIndexPath* path = self.tableView.indexPathForSelectedRow;
    return path ? [self.fetchedResultsController objectAtIndexPath:path] : nil;
}


- (void)setPaused:(BOOL)paused {
    _paused = paused;
    if (paused) {
        self.fetchedResultsController.delegate = nil;
    } else {
        self.fetchedResultsController.delegate = self;
        [self.fetchedResultsController performFetch:NULL];
        [self.tableView reloadData];
    }
}


@end
