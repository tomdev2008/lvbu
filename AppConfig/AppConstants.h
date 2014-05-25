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
#define DefaultHeadIconFileName         @"DefaultHeadIcon.png"


//NSUserDefault键值
#define KEY_IsFirstLaunch           @"keyIsFirstLaunch"
#define KEY_CurrentUserName         @"KeyCurrentUserName"
#define KEY_CurrentPassword         @"KeyCurrentPassword"
#define KEY_CurrentUserid           @"keyCurrentUserid"


#define KEY_GLOBAL_SESSIONCODE      @"KeyGlobalSessionCode"


//通知
#define ChangeLanguageNotify        @"ChangeLanguageNotify"         //切换语言





//appStore相关
#define kAPPID               284417350
#define kAPPCommentUrl       @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d"
#define kAPPCommentUrl_IOS7  @"itms-apps://itunes.apple.com/app/id%d"
#define kAPPUpdateUrl        @"http://itunes.apple.com/lookup?id=%d"


//长度限制
#define MAX_LOGIN_USERNAME_LENGTH       16
#define MAX_LOGIN_PASSWORD_LENGTH       16
#define MAX_LOGIN_EMAIL_LENGTH          64


#define NavigationBarDefaultHeight      ((isIP5Screen) ? 44.0f : 44.0f)
#define TabbarDefaultHeight             49.0f
#define GlobalNavBarBgColor  [UIColor colorWithRed:2/255.0 green:82/255.0 blue:152/255.0 alpha:1]



/******************************推送消息类型*****************************************************/
//推送消息类型
enum PUSHMESSAGETYPE {
    PUSHMESSAGE_TYPE_TEXT = 0,
    PUSHMESSAGE_TYPE_LONGTEXT,
    PUSHMESSAGE_TYPE_VOICEURL,
    PUSHMESSAGE_TYPE_IMAGEURL,
    PUSHMESSAGE_TYPE_SYSTEM,
    PUSHMESSAGE_TYPE_INVITENOTIFY,
    };

/******************************推送消息功能号*****************************************************/
//系统
#define PUSHMESSAGE_FUNC_SYSTEM_ADD_FANS        @"add_fans"
#define PUSHMESSAGE_FUNC_SYSTEM_CHG_STATUS      @"chg_status"
#define PUSHMESSAGE_FUNC_SYSTEM_RECOMMAND       @"recommand"

//伴跑状态
#define PUSHMESSAGE_FUNC_PARTNER_INVITE_RUN      @"invite_run"
#define PUSHMESSAGE_FUNC_PARTNER_INVITE_CANCEL   @"invite_cancel"
#define PUSHMESSAGE_FUNC_PARTNER_INVITE_RET      @"invite_ret"

//伴跑，群跑消息
#define PUSHMESSAGE_FUNC_IM_TEXT                @"im_text"
#define PUSHMESSAGE_FUNC_IM_VOICE               @"im_voice"
#define PUSHMESSAGE_FUNC_IM_IMAGE               @"im_image"


/*************************************消息分发对应的通知类型***********************************************************/
#define KPUSHMESSAGENOTIFY_SYSTEM_ADD_FANS              @"kPushMessageNotify_system_addfans"
#define KPUSHMESSAGENOTIFY_SYSTEM_CHG_STATUS            @"kPushMessageNotify_system_chgstatus"
#define KPUSHMESSAGENOTIFY_SYSTEM_RECOMMAND             @"kPushMessageNotify_system_recommand"
#define KPUSHMESSAGENOTIFY_PARTNER_INVITE_RUN           @"kPushMessageNotify_partner_invite_run"
#define KPUSHMESSAGENOTIFY_PARTNER_INVITE_CANCEL        @"kPushMessageNotify_partner_invite_cancel"
#define KPUSHMESSAGENOTIFY_PARTNER_INVITE_RET           @"kPushMessageNotify_partner_invite_ret"
#define KPUSHMESSAGENOTIFY_IM_TEXT                      @"kPushMessageNotify_system_im_text"
#define KPUSHMESSAGENOTIFY_IM_VOICE                     @"kPushMessageNotify_system_im_voice"
#define KPUSHMESSAGENOTIFY_IM_IMAGE                     @"kPushMessageNotify_system_im_image"













