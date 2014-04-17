//
//  AppConfig.h
//  配置相关
//  Created by zzc on 12-3-23.
//  Copyright 2012年 Twin-Fish. All rights reserved.
//


#import "AppMacros.h"

//语言
#define KEY_DefaultLanguage             @"kDefaultLanguage"
#define Language_English                @"English"
#define Language_Chinese                @"chinese"

//称重单位
#define unit_kg @"unit_kg"
#define unit_lb @"unit_lb"

//NSUserDefault键值
#define KEY_IsFirstLaunch           @"keyIsFirstLaunch"
#define KEY_defaultScaleUnit        @"KeyDefaultScaleUnit"
#define KEY_defaultBleScale         @"KeyDefaultBleScale"
#define KEY_currentUserName         @"KeyCurrentUserName"


//通知
#define ChangeLanguageNotify    @"ChangeLanguageNotify"         //切换语言



#define DefaultHeadIconFileName         @"DefaultHeadIcon.png"




//appStore相关
#define kAPPID               284417350
#define kAPPCommentUrl       @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d"
#define kAPPCommentUrl_IOS7  @"itms-apps://itunes.apple.com/app/id%d"
#define kAPPUpdateUrl        @"http://itunes.apple.com/lookup?id=%d"


//长度限制
#define MAX_LOGIN_USERNAME_LENGTH       16
#define MAX_LOGIN_PASSWORD_LENGTH       16
#define MAX_LOGIN_EMAIL_LENGTH          64





//com.lanterscale.myWeight
#define NavigationBarDefaultHeight      ((isIP5Screen) ? 50.0f : 44.0f)
#define TabbarDefaultHeight             49.0f
#define GlobalNavBarBgColor  [UIColor colorWithRed:237/255.0 green:76/255.0 blue:73/255.0 alpha:1]




















