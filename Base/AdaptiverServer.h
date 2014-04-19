//
//  AdaptiverServer.h
//  DemoProject
//
//  Created by Proint on 14-3-31.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppMacros.h"

@interface AdaptiverServer : NSObject

AS_SINGLETON(AdaptiverServer);

- (void)setCustomNavBarHeight:(CGFloat)barHeight;
- (void)setCustomTarBarHeight:(CGFloat)barHeight;

- (CGRect)getCustomNavigationBarFrame;

//无tabbar有navbar
- (CGRect)getBackgroundViewFrame;

//无tabbar无navbar
- (CGRect)getBackgroundViewFrameWithoutNavigationBar;


//有tabbar有navbar
- (CGRect)getBackgroundViewFrameWithTabBar;

//有tabbar无navbar
- (CGRect)getBackgroundViewFrameWithTabBarWithoutNavBar;

@end
