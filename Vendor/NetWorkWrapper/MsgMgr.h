//
//  MsgMgr.h
//  msgcomm
//
//  Created by guo song on 13-8-5.
//  Copyright (c) 2013年 guo song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "JoyMsg.h"
#import "MsgTypeDefine.h"
#import "MsgContentCodec.h"
#import "GCDAsyncSocket.h"

#define SocketConnectFailedNotify   @"SocketConnectFailedNotify"        //连接失败或者网络异常导致网络断开
#define SocketConnectSuccessNotify  @"SocketConnectSuccessNotify"       //网络连接成功


@interface MsgMgr : NSObject<GCDAsyncSocketDelegate>
{
    NSMutableArray *msgQueue;    
    GCDAsyncSocket *asyncSocket;
    NSMutableData  *buffer;
    
    NSString *hostName;
    UInt16   port;

}

@property (nonatomic, assign) NSInteger reConnectedCount;       //重连次数
@property (nonatomic, assign) BOOL      isReConnected;          //是否重连
@property (nonatomic, retain) NSString  *hostName;              //服务器地址
@property (nonatomic, assign) UInt16    port;//端口


- (JoyMsg*)createMsg;
- (void)sendMsg:(JoyMsg*)msg;

- (BOOL) connectToServer:(NSError **)errPtr;
- (void) disconnect;
- (BOOL) isConnected;

+ (MsgMgr*)sharedMsgMgr;

@end
