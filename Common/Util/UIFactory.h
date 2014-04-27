//
//  UIFactory.h
//
//  Created by zzc on 12-3-30.
//  Copyright (c) 2012年 Twin-Fish. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (Additions)

+ (UIImage *)imageNamedNoCache:(NSString *)imageName;

@end;


@interface UIFactory : NSObject

+ (UIFactory*)sharedUIFactory;

+ (id)createLabelWith:(CGRect)frame
                 text:(NSString *)text;

+ (id)createLabelWith:(CGRect)frame
                 text:(NSString *)text
      backgroundColor:(UIColor *)backgroundColor;


+ (id)createLabelWith:(CGRect)frame
                 text:(NSString *)text
                 font:(UIFont *)font
            textColor:(UIColor *)textColor
      backgroundColor:(UIColor *)backgroundColor;


+ (id)createLabelWithOrigin:(CGPoint)originPoint
                       text:(NSString *)text
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor
            backgroundColor:(UIColor *)backgroundColor;



//TextField
+ (id)createTextFieldWithRect:(CGRect)frame
                 keyboardType:(UIKeyboardType)keyboardType
                       secure:(BOOL)secure
                  placeholder:(NSString *)placeholder
                         font:(UIFont *)font
                        color:(UIColor *)color
                     delegate:(id)delegate;



//Image拉伸
+ (UIImage*)resizableImageWithSize:(CGSize)size
                             image:(NSString*)image;


//Button(只有背景图)
+ (UIButton *)createButtonWithRect:(CGRect)frame
                            normal:(NSString *)normalImage
                         highlight:(NSString *)clickIamge
                          selector:(SEL)selector
                            target:(id)target;

//Button(标题+背景图)
+ (UIButton *)createButtonWithRect:(CGRect)frame 
                             title:(NSString *)title
                         titleFont:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                            normal:(NSString *)normalImage
                         highlight:(NSString *)highLightIamge
                          selected:(NSString *)clickIamge
                          selector:(SEL)selector
                            target:(id)target;


+ (UIButton *)createButtonWithRect:(CGRect)frame
                             title:(NSString *)title
                         titleFont:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                            normal:(NSString *)normalImage
                         highlight:(NSString *)clickIamge
                             fixed:(CGSize)fixedSize
                          selector:(SEL)selector
                            target:(id)target;


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
                            target:(id)target;


+ (UIImageView *)createImageViewWithRect:(CGRect)frame
                                   image:(NSString *)image;

//Alert提示
+ (void)showAlert:(NSString *)message;
+ (void)showAlert:(NSString *)message tag:(NSUInteger)tag delegate:(id)delegate;
+ (void)showConfirm:(NSString *)message tag:(NSUInteger)tag delegate:(id)delegate;



#pragma mark - Common Function

+ (BOOL)isValidIPAddress:(NSString *)address;                   //校验IP
+ (BOOL)isValidPortAddress:(NSString *)address;                 //校验Port
+ (BOOL)isEnable3G;                                             //是否开启3G
+ (BOOL)isEnableWIFI;                                           //是否开启WIFI
+ (BOOL)isRetina;                                               //是否Retina屏
+ (float)getSystemVersion;                                      //获得系统版本

+ (NSString *)localized:(NSString *)key;                        //本地化
+ (NSString *)getDeviceTokenFromData:(NSData *)deviceToken;     //获取APNS设备令牌

+ (void)showAppCommentWithAppID:(int)appID;                     //显示AppStore应用评论
+ (void)invokeVibration;                                        //震动
+ (void)call:(NSString *)telephoneNum;                          //拨打电话
+ (void)sendSMS:(NSString *)telephoneNum;                       //发送短信
+ (void)sendEmail:(NSString *)emailAddr;                        //发送邮件
+ (void)openUrl:(NSString *)url;                                //打开网页

+ (NSStringEncoding)getGBKEncoding;                             //获得中文gbk编码

+ (NSData *)useAES256Encrypt:(NSString *)plainText;             //加密
+ (NSString *)useAES256Decrypt:(NSData *)cipherData;            //解密


+ (NSString *)getAvatarFilePath;


@end





