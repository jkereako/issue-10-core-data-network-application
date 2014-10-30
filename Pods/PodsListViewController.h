//
//  PodsListViewController.h
//  Pods
//
//  Created by Chris Eidhof on 02.03.14.
//  Copyright (c) 2014 objc.io. All rights reserved.
//

@class NSManagedObjectContext;

@interface PodsListViewController : UITableViewController

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@end
