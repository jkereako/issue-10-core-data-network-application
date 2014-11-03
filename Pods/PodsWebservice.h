//
// Created by chris on 02.03.14.
//

@interface PodsWebservice : NSObject

@property (nonatomic, readonly) NSURLSession *urlSession;

- (void)fetchAllPodsWithCallback:(void (^)(NSArray *pods))callback;

@end
