//
// Created by chris on 02.03.14.
//

#import "Importer.h"
#import "PodsWebservice.h"
#import "Pod.h"

@interface Importer ()

@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) PodsWebservice *webservice;
@property (nonatomic) int batchCount;

@end

@implementation Importer


- (instancetype)initWithContext:(NSManagedObjectContext *)context webservice:(PodsWebservice *)webservice
{
    self = [super init];
    if (self) {
        _context = context;
        _webservice = webservice;
    }
    return self;
}

- (void)import
{
    self.batchCount = 0;
    [self.webservice fetchAllPods:^(NSArray *pods)
    {
        [self.context performBlock:^
        {
            for(NSDictionary *podSpec in pods) {
                NSString *identifier = [podSpec[@"name"] stringByAppendingString:podSpec[@"version"]];
                Pod *pod = [Pod findOrCreatePodWithIdentifier:identifier inContext:self.context];
                [pod loadFromDictionary:podSpec];
            }
            self.batchCount++;
            if (self.batchCount % 10 == 0) {
                NSError *error = nil;
                [self.context save:&error];
                if (error) {
                    NSLog(@"Error: %@", error.localizedDescription);
                }
            }
        }];
    }];
}
@end
