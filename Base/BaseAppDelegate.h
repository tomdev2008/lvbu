//
//  baseAppDelegate.h
//
//  Created by apple on 13-3-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#include <execinfo.h> 
#import "AppCore.h"

@interface BaseAppDelegate : NSObject<UIApplicationDelegate>
{
    Reachability *_wifiReachability;
    NetworkStatus _lastNetStatus;
}

- (void)initApp;
- (void)configApp;
- (void)sendTokenToServer:(NSString *)token;


- (void)firstLanch;
- (void)urlLanch;
- (void)normalLanch;


@end

void uncaughtExceptionHandler(NSException *exception);
void stacktrace(int sig, siginfo_t *info, void *context);