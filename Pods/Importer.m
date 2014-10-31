//
// Created by chris on 02.03.14.
//

#import "Importer.h"
#import "PodsWebservice.h"
#import "Pod.h"

@interface Importer ()

@property (nonatomic, readwrite) NSManagedObjectContext *context;
@property (nonatomic, readwrite) PodsWebservice *webservice;
@property (nonatomic, readwrite) NSUInteger batchSize;
@property (nonatomic, readwrite) NSUInteger batchCount;

@end

@implementation Importer


- (instancetype)initWithContext:(NSManagedObjectContext *)context webservice:(PodsWebservice *)webservice {
    self = [super init];
    if (self) {
        _context = context;
        _webservice = webservice;
        _batchSize = 10;
    }
    return self;
}

- (void)import {
    self.batchCount = 0;
    [self.webservice fetchAllPods:^(NSArray *pods) {
        [self.context performBlock:^{
            for(NSDictionary *podSpec in pods) {
                NSString *identifier = [podSpec[@"id"] stringByAppendingString:podSpec[@"version"]];
                Pod *pod = [Pod findOrCreatePodWithIdentifier:identifier
                                                    inContext:self.context];
                [pod loadFromDictionary:podSpec];
            }
            //@TODO: Fix this
//            self.batchCount++;
//            if (self.batchCount % self.batchSize == 0) {
                NSError *error;
                if (![self.context save:&error]) {
                    NSLog(@"Error: %@", error.localizedDescription);
                }
//            }
        }];
    }];
}
@end
