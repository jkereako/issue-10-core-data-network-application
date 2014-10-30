//
// Created by chris on 14.11.13.
//

@interface ModelObject : NSManagedObject

+ (NSString *)entityName;
+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context;

@end
