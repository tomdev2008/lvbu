//
//  MMThread.m
//  MMeeting
//
//  Created by apple on 13-3-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MMThread.h"

#pragma mark -

@implementation MMTaskQueue

MM_DEF_SINGLETON( MMTaskQueue )

- (id)init
{
self = [super init];
if ( self )
{
    _foreQueue = dispatch_get_main_queue();
    _backQueue = dispatch_queue_create( "com.MM.taskQueue", nil );
}

return self;
}

- (dispatch_queue_t)foreQueue
{
	return _foreQueue;
}

- (dispatch_queue_t)backQueue
{
	return _backQueue;
}


- (void)enqueueForeground:(dispatch_block_t)block
{
	dispatch_async( _foreQueue, block );
}

- (void)enqueueBackground:(dispatch_block_t)block
{
	dispatch_async( _backQueue, block );
}

- (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC);
	dispatch_after( time, _foreQueue, block );	
}

- (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC);
	dispatch_after( time, _backQueue, block );	
}

@end