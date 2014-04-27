//
//  baseAppDelegate.m
//
//  Created by apple on 13-3-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BaseAppDelegate.h"
#import "AppConstants.h"

@interface BaseAppDelegate(Private)

- (void)signalHandler;
- (void)reachabilityChanged:(NSNotification* )note;

@end


@implementation BaseAppDelegate

- (void)initApp
{

    //注册异常捕获函数
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [self signalHandler];
    
    /*注册网络状态改变的回调函数，并开启监听网络状态改变*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    _wifiReachability = [Reachability reachabilityForLocalWiFi];
    _lastNetStatus    = [_wifiReachability currentReachabilityStatus];
    [_wifiReachability startNotifier];
}


- (void)sendTokenToServer:(NSString *)token
{
    
}

- (void)firstLanch
{

}

- (void)urlLanch
{

}

- (void)normalLanch
{

}



- (void)configApp
{
//    //判断是否第一次启动
//    NSString *isFirstLaunch = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_IsFirstLaunch];
//    if (isFirstLaunch == nil || ![isFirstLaunch isEqualToString:@"NO"]) {
//        
//        //第一次启动,应用初始化处理
//    }
}


#pragma mark - Private

- (void)signalHandler
{
    struct sigaction mySigAction;
    mySigAction.sa_sigaction = stacktrace;
    mySigAction.sa_flags = SA_SIGINFO;
    
    sigemptyset(&mySigAction.sa_mask);
    sigaction(SIGQUIT, &mySigAction, NULL);
    sigaction(SIGILL , &mySigAction, NULL);
    sigaction(SIGTRAP, &mySigAction, NULL);
    sigaction(SIGABRT, &mySigAction, NULL);
    sigaction(SIGEMT , &mySigAction, NULL);
    sigaction(SIGFPE , &mySigAction, NULL);
    sigaction(SIGBUS , &mySigAction, NULL);
    sigaction(SIGSEGV, &mySigAction, NULL);
    sigaction(SIGSYS , &mySigAction, NULL);
    sigaction(SIGPIPE, &mySigAction, NULL);
    sigaction(SIGALRM, &mySigAction, NULL);
    sigaction(SIGXCPU, &mySigAction, NULL);
    sigaction(SIGXFSZ, &mySigAction, NULL);
}

/*WIFI网络状态改变时被回调*/
- (void)reachabilityChanged:(NSNotification* )note
{
	@synchronized(_wifiReachability) {
        
        Reachability* curReach = [note object];
        if ([curReach isKindOfClass:[Reachability class]] == NO) {
            MMLogDebug(@"found unknown class object");
        }
        
        if (_wifiReachability == nil)
            return;
        
        if (_lastNetStatus != ReachableViaWiFi) {
            MMLogDebug(@"ignore this net status notification.");
        }
        
        if ([_wifiReachability currentReachabilityStatus] == NotReachable && _lastNetStatus != [_wifiReachability currentReachabilityStatus]) {
            MMLogDebug(@"Network disconnected.");
        } else {
            MMLogDebug(@"Network connection status changed (%u)", _lastNetStatus);
        }
        _lastNetStatus = [_wifiReachability currentReachabilityStatus];
    }
}


@end


#pragma mark - 崩溃处理

void uncaughtExceptionHandler(NSException *exception)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"current time: %@\n exception name: %@\n exception reason: %@\n exception userinfo: %@\n Stack Trace: %@",
                               [formatter stringFromDate:curDate],
                               [exception name],
                               [exception reason],
                               [exception userInfo],
                               [exception callStackSymbols]];
    
    /*创建crash文件目录*/
    NSString *crashLogPath = [[NSFileManager docPath] stringByAppendingPathComponent:@"log"];
    crashLogPath           = [NSFileManager touch:crashLogPath];
    
    
    /*打开crash文件*/
    NSString *crashFileName = [NSString stringWithFormat:@"%@/crashReport.txt", crashLogPath];
    FILE *fd = fopen([crashFileName UTF8String], "w+");
    if (fd == NULL) {
        NSLog(@"open log file failed.");
        return;
    }
    
    /*写crash信息到文件中*/
    fputs([exceptionInfo UTF8String], fd);
    fputs("\r\n", fd);
    fflush(fd);
    fclose(fd);
    
}

void stacktrace(int sig, siginfo_t *info, void *context)
{
    NSError *error ;
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSMutableString *mstr = [[NSMutableString alloc] initWithCapacity:128];
    
    NSString *crashReportPath = [[NSFileManager docPath] stringByAppendingString:@"/log/crashreport.txt"];
    
    //如果crash文件已经存在，则将日志追加到文件里
    if ([fileManager fileExistsAtPath:crashReportPath])
    {
        NSString *existCrashReport = [NSString stringWithContentsOfFile:crashReportPath encoding:NSUTF8StringEncoding error:&error];
        [mstr appendString:existCrashReport];
    }
    
    [mstr appendString:@"\n Stack Track:\n"];
    void* callstack[128];
    int i, frameCount = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frameCount);
    for (i = 0; i < frameCount; i++) {
        [mstr appendFormat:@"%s\n", strs[i]];
    }
    [mstr writeToFile:crashReportPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    mstr = nil;
    
}

 