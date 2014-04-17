//
//  AppMacros.h
//  代码宏定义
//  Created by apple on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//






//应用委托
#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)


//设备相关
#define isIPad          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isIPhone        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define isIP5Screen     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)

//系统版本和语言
#define IOS7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#define kSystemVersion   ([[UIDevice currentDevice] systemVersion])
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//应用名称和版本
#define kAPPName         [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define kAPPVersion      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//设备屏幕尺寸
#define kScreenWidth      ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight     ([UIScreen mainScreen].bounds.size.height)


//以tag读取View
#define kViewByTag(parentView, tag, Class)  (Class *)[parentView viewWithTag:tag]

//读取Xib文件的类
#define kViewByNib(Class, owner, index) [[[NSBundle mainBundle] loadNibNamed:Class owner:owner options:nil] objectAtIndex:index]


//度弧度转换
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
#define kRadianToDegrees(radian) (radian*180.0) / (M_PI)

//GCD
#define kGCDBackground(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define kGCDMain(block)       dispatch_async(dispatch_get_main_queue(),block)

//颜色
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//安全释放
#define MM_RELEASE_SAFELY(__POINTER) {  [__POINTER release]; __POINTER = nil; }

//计时器
#define MM_INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }

//单例
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
        + (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
        + (__class *)sharedInstance \
        { \
            static dispatch_once_t once; \
            static __class * __singleton__; \
            dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
            return __singleton__; \
        }








