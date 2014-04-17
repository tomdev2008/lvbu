//
//  JoyMsg.h
//  msgcomm
//
//  Created by guo song on 13-8-5.
//  Copyright (c) 2013年 guo song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgTypeDefine.h"

@interface JoyMsg: NSObject
{
    uint32_t msgId;
    uint32_t msgType;

    NSData * content;
    NSTimeInterval timeout;
}

@property (nonatomic, assign) uint32_t msgId;
@property (nonatomic, assign) uint32_t msgType;
@property (nonatomic, retain) NSData    *content;
@property (nonatomic, assign) NSTimeInterval timeout;

- (NSData*) getMsgPackage;
- (id) initWithData:(NSData*) msgPackage;

+(int) msgPackageMinLength;

@end
