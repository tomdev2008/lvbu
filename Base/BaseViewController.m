//
//  BaseShowWaitViewController_iPhone.h

//
//  Created by imac on 12-7-27.
//  Copyright (c) 2012年 Twin-Fish. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end


@implementation BaseViewController

@synthesize waitBackgroundWindow;
@synthesize waitBackgroundView;
@dynamic hud;

- (MBProgressHUD*)hud
{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        
        /**
        if (self.navigationController) {
            [self.navigationController.view addSubview:_hud];
        } else {
            [self.view addSubview:_hud];
        }
         */
        
        [self.view addSubview:_hud];
     
    }
    return _hud;
}




#pragma mark - WaitView

- (void)showFullScreenWaitingView
{
    if (self.waitBackgroundWindow == nil) {
        CGRect frame = [UIScreen mainScreen].bounds;
        UIView *bgView = [[UIView alloc]initWithFrame:frame];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;

        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame) - 37) / 2 , (CGRectGetHeight(frame) - 37) / 2, 37, 37)];
        [activityView startAnimating];

        [bgView addSubview:activityView];
        self.waitBackgroundWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.waitBackgroundWindow.windowLevel = UIWindowLevelAlert;
        [self.waitBackgroundWindow addSubview:bgView];
        [self.waitBackgroundWindow makeKeyAndVisible];

    }
    else {
        MMLogDebug(@"%s (%u):already have waiting view", __FUNCTION__, __LINE__);
    }
}

- (void)hideFullScreenWaitingView
{
    self.waitBackgroundWindow = nil;
}


- (void)showWaitingView
{
    //开始等待动画
    if (self.waitBackgroundView == nil) {

        self.waitBackgroundView = [[UIView alloc] initWithFrame:[self.view bounds]];
        [self.waitBackgroundView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];

        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(0, 0, 37, 37);
        activityView.center = self.waitBackgroundView.center;

        [self.waitBackgroundView addSubview:activityView];
        [self.view addSubview:self.waitBackgroundView];
        [activityView startAnimating];

    } else {
        MMLogDebug(@"%s (%u):already have waiting view", __FUNCTION__, __LINE__);
    }
}

- (void)hideWaitingView
{
    //结束动画
    if (self.waitBackgroundView) {
        [self.waitBackgroundView removeFromSuperview];
        self.waitBackgroundView = nil;
    }
}

#pragma mark - MBProgressHUD

-(void)showHud
{
    self.hud.mode       = MBProgressHUDModeIndeterminate;
    self.hud.labelText  = @"";
    [self.hud show:YES];
}

-(void)hideHud
{
    [self.hud hide:YES];
}


- (void)showHudWithToostTitle:(NSString *)title
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    [hud show:YES];
    [hud hide:YES afterDelay:2.0];
}



- (void)registerKeyboardNotify
{
    //注册键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //注册键盘消失通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHiddenNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}


- (void)removeKeyboardNotify
{
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

//注册常用通知
- (void)registerCommonNotify
{

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeLanguageNotification:)
                                                 name:ChangeLanguageNotify
                                               object:nil];
}

//移除常用通知
- (void)removeCommonNotify
{

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ChangeLanguageNotify
                                                  object:nil];
}

#pragma mark -  UIKeyboardNotification

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    //键盘弹出
}

- (void)keyboardWillHiddenNotification:(NSNotification *)notification
{
    //键盘消失
}


#pragma mark - CommonNotification

- (void)changeLanguageNotification:(NSNotification *)notification
{
    //切换语言
}

#pragma mark - UIGesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([[touch view] isKindOfClass:[UITextField class]] ||
        [[touch view] isKindOfClass:[UIButton class]]) {
        return NO;
    } else {
        return YES;
    }
}


#pragma mark -Display Error
- (void)reportNetworkError:(NSError *)error
{
    if ([error.domain isEqualToString:NSURLErrorDomain])
    {
        switch (error.code) {
            case NSURLErrorCannotConnectToHost:
            case NSURLErrorCannotFindHost:
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorDNSLookupFailed:
            case NSURLErrorNotConnectedToInternet:
                [UIFactory showAlert:[UIFactory localized:@"Request_ConnectError"]];
                break;
                
            case NSURLErrorTimedOut:
                [UIFactory showAlert:[UIFactory localized:@"Request_TimeOutError"]];
                break;
                
            default:
                break;
        }
    } else {
        [UIFactory showAlert:[UIFactory localized:@"Request_ServerError"]];
    }
}



- (void)saveCurrentUser:(User *)user
{
    CommonVariable *commVars = [CommonVariable shareCommonVariable];
    commVars.curUser = user;
    [[NSUserDefaults standardUserDefaults] setValue:commVars.curUser.name forKey:KEY_CurrentUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (User *)getCurrentUser
{

    CommonVariable *commVars = [CommonVariable shareCommonVariable];
    if (commVars.curUser == nil) {
        NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_CurrentUserName];
        NSArray *userArr = [User findByAttribute:@"name" withValue:username];
        if ([userArr count] > 0) {
            commVars.curUser =  [userArr objectAtIndex:0];
        }
    }
    return commVars.curUser;
}

@end
