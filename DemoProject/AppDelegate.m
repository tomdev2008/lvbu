//
//  AppDelegate.m
//  DemoProject
//
//  Created by apple on 13-6-2.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "AppCore.h"
#import "AppDelegate.h"

#import "SplashViewController.h"
#import "MainViewController.h"


static NSInteger count = 0;
static NSString * const lvbuStoreName = @"LvbuDatabase.sqlite";


@interface AppDelegate()

@property(nonatomic, strong)NSDateFormatter *formatter;

@end

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initApp];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    //coredata初始化
    [self copyDefaultStoreIfNecessary];
    [MagicalRecord setupCoreDataStackWithStoreNamed:lvbuStoreName];
    

    //初始化各个主界面
    self.mainVC = [[MainViewController alloc] init];
    self.parterVC = [[PartnerViewController alloc] init];
//    self.moreVC = [[MoreViewController alloc] init];
    self.leftVC = [[LeftViewController alloc] init];
    
    self.rootNav = [[UINavigationController alloc] initWithRootViewController:self.mainVC];
    self.viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:self.rootNav
                                                                      leftViewController:self.leftVC];
    
    self.viewDeckController.leftSize = self.window.width - (320 - 44.0);

    
    //暂时先隐藏导航栏
    [self.rootNav setNavigationBarHidden:YES];

    self.window.rootViewController = self.viewDeckController;

    NSString *isFirstLaunch = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_IsFirstLaunch];
    if (isFirstLaunch == nil /*|| ![isFirstLaunch isEqualToString:@"NO"]*/) {
        
        //第一次启动
        [self firstLanch];
    } else {
        
        //启动方式
        if ((launchOptions != nil) && ([launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"] != nil)) {
            
            //URL启动或者推送消息启动
            [self urlLanch];
        } else {
            
            //正常启动
            [self normalLanch];
        }
    }
    
    
    //自定义导航栏的话，设置全局自定义导航栏高度
    [[AdaptiverServer sharedInstance] setCustomNavBarHeight:NavigationBarDefaultHeight];
    [[AdaptiverServer sharedInstance] setCustomTarBarHeight:TabbarDefaultHeight];
    
    
    //注册消息推送
    
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                           UIRemoteNotificationTypeSound |
                                                                           UIRemoteNotificationTypeAlert)];
    application.applicationIconBadgeNumber = 0;

    [self.window makeKeyAndVisible];
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    NSLog(@"App started with URL...");
    NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSScanner *scanner = [[NSScanner alloc] initWithString:[url query]];
    
    
    /*解析URL中参数*/
    while (![scanner isAtEnd]) {
        NSString *pairStr = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairStr];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        
        NSArray *kvPair = [pairStr componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString *key   = [[kvPair objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = [[kvPair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:value forKey:key];
        }
    }
    
    return YES;
}



- (void)applicationDidEnterBackground:(UIApplication *)application
{

    //开启一个后台任务
    backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
    }];
    oldBackgroundTaskIdentifier = backgroundTaskIdentifier;
    if ([self.myTimer isValid]) {
        [self.myTimer invalidate];
    }
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(timerMethod:)
                                                  userInfo:nil
                                                   repeats:YES];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{

    if (backgroundTaskIdentifier != UIBackgroundTaskInvalid){
        [application endBackgroundTask:backgroundTaskIdentifier];
        if ([self.myTimer isValid]) {
            [self.myTimer invalidate];
            self.myTimer = nil;
        }
    }
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    //[MagicalRecord cleanUp];
}




- (void) copyDefaultStoreIfNecessary
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:lvbuStoreName];
    
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:[storeURL path]])
    {

		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:[lvbuStoreName stringByDeletingPathExtension] ofType:[lvbuStoreName pathExtension]];
        
		if (defaultStorePath)
        {
            NSError *error;
			BOOL success = [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:&error];
            if (!success)
            {
                NSLog(@"Failed to install default recipe store");
            }
		}
	}
    
}



- (void) timerMethod:(NSTimer *)paramSender{
    count++;
    if (count % 500 == 0) {
        UIApplication *application = [UIApplication sharedApplication];
        //开启一个新的后台
        backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
            
        }];
        //结束旧的后台任务
        [application endBackgroundTask:oldBackgroundTaskIdentifier];
        oldBackgroundTaskIdentifier = backgroundTaskIdentifier;
    }
    NSLog(@"%ld",(long)count);
}


#pragma mark - private



#pragma mark - BaseAppdelegate

- (void)configApp
{
    //配置应用
}

- (void)sendTokenToServer:(NSString *)token
{
    //发送token给服务器
}

- (void)firstLanch
{
    //第一次启动
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.rootNav pushViewController:loginVC animated:NO];
}

- (void)urlLanch
{
    //url或者消息推送启动
}

- (void)normalLanch
{
    //正常启动
    SplashViewController *splashVC = [[SplashViewController alloc] init];
    [self.rootNav pushViewController:splashVC animated:YES];
    self.rootNav.navigationBarHidden = YES;

}



#pragma mark - push message
-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
//    NSString *newToken = [UIFactory getDeviceTokenFromData:deviceToken];
//    [self sendTokenToServer:newToken];
    
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannel];
}


-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    MMLogDebug(@"获得令牌失败: %@", error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Receive Notify: %@", [userInfo JSONString]);
    NSDictionary *apsDic = [userInfo objectForKey:@"aps"];
    if (apsDic != nil) {
        PushMessage *pushMsg = [PushMessage createEntity];

        //获取本地当前时间
        NSDate * date = [NSDate date];
        NSString * dateString = [self.formatter stringFromDate:date];
        pushMsg.tick = dateString;
        
        pushMsg.alert = [apsDic objectForKey:@"alert"];
        pushMsg.badge = [apsDic objectForKey:@"badge"];
        pushMsg.sound = [apsDic objectForKey:@"sound"];;
        
        pushMsg.src     = [userInfo objectForKey:@"src"];
        pushMsg.dst     = [userInfo objectForKey:@"dst"];
        pushMsg.msgid   = [userInfo objectForKey:@"msgid"];
        pushMsg.func    = [userInfo objectForKey:@"func"];
        pushMsg.msgtype = [userInfo objectForKey:@"msg_type"];
        pushMsg.msg     = [userInfo objectForKey:@"msg"];
        
        //持久保存
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
        [self dispatchPushMessage:pushMsg];
    
    }
    [application setApplicationIconBadgeNumber:0];
    
    [BPush handleNotification:userInfo];

}


- (void)dispatchPushMessage:(PushMessage *)pushMsg
{
    if ([pushMsg.func isEqualToString:PUSHMESSAGE_FUNC_SYSTEM_ADD_FANS]) {
        //被加粉丝
        [[NSNotificationCenter defaultCenter] postNotificationName:KPUSHMESSAGENOTIFY_SYSTEM_ADD_FANS
                                                            object:pushMsg];
        
    } else if ([pushMsg.func isEqualToString:PUSHMESSAGE_FUNC_SYSTEM_CHG_STATUS]) {
        //好友状态变更
        [[NSNotificationCenter defaultCenter] postNotificationName:KPUSHMESSAGENOTIFY_SYSTEM_CHG_STATUS
                                                            object:pushMsg];
        
    } else if ([pushMsg.func isEqualToString:PUSHMESSAGE_FUNC_SYSTEM_RECOMMAND]) {
        
        //推荐伴跑
        [[NSNotificationCenter defaultCenter] postNotificationName:KPUSHMESSAGENOTIFY_SYSTEM_RECOMMAND
                                                            object:pushMsg];
        
    } else if ([pushMsg.func isEqualToString:PUSHMESSAGE_FUNC_PARTNER_INVITE_RUN]) {
        
        //邀请伴跑
        [[NSNotificationCenter defaultCenter] postNotificationName:KPUSHMESSAGENOTIFY_PARTNER_INVITE_RUN
                                                            object:pushMsg];
        
    } else if ([pushMsg.func isEqualToString:PUSHMESSAGE_FUNC_PARTNER_INVITE_CANCEL]) {
        
        //取消邀请
        [[NSNotificationCenter defaultCenter] postNotificationName:KPUSHMESSAGENOTIFY_PARTNER_INVITE_CANCEL
                                                            object:pushMsg];
        
    } else if ([pushMsg.func isEqualToString:PUSHMESSAGE_FUNC_PARTNER_INVITE_RET]) {
        
        //回复邀请
        [[NSNotificationCenter defaultCenter] postNotificationName:KPUSHMESSAGENOTIFY_PARTNER_INVITE_RET
                                                            object:pushMsg];
        
    } else if ([pushMsg.func isEqualToString:PUSHMESSAGE_FUNC_IM_TEXT]) {
        
        //IM消息：文本
        [[NSNotificationCenter defaultCenter] postNotificationName:KPUSHMESSAGENOTIFY_IM_TEXT
                                                            object:pushMsg];
        
    } else if ([pushMsg.func isEqualToString:PUSHMESSAGE_FUNC_IM_VOICE]) {
        
        //IM消息：语音
        [[NSNotificationCenter defaultCenter] postNotificationName:KPUSHMESSAGENOTIFY_IM_VOICE
                                                            object:pushMsg];
        
    } else if ([pushMsg.func isEqualToString:PUSHMESSAGE_FUNC_IM_IMAGE]) {
        
        //IM消息：图片
        [[NSNotificationCenter defaultCenter] postNotificationName:KPUSHMESSAGENOTIFY_IM_IMAGE
                                                            object:pushMsg];
    }
    
//    switch ([pushMsg.msgtype integerValue]) {
//        case PUSHMESSAGE_TYPE_TEXT:
//        {
//            //0文本
//            break;
//        }
//        case PUSHMESSAGE_TYPE_LONGTEXT:
//        {
//            // 1长文本
//            break;
//        }
//        case PUSHMESSAGE_TYPE_VOICEURL:
//        {
//            //2音频url
//            break;
//        }
//        case PUSHMESSAGE_TYPE_IMAGEURL:
//        {
//            //3图片url
//            break;
//        }
//        case PUSHMESSAGE_TYPE_SYSTEM:
//        {
//            //4系统通知
//            
//            break;
//        }
//        case PUSHMESSAGE_TYPE_INVITENOTIFY:
//        {
//            //5邀跑通知
//            break;
//        }
//        default:
//            break;
//    }
    
}



- (void)onMethod:(NSString *)method response:(NSDictionary *)data
{

    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        NSString *appid     = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid    = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        int returnCode      = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        
        if (returnCode == BPushErrorCode_Success) {

            // 在内存中备份，以便短时间内进入可以看到这些值，而不需要重新bind
            self.appId = appid;
            self.channelId = channelid;
            self.userId = userid;
        }
    } else if ([BPushRequestMethod_Unbind isEqualToString:method]) {
        
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {

        }
    }

}


@end



