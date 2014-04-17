//
//  BaseShowWaitViewController_iPhone.h
//
//  Created by imac on 12-7-27.
//  Copyright (c) 2012年 Twin-Fish. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppCore.h"
#import "MBProgressHUD.h"



@interface BaseViewController : UIViewController
{
    
    MBProgressHUD *_hud;
}

@property (nonatomic, retain) UIWindow          *waitBackgroundWindow;
@property (nonatomic, retain) UIView            *waitBackgroundView;
@property (nonatomic, readonly) MBProgressHUD   *hud;


- (void)showFullScreenWaitingView;
- (void)hideFullScreenWaitingView;

- (void)showWaitingView;
- (void)hideWaitingView;

- (void)showHud;
- (void)hideHud;

- (void)showHudWithToostTitle:(NSString *)title;


- (void)registerKeyboardNotify;
- (void)removeKeyboardNotify;

- (void)reportNetworkError:(NSError *)error;


- (void)saveCurrentUser:(User *)user;
- (User *)getCurrentUser;


@end
