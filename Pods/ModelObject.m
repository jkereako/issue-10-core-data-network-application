//
// Created by chris on 14.11.13.
//

#import "ModelObject.h"

@implementation ModelObject

+ (NSString *)entityName {
    return NSStringFromClass(self);
}

+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:context];
}
@end
