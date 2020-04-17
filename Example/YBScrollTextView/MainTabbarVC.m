//
//  MainTabbarVC.m
//  YBScrollTextView_Example
//
//  Created by yyb on 2020/4/17.
//  Copyright © 2020 yangyibo93@gmail.com. All rights reserved.
//

#import "MainTabbarVC.h"
#import "YBViewController.h"
#import "YBScrollTextViewDelegateVC.h"

@interface MainTabbarVC ()

@end

@implementation MainTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YBViewController *item1 = [YBViewController new];
    item1.tabBarItem.title = @"item1";
    
    YBScrollTextViewDelegateVC *item2 = [YBScrollTextViewDelegateVC new];
    item2.tabBarItem.title = @"item2";
    
    self.viewControllers = @[item1, item2];
    
}

@end
