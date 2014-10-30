//
// Created by Chris Eidhof
//

@interface PersistentStack : NSObject

- (instancetype)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL;

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSManagedObjectContext *backgroundManagedObjectContext;

@end
