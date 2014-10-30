//
// Created by chris on 02.03.14.
//

@class PodsWebservice;

@interface Importer : NSObject

- (instancetype)initWithContext:(NSManagedObjectContext *)context webservice:(PodsWebservice *)webservice;
- (void)import;

@end
