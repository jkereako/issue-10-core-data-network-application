//
//  AppDelegate.h
//  Pods
//
//  Created by Chris Eidhof on 02.03.14.
//  Copyright (c) 2014 objc.io. All rights reserved.
//

@class PersistentStack;
@class PodsWebservice;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow *window;
@property (nonatomic) PersistentStack *persistentStack;
@property (nonatomic) PodsWebservice *webservice;

@end
