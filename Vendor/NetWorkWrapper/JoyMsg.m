//
//  JoyMsg.m
//  msgcomm
//
//  Created by guo song on 13-8-5.
//  Copyright (c) 2013年 guo song. All rights reserved.
//

#import "JoyMsg.h"

static NSUInteger MsgId = 0;

@implementation JoyMsg

@synthesize msgId;
@synthesize msgType;

@synthesize content;
@synthesize timeout;

-(id) init
{
    if((self = [super init]))
	{
		self.msgId    = MsgId;
        self.content  = nil;
        self.timeout  = -1;
        
        MsgId++;
	}
    
	return self;
}

-(void) dealloc
{
    self.content  = nil;
}

+(int) msgPackageMinLength
{
    return 12; //4(Id) + 4(Type) + 4(Length)
}

- (NSData*) getMsgPackage
{
    NSMutableData * data = [[NSMutableData alloc] initWithCapacity:512];
    uint32_t i = CFSwapInt32HostToBig(msgId);
    uint32_t t = CFSwapInt32HostToBig(msgType);
    
    [data appendBytes:&i length:sizeof(i)];
    [data appendBytes:&t length:sizeof(t)];
    
    if(self.content == nil || [self.content length] == 0)
    {
        uint32_t len = 0;
        [data appendBytes:&len length:sizeof(len)];    
    }
    else
    {
        uint32_t len = [self.content length];
        len = CFSwapInt32HostToBig(len);
        [data appendBytes:&len length:sizeof(len)];
        [data appendData:self.content];
    }
    
    return data;
}


- (id) initWithData:(NSData*) msgPackage
{
    if((self = [super init]))
	{
        uint32_t i;
        uint32_t t;
        uint32_t l;
        
        NSRange tr;
        tr.location = sizeof(uint32_t);
        tr.length = sizeof(uint32_t);
        
        [msgPackage getBytes:&i length:sizeof(uint32_t)];
        [msgPackage getBytes:&t range:tr];
        
        tr.location = 2*sizeof(uint32_t);
        [msgPackage getBytes:&l range:tr];
        
		self.msgId    = CFSwapInt32HostToBig(i);
        self.msgType  = CFSwapInt32HostToBig(t);
        l = CFSwapInt32HostToBig(l);
        if( l == 0 )
        {
            self.content = nil;
        }
        else
        {
            tr.location     = 3*sizeof(uint32_t);
            tr.length       = [msgPackage length] - 3*sizeof(uint32_t);
            self.content    = [msgPackage subdataWithRange:tr];
        }
        
        self.timeout  = -1;
	}
    
	return self;
}

@end
