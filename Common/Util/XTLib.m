//
//  XTLib.m
//  iBMW
//
//  Created by xtool XTOOL on 13-1-30.
//  Copyright (c) 2013年 XTOOL. All rights reserved.
//

#import "XTLib.h"

@implementation XTLib

+ (UIDeviceResolution) currentResolution
{
    UIDeviceResolution resolution;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([UIScreen mainScreen].scale == 1.000000)
        {
            resolution = UIDevice_iPhoneStandardRes;
        }
        else
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            result = CGSizeMake(result.width*[UIScreen mainScreen].scale, result.height*[UIScreen mainScreen].scale);
            resolution = (result.height == 960 ? UIDevice_iPhoneHiRes : UIDevice_iPhoneTallerHiRes);
        }
    }
    else
    {
        if ([UIScreen mainScreen].scale == 1.000000)
            resolution = UIDevice_iPadStandardRes;
        else
            resolution = UIDevice_iPadHiRes;
    }
    return resolution;
}

+ (void) removeAllSubviews:(UIView *)view
{
    while (view.subviews.count)
    {
        UIView *child = view.subviews.lastObject;
        [child removeFromSuperview];
    }
}

@end

@implementation XTStatusBarImage

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        CGRect rect = [UIApplication sharedApplication].statusBarFrame;
        rect.origin.x = rect.size.width/2 + 40;
        rect.size.width = 20;
        self.frame = rect;
        self.backgroundColor = [UIColor clearColor];
        
        _connectionImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _connectionImage.backgroundColor = [UIColor clearColor];
        [self addSubview:_connectionImage];
    }
    return self;
}

- (void)willAnimateRotationToInterfaceOrientation
{
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortrait:
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                self.frame = CGRectMake(444, 0, 20, 20);
            }
            else{
                if ([XTLib currentResolution] == UIDevice_iPhoneTallerHiRes) {
                    self.frame = CGRectMake(200, 0, 20, 20);
                }
                else{
                    self.frame = CGRectMake(200, 0, 20, 20);
                }
            }
            _connectionImage.transform = CGAffineTransformMakeRotation(0.0*M_PI/180.0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                self.frame = CGRectMake(304, 1004, 20, 20);
            }
            else{
                if ([XTLib currentResolution] == UIDevice_iPhoneTallerHiRes) {
                    self.frame = CGRectMake(100, 548, 20, 20);
                }
                else{
                    self.frame = CGRectMake(100, 460, 20, 20);
                }
            }
            _connectionImage.transform = CGAffineTransformMakeRotation(90.0*2*M_PI/180.0);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                self.frame = CGRectMake(0, 404, 20, 20);
            }
            else{
                if ([XTLib currentResolution] == UIDevice_iPhoneTallerHiRes) {
                    self.frame = CGRectMake(0, 200, 20, 20);
                }
                else{
                    self.frame = CGRectMake(0, 160, 20, 20);
                }
            }
            _connectionImage.transform = CGAffineTransformMakeRotation(90.0*3*M_PI/180.0);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                self.frame = CGRectMake(748, 600, 20, 20);
            }
            else{
                if ([XTLib currentResolution] == UIDevice_iPhoneTallerHiRes) {
                    self.frame = CGRectMake(300, 348, 20, 20);
                }
                else{
                    self.frame = CGRectMake(300, 300, 20, 20);
                }
            }
            _connectionImage.transform = CGAffineTransformMakeRotation(90.0*M_PI/180.0);
            break;
            
        default:
            break;
    }
}

- (void)showConnectionImage:(NSString *)imageName
{
    self.hidden = NO;
    self.alpha = 1.0f;
    _connectionImage.image = [UIImage imageNamed:imageName];
}

- (void)hide
{
    _connectionImage.image = nil;
    self.alpha = 0.0f;
    self.hidden = YES;
}

- (void)dealloc
{
    [_connectionImage release];
    [super dealloc];
}

@end


@implementation XTStatusBarLabel

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        CGRect rect = [UIApplication sharedApplication].statusBarFrame;
        rect.origin.x = rect.size.width/2 + 60;
        rect.size.width = rect.size.width/2 - 60;
        self.frame = rect;
        //self.backgroundColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
        
        rect = [UIApplication sharedApplication].statusBarFrame;
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width/2 - 60, rect.size.height)];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = [UIColor blueColor];
        _messageLabel.font = [UIFont systemFontOfSize:15.0f];
        _messageLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_messageLabel];
    }
    return self;
}

- (void)willAnimateRotationToInterfaceOrientation
{
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortrait:
            _messageLabel.transform = CGAffineTransformMakeRotation(0.0*M_PI/180.0);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                self.frame = CGRectMake(464, 0, 200.0,20.0);
                _messageLabel.frame = CGRectMake(0, 0, 200, 20);
            }
            else{
                _messageLabel.frame = CGRectMake(0, 0, 100, 20);
                if ([XTLib currentResolution] == UIDevice_iPhoneTallerHiRes) {
                    self.frame = CGRectMake(200, 0, 100, 20);
                }
                else{
                    self.frame = CGRectMake(200, 0, 100, 20);
                }
            }
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            _messageLabel.transform = CGAffineTransformMakeRotation(90.0*2*M_PI/180.0);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                self.frame = CGRectMake(104, 1004, 200.0,20.0);
                _messageLabel.frame = CGRectMake(0, 0, 200, 20);
            }
            else{
                _messageLabel.frame = CGRectMake(0, 0, 100, 20);
                if ([XTLib currentResolution] == UIDevice_iPhoneTallerHiRes) {
                    self.frame = CGRectMake(0, 548, 100, 20);
                }
                else{
                    self.frame = CGRectMake(0, 460, 100, 20);
                }
            }
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            _messageLabel.transform = CGAffineTransformMakeRotation(90.0*3*M_PI/180.0);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                self.frame = CGRectMake(0, 204,20.0, 200.0);
                _messageLabel.frame = CGRectMake(0, 0, 20, 200);
            }
            else{
                _messageLabel.frame = CGRectMake(0, 0, 20, 100);
                if ([XTLib currentResolution] == UIDevice_iPhoneTallerHiRes) {
                    self.frame = CGRectMake(0, 100, 20, 100);
                }
                else{
                    self.frame = CGRectMake(0, 60, 20, 100);
                }
            }
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            _messageLabel.transform = CGAffineTransformMakeRotation(90.0*M_PI/180.0);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                self.frame = CGRectMake(748, 620,20.0, 200.0);
                _messageLabel.frame = CGRectMake(0, 0, 20, 200);
            }
            else{
                _messageLabel.frame = CGRectMake(0, 0, 20, 100);
                if ([XTLib currentResolution] == UIDevice_iPhoneTallerHiRes) {
                    self.frame = CGRectMake(300, 368, 20, 100);
                }
                else{
                    self.frame = CGRectMake(300, 320, 20, 100);
                }
            }
            break;
            
        default:
            break;
    }
}

- (void)showStatusMessage:(NSString *)message withAnimate:(BOOL)animate
{
    if (animate)
    {
        self.hidden = NO;
        self.alpha = 1.0f;
        _messageLabel.text = @"";
        
        CGSize totalSize = self.frame.size;
        self.frame = (CGRect){ self.frame.origin, 0, totalSize.height };
        
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = (CGRect){ self.frame.origin, totalSize };
        } completion:^(BOOL finished){
            _messageLabel.text = message;
        }];
    }
    else
    {
        self.hidden = NO;
        self.alpha = 1.0f;
        _messageLabel.text = message;
    }
}

- (void)hideWithAnimate:(BOOL)animate
{
    if (animate)
    {
        self.alpha = 1.0f;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished){
            _messageLabel.text = @"";
            self.hidden = YES;
        }];;
    }
    else
    {
        self.hidden = NO;
        self.alpha = 1.0f;
        _messageLabel.text = @"";
    }
}

- (void)dealloc
{
    [_messageLabel release];
    [super dealloc];
}
@end

@implementation XTProgressHUD

- (id)init
{
    return [self initWithLabel:nil];
}

- (id)initWithLabel:(NSString *)text
{
    if (self = [super init]) {
        progressMessage = [[UILabel alloc] initWithFrame:CGRectZero];
        progressMessage.textColor = [UIColor whiteColor];
        progressMessage.backgroundColor = [UIColor clearColor];
        progressMessage.text = text;
        progressMessage.font = [UIFont systemFontOfSize:15];
        progressMessage.textAlignment = NSTextAlignmentCenter;
        progressMessage.numberOfLines = 0;
        [self addSubview:progressMessage];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator startAnimating];
        [self addSubview:activityIndicator];
    }
    
    return self;
}

- (void)setLableText:(NSString *)text
{
    progressMessage.text = text;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [progressMessage sizeToFit];
    progressMessage.frame = CGRectMake(activityIndicator.frame.size.width+20,0,240-activityIndicator.frame.size.width-25,100);
    
    CGRect activityRect = activityIndicator.frame;
    activityRect.origin.x = 15;
    activityRect.origin.y = (100-activityIndicator.frame.size.height)/2;
    
    self.bounds = CGRectMake(0, 0, 240, 100);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.bounds = CGRectMake(0, 0, 300, 100);
        progressMessage.font = [UIFont systemFontOfSize:17];
        progressMessage.frame = CGRectMake(activityIndicator.frame.size.width+20,0,300-activityIndicator.frame.size.width-25,100);
    }
    activityIndicator.frame = activityRect;
    [self bringSubviewToFront:activityIndicator];
}

- (void)show
{
    [super show];
    self.bounds = CGRectMake(0, 0, 240, 100);
}

- (void)dismiss
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dealloc
{
    [activityIndicator release];
    [progressMessage release];
    [super dealloc];
}

@end
