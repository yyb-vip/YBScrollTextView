//
//  YBAppDelegate.m
//  YBScrollTextView
//
//  Created by yangyibo93@gmail.com on 04/16/2020.
//  Copyright (c) 2020 yangyibo93@gmail.com. All rights reserved.
//

#import "YBAppDelegate.h"
#import "MainTabbarVC.h"

@implementation YBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    MainTabbarVC *mainVC = [[MainTabbarVC alloc] init];
    self.window.rootViewController = mainVC;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
