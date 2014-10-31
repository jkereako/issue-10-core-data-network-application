//
//  Pod.h
//  Pods
//
//  Created by Chris Eidhof on 02.03.14.
//  Copyright (c) 2014 objc.io. All rights reserved.
//

#import "ModelObject.h"

@interface Pod : ModelObject

@property (nonatomic) id authors;
@property (nonatomic) NSString *link;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *source;
@property (nonatomic) NSString *version;
@property (nonatomic) NSString *identifier;

- (void)loadFromDictionary:(NSDictionary *)dictionary;
+ (Pod *)findOrCreatePodWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context;

@end
