//
//  AdaptiverServer.m
//  DemoProject
//
//  Created by Proint on 14-3-31.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "AdaptiverServer.h"

@interface AdaptiverServer()

@property (nonatomic, assign) CGFloat navigationBarHeight;
@property (nonatomic, assign) CGFloat tabbarHeight;

@end

@implementation AdaptiverServer

DEF_SINGLETON(AdaptiverServer);

- (id)init
{
    self = [super init];
    if (self) {
        
        //默认为44.0
        self.navigationBarHeight = 0;
        self.tabbarHeight = 0;
        
    }
    
    return self;
}



- (void)setCustomNavBarHeight:(CGFloat)barHeight
{
    self.navigationBarHeight = barHeight;
}

- (void)setCustomTarBarHeight:(CGFloat)barHeight
{
    self.tabbarHeight = barHeight;
}



- (CGRect)getCustomNavigationBarFrame
{
    CGRect resultFrame = CGRectZero;
    CGRect frame = [[UIScreen mainScreen] bounds];
    if ([UIApplication sharedApplication].statusBarHidden == YES) {
        
        resultFrame = CGRectMake(0, 0, CGRectGetWidth(frame), self.navigationBarHeight);
        
    }else {
        
        if (IOS7_OR_LATER) {
            resultFrame = CGRectMake(0, 20, CGRectGetWidth(frame), self.navigationBarHeight);
        } else {
            resultFrame = CGRectMake(0, 0, CGRectGetWidth(frame), self.navigationBarHeight);
        }
    }
    return resultFrame;
}


- (CGRect)getBackgroundViewFrame
{
    
    CGRect resultFrame = CGRectZero;
    CGRect frame = [[UIScreen mainScreen] bounds];
    if ([UIApplication sharedApplication].statusBarHidden == YES) {
        
        if (IOS7_OR_LATER) {
            resultFrame = CGRectMake(0, self.navigationBarHeight, CGRectGetWidth(frame), CGRectGetHeight(frame) - self.navigationBarHeight);
        } else {
            resultFrame = CGRectMake(0, self.navigationBarHeight, CGRectGetWidth(frame), CGRectGetHeight(frame) - self.navigationBarHeight);
        }

    }else {
        if (IOS7_OR_LATER) {
            resultFrame = CGRectMake(0, self.navigationBarHeight + 20, CGRectGetWidth(frame),  CGRectGetHeight(frame) - self.navigationBarHeight - 20);
        } else {
            resultFrame = CGRectMake(0, self.navigationBarHeight, CGRectGetWidth(frame), CGRectGetHeight(frame) - self.navigationBarHeight - 20);
        }
    }
    
    return resultFrame;
}



- (CGRect)getBackgroundViewFrameWithoutNavigationBar
{
    CGRect resultFrame = CGRectZero;
    CGRect frame = [[UIScreen mainScreen] bounds];
    if ([UIApplication sharedApplication].statusBarHidden == YES) {
        
        resultFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        
    }else {
        if (IOS7_OR_LATER) {
            resultFrame = CGRectMake(0, 20, CGRectGetWidth(frame),  CGRectGetHeight(frame) - 20);
        } else {
            resultFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame) - 20);
        }
    }
    
    return resultFrame;
}




- (CGRect)modifyBackgroundViewFrame:(CGRect)frame
{
    frame.size.height -= self.tabbarHeight;
    return frame;
}


@end
