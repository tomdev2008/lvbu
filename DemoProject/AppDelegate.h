//
//  AppDelegate.h
//  DemoProject
//
//  Created by zzc on 13-12-26.
//  Copyright (c) 2013年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseAppDelegate.h"


#import "MainViewController.h"
#import "MoreViewController.h"
#import "PartnerViewController.h"
#import "LeftViewController.h"
#import "LoginViewController.h"
#import "SportViewController.h"



@interface AppDelegate : BaseAppDelegate
<UITabBarControllerDelegate, BPushDelegate>
{
    UIBackgroundTaskIdentifier backgroundTaskIdentifier;
    UIBackgroundTaskIdentifier oldBackgroundTaskIdentifier;
}

//@property (strong, nonatomic) TestBLEAdapter *bleAdapter;

@property (strong, nonatomic) NSTimer *myTimer;
@property (strong, nonatomic) UIWindow *window;


@property NSString *appId;
@property NSString *channelId;
@property NSString *userId;

@property (strong, nonatomic) MainViewController        *mainVC;            //侣步
@property (strong, nonatomic) MoreViewController        *moreVC;            //更多
@property (strong, nonatomic) PartnerViewController     *parterVC;          //陪伴
@property (strong, nonatomic) LeftViewController        *leftVC;            //左侧栏
@property (strong, nonatomic) SportViewController       *sportVC;           //运动界面


@property (strong, nonatomic) UINavigationController    *rootNav;
@property (strong, nonatomic) IIViewDeckController      *viewDeckController;


@end
