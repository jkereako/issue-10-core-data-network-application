//
// Created by chris on 02.03.14.
//

#import "PodsWebservice.h"

@interface PodsWebservice ()

@property (nonatomic, readwrite) NSURLSession *urlSession;
@property (nonatomic) NSURLSessionDataTask *task;

- (void)fetchAllPods:(void (^)(NSArray *pods))callback query:(NSString *) query page:(NSUInteger)page;

@end

static NSString * const kCocoaPodsAPIBaseURLString = @"http://search.cocoapods.org/api/pods";
NSUInteger pageSize = 10;

@implementation PodsWebservice

- (void)fetchAllPods:(void (^)(NSArray *pods))callback {
    [self fetchAllPods:callback query:@"on:ios%20test" page:0 ];
}

- (void)fetchAllPods:(void (^)(NSArray *pods))callback query:(NSString *) query page:(NSUInteger)page {
    NSString *urlString = [NSString stringWithFormat:
                           @"%@?query=%@&amount=%lu&start-at=%lu",
                           kCocoaPodsAPIBaseURLString,
                           query,
                           pageSize,
                           (page * pageSize) + page]; // e.g. (3 * 10) + 3 = 33, start on the 33rd pod
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[self.urlSession dataTaskWithURL:url
                    completionHandler:
      ^(NSData *data, __unused NSURLResponse *response, NSError *error) {
          if (error) {
              NSLog(@"error: %@", error.localizedDescription);
              callback(nil);
              return;
          }
          NSError *jsonError;
          id result = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingMutableContainers
                                                        error:&jsonError];
          
          if(!result) {
              NSLog(@"error: %@", jsonError.localizedDescription);
              return;
          }
          
          if ([result isKindOfClass:[NSArray class]]) {
              callback(result);
              // If the result count is equal to the page size, then there may
              // be more pods to fetch. If the count is less than the page size,
              // then we have reached the end of the list. However, if the
              // result count is larger than pageSize, then our query didn't
              // work :(.
              if ([result count] == pageSize) {
                  [self fetchAllPods:callback query:query page:page + 1];
              }
          }
      }] resume];
}

#pragma mark - Getters
- (NSURLSession *)urlSession {
    if(_urlSession) {
        return _urlSession;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];

    configuration.allowsCellularAccess = NO;
    configuration.timeoutIntervalForRequest = 30.0;
    configuration.timeoutIntervalForResource = 60.0;
    configuration.HTTPMaximumConnectionsPerHost = 1;
    configuration.URLCache=urlCache;
    
    // @see http://blog.cocoapods.org/Search-API-Version-1/
    [configuration setHTTPAdditionalHeaders: @{@"Accept": @"application/vnd.cocoapods.org+flat.hash.json; version=1"}];
    
    _urlSession = [NSURLSession sessionWithConfiguration:configuration
                                                delegate:nil
                                           delegateQueue:nil];
    return _urlSession;
}


@end
