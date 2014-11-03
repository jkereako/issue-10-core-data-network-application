//
// Created by Chris Eidhof
//

@class NSFetchedResultsController;

@protocol FetchedResultsControllerDataSourceDelegate

@required
- (void)configureCell:(id)cell withObject:(id)object;

@optional
- (void)deleteObject:(id)object;

@end

@interface FetchedResultsControllerDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, weak) id<FetchedResultsControllerDataSourceDelegate> delegate;
@property (nonatomic, copy) NSString* reuseIdentifier;
@property (nonatomic) BOOL paused;

- (instancetype)initWithTableView:(UITableView *)tableView;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (id)selectedItem;

@end
