//
//  AppDelegate.h
//  DemoProject
//
//  Created by zzc on 13-12-26.
//  Copyright (c) 2013年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseAppDelegate.h"
#import "CustomNavigationController.h"

#import "MainViewController.h"
#import "MoreViewController.h"
#import "PartnerViewController.h"


@interface AppDelegate : BaseAppDelegate<UITabBarControllerDelegate, UITabBarDelegate>
{
    UIBackgroundTaskIdentifier backgroundTaskIdentifier;
    UIBackgroundTaskIdentifier oldBackgroundTaskIdentifier;
}

//@property (strong, nonatomic) TestBLEAdapter *bleAdapter;

@property (strong, nonatomic) NSTimer *myTimer;
@property (strong, nonatomic) UIWindow *window;


@property (strong, nonatomic) MainViewController *mainVC;           //侣步
@property (strong, nonatomic) MoreViewController *moreVC;           //更多
@property (strong, nonatomic) PartnerViewController *parterVC;      //陪伴

@property (strong, nonatomic) UINavigationController *mainNav;
@property (strong, nonatomic) UINavigationController *moreNav;
@property (strong, nonatomic) UINavigationController *parterNav;

@property (strong, nonatomic) UITabBarController *rootTabBarController;


@end
