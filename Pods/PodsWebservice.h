//
// Created by chris on 02.03.14.
//

@interface PodsWebservice : NSObject

- (void)fetchAllPods:(void (^)(NSArray *pods))callback;

@end
