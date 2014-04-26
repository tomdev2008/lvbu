//
//  UIFactory.m
//
//  Created by zzc on 12-3-30.
//  Copyright (c) 2012年 Twin-Fish. All rights reserved.
//

#import "UIFactory.h"
#import "AppConstants.h"
#import "Reachability.h"
#import "NSData+SSToolkitAdditions.h"
#import <arpa/inet.h>
#import <sys/sysctl.h>
#import <AudioToolbox/AudioToolbox.h>


@implementation UIImage (Additions)

+ (UIImage *)imageNamedNoCache:(NSString *)imageName
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *filePath = nil;
    if ([imageName hasSuffix:@"png"]) {
        filePath = [NSString stringWithFormat:@"%@/%@", bundlePath, imageName];
    } else {
        filePath = [NSString stringWithFormat:@"%@/%@.png",bundlePath, imageName];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}

@end;


static UIFactory* factory;

@implementation UIFactory

+ (UIFactory*)sharedUIFactory{
    
    if(factory == nil)
        factory = [[UIFactory alloc]init];
    return factory;
}


#pragma mark - Create Lable


+ (id)createLabelWith:(CGRect)frame text:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    return label;
}

+ (id)createLabelWith:(CGRect)frame
                 text:(NSString *)text
      backgroundColor:(UIColor *)backgroundColor {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.backgroundColor = backgroundColor;
    return label;
}


+ (id)createLabelWith:(CGRect)frame
                 text:(NSString *)text
                 font:(UIFont *)font
            textColor:(UIColor *)textColor
      backgroundColor:(UIColor *)backgroundColor {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    label.text      = text;
    label.font      = font;
    label.textColor = textColor;
    label.backgroundColor = backgroundColor;
    
    return label;
}


+ (id)createLabelWithOrigin:(CGPoint)originPoint
                       text:(NSString *)text
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor
            backgroundColor:(UIColor *)backgroundColor {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.text              = text;
    label.font              = font;
    label.textColor         = textColor;
    label.frame             = CGRectMake(originPoint.x, originPoint.y, 0, 0);
    label.backgroundColor   = backgroundColor;
    
    [label sizeToFit];
    return label;
}

#pragma mark - Create TextField

+ (UITextField *)createTextFieldWithRect:(CGRect)frame
                            keyboardType:(UIKeyboardType)keyboardType
                                  secure:(BOOL)secure
                             placeholder:(NSString *)placeholder
                                    font:(UIFont *)font
                                   color:(UIColor *)color
                                delegate:(id)delegate
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    if (delegate != nil) {
        textField.delegate          = delegate;
        textField.font              = font;
        textField.textColor         = color;
        textField.placeholder       = placeholder;
        textField.keyboardType      = keyboardType;
        textField.returnKeyType     = UIReturnKeyNext;
        textField.secureTextEntry   = secure;
        
        // Default property
        textField.enablesReturnKeyAutomatically = YES;
        textField.contentVerticalAlignment      = UIControlContentVerticalAlignmentCenter;
        textField.clearButtonMode               = UITextFieldViewModeWhileEditing;
        textField.borderStyle                   = UITextBorderStyleNone;
        textField.autocapitalizationType        = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType            = UITextAutocorrectionTypeNo;
    }
    
    return textField;
}





#pragma mark - Create Button

+ (UIImage*)resizableImageWithSize:(CGSize)size
                             image:(NSString*)imageName
{
    UIImage *image = nil;
    if (imageName == nil) {
        return nil;
    } else {
        image = [UIImage imageNamedNoCache:imageName];
    }

    if ([image respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        
        /**
         - (UIImage *)resizableImageCapInsets:(UIEdgeInsets)Insets
         其中Insets这个参数的格式是(top,left,bottom,right)，从上、左、下、右分别在图片上画了一道线，
         这样就给一个图片指定了一个矩形区域。只有在框里面的部分才会被拉伸，而框外面的部分则保持改变。
         */
        return [image resizableImageWithCapInsets:UIEdgeInsetsMake(size.height, size.width, size.height, size.width)];
    } else {
        
        /**
         - (UIImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight
         这个函数是UIImage的一个实例函数，它的功能是创建一个内容可拉伸，而边角不拉伸的图片，需要两个参数，第一个是不拉伸区域距离左边框的宽度，
         第二个参数是不拉伸区域距离上边框的高度，其操作本质是对一个像素的复制拉伸，故没有渐变效果，这也是其缺点所在。
         注意：只是对一个点像素进行复制到指定的宽度。
         */
        return [image stretchableImageWithLeftCapWidth:size.width topCapHeight:size.height];
    }
}


//Button(只有背景图)
+ (UIButton *)createButtonWithRect:(CGRect)frame
                            normal:(NSString *)normalImage
                         highlight:(NSString *)clickIamge
                          selector:(SEL)selector
                            target:(id)target
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    if (normalImage != nil)
        [button setBackgroundImage:[UIImage imageNamedNoCache:normalImage]
                          forState:UIControlStateNormal];
    
    if (clickIamge != nil)
        [button setBackgroundImage:[UIImage imageNamedNoCache:clickIamge]
                          forState:UIControlStateHighlighted];
    
    if ((selector != nil) && (target != nil))
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


//Button(标题+背景图)
+ (UIButton *)createButtonWithRect:(CGRect)frame 
                             title:(NSString *)title
                         titleFont:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                            normal:(NSString *)normalImage
                         highlight:(NSString *)highLightIamge
                          selected:(NSString *)selectedImage
                          selector:(SEL)selector
                            target:(id)target
{    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (title != nil)
        [button setTitle:title forState:UIControlStateNormal];
    
    if (titleColor != nil)
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    if (font != nil)
        [button.titleLabel setFont:font];
    
    if (normalImage != nil)
        [button setBackgroundImage:[UIImage imageNamedNoCache:normalImage]
                          forState:UIControlStateNormal];
    
    if (highLightIamge != nil) {
        [button setBackgroundImage:[UIImage imageNamedNoCache:highLightIamge]
                          forState:UIControlStateSelected];
    }
    
    if (selectedImage != nil)
        [button setBackgroundImage:[UIImage imageNamedNoCache:selectedImage]
                          forState:UIControlStateSelected];
    
    if ((selector != nil) && (target != nil))
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


//Button(标题+图标+背景)
+ (UIButton *)createButtonWithRect:(CGRect)frame
                             title:(NSString *)title
                         titleFont:(UIFont  *)font
                  titleColorNormal:(UIColor *)titleColorNormal
               titleColorHighLight:(UIColor *)titleColorHighLight
                       normalImage:(NSString *)normalImage
                    highlightImage:(NSString *)highlightImage
             backgroundImageNormal:(NSString *)backgroundImageNormal
          backgroundImageHighLight:(NSString *)backgroundImageHighLight
                          selector:(SEL)selector
                            target:(id)target
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    if (title != nil) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    if (font != nil) {
        [button.titleLabel setFont:font];
    }
    
    if (titleColorNormal != nil) {
        [button setTitleColor:titleColorNormal
                     forState:UIControlStateNormal];
    }
    
    if (titleColorHighLight != nil) {
        [button setTitleColor:titleColorHighLight
                     forState:UIControlStateHighlighted];
    }
    
    if (normalImage != nil) {
        [button setImage:[UIImage imageNamedNoCache:normalImage]
                forState:UIControlStateNormal];
    }
    
    if (highlightImage != nil) {
        [button setImage:[UIImage imageNamedNoCache:highlightImage]
                forState:UIControlStateHighlighted];
    }
    
    if (backgroundImageNormal != nil) {
        [button setBackgroundImage:[UIImage imageNamedNoCache:backgroundImageNormal]
                          forState:UIControlStateNormal];
    }
    
    if (backgroundImageHighLight != nil) {
        [button setBackgroundImage:[UIImage imageNamedNoCache:backgroundImageHighLight]
                          forState:UIControlStateHighlighted];
    }
    
    if (selector != nil) {
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
}



+ (UIButton *)createButtonWithRect:(CGRect)frame
                             title:(NSString *)title
                         titleFont:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                            normal:(NSString *)normalImage
                         highlight:(NSString *)clickIamge
                             fixed:(CGSize)fixedSize
                          selector:(SEL)selector
                            target:(id)target
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    if (title != nil)
        [button setTitle:title forState:UIControlStateNormal];
    
    if (titleColor != nil)
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    if (font != nil)
        [button.titleLabel setFont:font];
    
    if (normalImage != nil) {
        [button setBackgroundImage:[UIFactory resizableImageWithSize:fixedSize image:normalImage]
                          forState:UIControlStateNormal];
    }
    
    if (clickIamge != nil) {
        [button setBackgroundImage:[UIFactory resizableImageWithSize:fixedSize image:clickIamge]
                          forState:UIControlStateHighlighted];
    }
    
    if ((selector != nil) && (target != nil))
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}



+ (UIImageView *)createImageViewWithRect:(CGRect)frame
                                   image:(NSString *)image
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    if (image != nil) {
        [imgView setImage:[UIImage imageNamed:image]];
    }
    return imgView;
}

#pragma mark - Show Alert
+ (void)showAlert:(NSString *)message
{
    UIAlertView *view =  [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:[self localized:@"Alert_Ok"]
                                          otherButtonTitles:nil];
    [view show];
}

+ (void)showAlert:(NSString *)message tag:(NSUInteger)tag delegate:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:[self localized:@"Alert_Ok"]
                                              otherButtonTitles:nil];
    alertView.tag = tag;
    [alertView show];
}

+ (void)showConfirm:(NSString *)message tag:(NSUInteger)tag delegate:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:[self localized:@"Alert_Cancel"]
                                              otherButtonTitles:[self localized:@"Alert_Ok"], nil];
    alertView.tag = tag;
    [alertView show];
}








#pragma mark - Common Function



#pragma mark - Check IP/Port

+ (BOOL)isValidIPAddress:(NSString *)address
{
    if ([address length] < 1)
        return NO;
    
    struct in_addr addr;
    return (inet_aton([address UTF8String], &addr) == 1);
}

+ (BOOL)isValidPortAddress:(NSString *)address
{
    
    if ([address length] < 1)
        return NO;
    
    NSScanner * scanner = [NSScanner scannerWithString:address];
    if ([scanner scanInt:nil] && [scanner isAtEnd]) {
        return (1 <= [address integerValue]) && ([address integerValue] <= 255);
    }
    
    return NO;
    
}


#pragma mark  Common utilities

+ (BOOL)isEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

+ (BOOL)isEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}


+ (BOOL)isRetina
{
    int scale = 1.0;
    UIScreen *screen = [UIScreen mainScreen];
    if ([screen respondsToSelector:@selector(scale)]) {
        scale = screen.scale;
    }
    if (scale == 2.0f) {
        return YES;
    }
    return NO;
}


+(float)getSystemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}



+ (NSString *)localized:(NSString *)key
{
    NSString *langCode      = @"zh-Hans";
    NSString *appLanguage   = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_DefaultLanguage];
    
    if ([appLanguage isEqualToString:Language_English] == YES) {
        langCode = @"en";
    } else if ([appLanguage isEqualToString:Language_Chinese] == YES) {
        langCode = @"zh-Hans";
    }
    NSString *path           = [[NSBundle mainBundle] pathForResource:langCode ofType:@"lproj"];
    NSBundle *languageBundle = [NSBundle bundleWithPath:path];
    return [languageBundle localizedStringForKey:key value:@"" table:nil];
}

+(NSString *)getDeviceTokenFromData:(NSData *)deviceToken
{
    
    //获取APNS设备令牌
    NSMutableString * deviceTokenStr = [NSMutableString stringWithFormat:@"%@",deviceToken];
    NSRange allRang;
    allRang.location    = 0;
    allRang.length      = deviceTokenStr.length;
    
    [deviceTokenStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:allRang];
    
    NSRange begin   = [deviceTokenStr rangeOfString:@"<"];
    NSRange end     = [deviceTokenStr rangeOfString:@">"];
    
    NSRange deviceRange;
    deviceRange.location    = begin.location + 1;
    deviceRange.length      = end.location - begin.location -1;
    
    return [deviceTokenStr substringWithRange:deviceRange];
}


+(void)invokeVibration
{
    //TODO: 振动调用
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

+(void)showAppCommentWithAppID:(int)appID
{
    //显示AppStore应用评论
    NSString *appUrlStr = [NSString stringWithFormat:kAPPCommentUrl, appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrlStr]];
    
}

+ (void)call:(NSString *)telephoneNum
{
    NSString *str = [NSString stringWithFormat:@"tel://%@", telephoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (void)sendSMS:(NSString *)telephoneNum
{
    NSString *str = [NSString stringWithFormat:@"sms://%@", telephoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (void)sendEmail:(NSString *)emailAddr
{
    NSString *str = [NSString stringWithFormat:@"mailto://%@", emailAddr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (void)openUrl:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+(NSStringEncoding)getGBKEncoding
{
    
    //获得中文gbk编码
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return enc;
    
}


#pragma mark --加密解密

#define kAES256EncryptKey @"opqrstuvwxyzabcdefghijklmn"

//加密
+ (NSData *)useAES256Encrypt:(NSString *)plainText
{
    NSData *res = nil;
    if (plainText) {
        NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        res = [plainData AES256EncryptWithKey:kAES256EncryptKey];
    }
    return res;
}

//解密
+ (NSString *)useAES256Decrypt:(NSData *)cipherData
{
    NSString *res = nil;
    if ((cipherData != nil) && ([cipherData length] > 0)) {
        NSData *plainData = [cipherData AES256DecryptWithKey:kAES256EncryptKey];
        res = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    }
    return res;
}

@end