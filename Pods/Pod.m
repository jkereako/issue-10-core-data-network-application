//
//  Pod.m
//  Pods
//
//  Created by Chris Eidhof on 02.03.14.
//  Copyright (c) 2014 objc.io. All rights reserved.
//

#import "Pod.h"

@implementation Pod

@dynamic authors;
@dynamic link;
@dynamic name;
@dynamic source;
@dynamic version;
@dynamic identifier;

- (void)loadFromDictionary:(NSDictionary *)dictionary {
    self.name = dictionary[@"id"];
    self.source = dictionary[@"source"][@"git"];
    self.link = dictionary[@"link"];
    self.authors = dictionary[@"authors"];
    self.version = dictionary[@"version"];
}

+ (Pod *)findOrCreatePodWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    NSError *error;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (!result) {
        NSLog(@"error: %@", error.localizedDescription);
        return nil;
    }
    else if (result.lastObject) {
        return result.lastObject;
    }
    
    Pod *pod = [self insertNewObjectIntoContext:context];
    pod.identifier = identifier;
    
    return pod;
}

@end
