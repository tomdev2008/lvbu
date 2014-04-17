//
//  MMLog.m
//
//  Copyright (c) 2013 Twin-Fish. All rights reserved.
//

#import "MMLog.h"

@interface MMLog (Private)

- (void)log2Console:(NSString *)log;

@end

static MMLog *mmLog;

@implementation MMLog


+ (id)sharedInstance 
{
    if (mmLog == nil) {
        mmLog = [[MMLog alloc] init];
    }
    return mmLog;
}


- (id)init
{
    self = [super init];
    if (self != nil) {
        // nothing
    }
    return self;
}

- (void)Log:(MMLOG_LEVEL)level msg:(NSString *)message cls:(id)classObj
       file:(const char *)file function:(const char *)func line:(const unsigned int)line
{
    // log to console
    NSString *filePath = [NSString stringWithCString:file encoding:NSUTF8StringEncoding];
    NSString *logLevel = nil;
    switch (level) {
        case MMLOG_LEVEL_DEBUG:
            logLevel = @"D";
            break;
            
        case MMLOG_LEVEL_INFO:
            logLevel = @"I";
            break;
            
        case MMLOG_LEVEL_WARN:
            logLevel = @"W";
            break;
            
        case MMLOG_LEVEL_ERROR:
            logLevel = @"E";
            break;
            
        case MMLOG_LEVEL_FATAL:
            logLevel = @"F";
            break;
            
        default:
            return;
    }
    
    //打印日志到控制台
    [self log2Console:[NSString stringWithFormat:@"%@ %@:%u %s %@",
                       logLevel, [filePath lastPathComponent], line, func, message]];
}

#pragma mark - Private

- (void)log2Console:(NSString *)log
{
    NSLog(@"%@", log);
}

@end
