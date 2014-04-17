//
//  XTLib.h
//  iBMW
//
//  Created by xtool XTOOL on 13-1-30.
//  Copyright (c) 2013年 XTOOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum {
    UIDevice_iPhoneStandardRes = 1,       //iPhone 1, 3, 3GS (320*480)
    UIDevice_iPhoneHiRes = 2,             //iPhone 4, 4S (640*960)
    UIDevice_iPhoneTallerHiRes = 3,       //iPhone 5 (640*1136)
    UIDevice_iPadStandardRes = 4,         //iPad 1, 2 (1024*768)
    UIDevice_iPadHiRes = 5                //iPad 3 (2048*1536)
};
typedef NSUInteger UIDeviceResolution;

@interface XTLib : NSObject

+ (UIDeviceResolution)currentResolution;
+ (void)removeAllSubviews:(UIView *)view;

@end

@interface XTStatusBarImage : UIWindow
{
    UIImageView *_connectionImage;
}
- (id)init;
- (void)showConnectionImage:(NSString *)imageName;
- (void)hide;
- (void)willAnimateRotationToInterfaceOrientation;
@end

@interface XTStatusBarLabel : UIWindow
{
    UILabel *_messageLabel;
}
- (id)init;
- (void)showStatusMessage:(NSString *)message withAnimate:(BOOL)animate;
- (void)hideWithAnimate:(BOOL)animate;
- (void)willAnimateRotationToInterfaceOrientation;
@end

@interface XTProgressHUD : UIAlertView
{
    UIActivityIndicatorView *activityIndicator;
    UILabel *progressMessage;
}
- (id)init;
- (id)initWithLabel:(NSString *)text;
- (void)show;
- (void)dismiss;
- (void)setLableText:(NSString *)text;

@end