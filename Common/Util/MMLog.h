//
//  MMLog.h
//
//  Copyright (c) 2013 Twin-Fish. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    MMLOG_LEVEL_DEBUG = 0,
    MMLOG_LEVEL_INFO,
    MMLOG_LEVEL_WARN,
    MMLOG_LEVEL_ERROR,
    MMLOG_LEVEL_FATAL,
    MMLOG_LEVEL_NONE,

} MMLOG_LEVEL;

#define MMLOG_LEVEL_STRING_DEBUG    @"1"
#define MMLOG_LEVEL_STRING_INFO     @"2"
#define MMLOG_LEVEL_STRING_WARN     @"3"
#define MMLOG_LEVEL_STRING_ERROR    @"4"
#define MMLOG_LEVEL_STRING_FATAL    @"5"
#define MMLOG_LEVEL_STRING_NONE     @"6"

#define DEFAULT_LOG_LEVEL   MMLOG_LEVEL_DEBUG

@interface MMLog : NSObject

@property (nonatomic, copy)NSString     *platformVersion;


+ (id)sharedInstance;

- (void)Log:(MMLOG_LEVEL)level msg:(NSString *)message cls:(id)classObj
       file:(const char *)file function:(const char *)func line:(const unsigned int)line;

@end

#define MMLogDebug(format, ...)  \
    [[MMLog sharedInstance] Log:MMLOG_LEVEL_DEBUG msg:[NSString stringWithFormat:format, ##__VA_ARGS__] \
           cls:self file:__FILE__ function:__FUNCTION__ line:__LINE__]

#define MMLogInfo(format, ...)  \
    [[MMLog sharedInstance] Log:MMLOG_LEVEL_INFO msg:[NSString stringWithFormat:format, ##__VA_ARGS__] \
           cls:self file:__FILE__ function:__FUNCTION__ line:__LINE__]

#define MMLogWarn(format, ...)  \
    [[MMLog sharedInstance] Log:MMLOG_LEVEL_WARN msg:[NSString stringWithFormat:format, ##__VA_ARGS__] \
           cls:self file:__FILE__ function:__FUNCTION__ line:__LINE__]

#define MMLogError(format, ...)  \
    [[MMLog sharedInstance] Log:MMLOG_LEVEL_ERROR msg:[NSString stringWithFormat:format, ##__VA_ARGS__] \
           cls:self file:__FILE__ function:__FUNCTION__ line:__LINE__]
#define MMLogFatal(format, ...)  \
    [[MMLog sharedInstance] Log:MMLOG_LEVEL_FATAL msg:[NSString stringWithFormat:format, ##__VA_ARGS__] \
            cls:self file:__FILE__ function:__FUNCTION__ line:__LINE__]
