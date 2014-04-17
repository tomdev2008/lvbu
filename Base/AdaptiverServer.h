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
- (CGRect)getBackgroundViewFrame;
- (CGRect)getBackgroundViewFrameWithoutNavigationBar;


//减掉Tarbar高度
- (CGRect)modifyBackgroundViewFrame:(CGRect)frame;

@end
