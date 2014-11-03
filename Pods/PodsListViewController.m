//
//  PodsListViewController.m
//  Pods
//
//  Created by Chris Eidhof on 02.03.14.
//  Copyright (c) 2014 objc.io. All rights reserved.
//

#import "PodsListViewController.h"
#import "FetchedResultsControllerDataSource.h"
#import "Pod.h"
#import "PodDetailViewController.h"

@interface PodsListViewController () <FetchedResultsControllerDataSourceDelegate>

@property (nonatomic, readwrite) FetchedResultsControllerDataSource *dataSource;

- (IBAction)refresh:(id)sender;

- (void)setupFetchedResultsControllerWithFetchRequest:(NSFetchRequest *) request tableViewCellIdentifier: (NSString *) identifier;

@end

@implementation PodsListViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Pod"];
    [self setupFetchedResultsControllerWithFetchRequest:fetchRequest
                                tableViewCellIdentifier:@"Cell"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(__unused id)sender {
    PodDetailViewController *detailViewController = segue.destinationViewController;
    detailViewController.pod = self.dataSource.selectedItem;
}

#pragma mark -
- (void)setupFetchedResultsControllerWithFetchRequest:(NSFetchRequest *) request tableViewCellIdentifier: (NSString *) identifier {
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"version"
                                                              ascending:NO]];
    self.dataSource = [[FetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    self.dataSource.delegate = self;
    self.dataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                   managedObjectContext:self.managedObjectContext
                                                                                     sectionNameKeyPath:nil
                                                                                              cacheName:nil];
    self.dataSource.reuseIdentifier = identifier;
}

#pragma mark - Target/Action
- (IBAction)refresh:(__unused id)sender {
    NSError *error;
    if(![self.dataSource.fetchedResultsController performFetch: &error]) {
        NSLog(@"error: %@", error.localizedDescription);
    }

    [self.refreshControl endRefreshing];

}

#pragma mark - FetchedResultsControllerDataSourceDelegate
- (void)configureCell:(UITableViewCell *)cell withObject:(Pod *)object {
    cell.textLabel.text = object.name;
    cell.detailTextLabel.text = object.version;
}

- (void)deleteObject:(__unused id)object {

}

@end
