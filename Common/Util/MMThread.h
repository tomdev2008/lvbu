//
//  MMThread.h
//
//  Created by apple on 13-3-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

#define MM_AS_SINGLETON( __class ) \
        + (__class *)sharedInstance;

#define MM_DEF_SINGLETON( __class ) \
        + (__class *)sharedInstance \
        { \
            static dispatch_once_t once; \
            static __class * __singleton__; \
            dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
            return __singleton__; \
        }

#pragma mark -


@interface MMTaskQueue : NSObject
{
	dispatch_queue_t _foreQueue;    //前台队列
	dispatch_queue_t _backQueue;    //后台队列
}

MM_AS_SINGLETON( MMTaskQueue );

- (dispatch_queue_t)foreQueue;
- (dispatch_queue_t)backQueue;

- (void)enqueueForeground:(dispatch_block_t)block;
- (void)enqueueBackground:(dispatch_block_t)block;
- (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block;
- (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block;

@end
