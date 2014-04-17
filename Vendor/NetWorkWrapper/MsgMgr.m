//
//  MsgMgr.m
//  msgcomm
//
//  Created by guo song on 13-8-5.
//  Copyright (c) 2013年 guo song. All rights reserved.
//

#import "MsgMgr.h"

@interface MsgMgr()

@property (nonatomic, retain) GCDAsyncSocket *asyncSocket;
@property (nonatomic, retain) NSMutableArray *msgQueue;
@property (nonatomic, retain) NSMutableData  *buffer;

- (void)sendMsg;
- (NSArray*)composeMsgPackage:(NSData *)data;
- (void)handleReceivedMsg:(JoyMsg*)msg;

@end

@implementation MsgMgr

@synthesize hostName;
@synthesize port;

@synthesize msgQueue;
@synthesize asyncSocket;
@synthesize buffer;


//单例
+ (MsgMgr *)sharedMsgMgr {
    static MsgMgr *_instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}


-(id)init
{
    if((self = [super init]))
	{
        //初始化
        self.reConnectedCount   = 0;
        self.isReConnected      = NO;
		self.msgQueue       = [[NSMutableArray alloc] initWithCapacity:5];
        self.buffer         = [[NSMutableData alloc] initWithCapacity:1024];
        self.asyncSocket    = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
	return self;
}

-(void)dealloc
{
    self.msgQueue        = nil;
    self.asyncSocket     = nil;
    self.buffer          = nil;
}




#pragma mark socket connect

//连接服务器
- (BOOL) connectToServer:(NSError **)errPtr
{
    if(self.hostName == nil)
    {
        return NO;
    }
    return [self.asyncSocket connectToHost:self.hostName onPort:self.port error:errPtr];
}

//断开连接
- (void)disconnect
{
    [self.asyncSocket setDelegate:nil delegateQueue:NULL];
    [self.asyncSocket disconnect];
}

//判断是否已连接
- (BOOL)isConnected
{
    return [self.asyncSocket isConnected];
}


//创建JoyMsg
- (JoyMsg*) createMsg
{
    JoyMsg* msg = [[JoyMsg alloc] init];
    return msg;
}

//发送某消息
- (void) sendMsg:(JoyMsg*)msg
{
    [msgQueue addObject:msg];
    [self sendMsg];
}

//发送消息
- (void) sendMsg
{
    //取出一个消息，发送它。
    if( [msgQueue count] > 0 )
    {
        JoyMsg* msg = (JoyMsg*)[msgQueue objectAtIndex:0];
        [msgQueue removeObjectAtIndex:0];
        [self.asyncSocket writeData:[msg getMsgPackage] withTimeout:msg.timeout tag:msg.msgId];
    }
}


//处理收到的消息
-(void)handleReceivedMsg:(JoyMsg*)msg
{
    NSDictionary * contentDic = [MsgContentCodec decodeMsgContent:msg.content];
    NSLog(@"response type = %d", msg.msgType);
    NSLog(@"response content = %@", contentDic);
    switch (msg.msgType) {
        case EmsgServer_LoginResponse:
        {
            break;
        }
        case EMsgServer_RegisterResponse:
        {
            break;
        }
        default:
            break;
    }
}

//消息打包
-(NSArray*)composeMsgPackage:(NSData *)data
{
    NSMutableArray * msgArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSMutableData * allData = [[NSMutableData alloc] initWithCapacity:1024];
    
    if(self.buffer.length == 0)
    {
        [allData appendData:data];
    }
    else
    {
        [allData appendData:self.buffer];
        [allData appendData:data];
        [self.buffer setLength:0];
    }
    
    NSRange msgRange;
    msgRange.location = 0;
    msgRange.length   = 0;
    
    while(allData.length - msgRange.location >= [JoyMsg msgPackageMinLength])
    {
        uint32_t l;
        NSRange lr;
        lr.location = msgRange.location + 2*sizeof(uint32_t);
        lr.length   = sizeof(uint32_t);
        
        [allData getBytes:&l range:lr];
        l = CFSwapInt32HostToBig(l);
        
        if(allData.length - msgRange.location >= l+3*sizeof(uint32_t))
        {
            msgRange.length = l+3*sizeof(uint32_t);
            JoyMsg * msg = [[JoyMsg alloc] initWithData:[allData subdataWithRange:msgRange]];
            [msgArray addObject:msg];
            msgRange.location += msgRange.length;
        }
        else
        {
            break;
        }
    }
    
    if(allData.length > msgRange.location)
    {
        NSRange r;
        r.location = msgRange.location;
        r.length   = allData.length - msgRange.location;
        [self.buffer appendData:[allData subdataWithRange:r]];
    }
    
    return msgArray;
}


#pragma mark GCDAsyncSocket Delegate


/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
 **/
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    //连接成功
    NSLog(@"socket:didConnectToHost:");
    [self sendMsg];
    [sock readDataWithTimeout:-1 tag:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:SocketConnectSuccessNotify object:nil];
}


/**
 * Called when a socket disconnects with or without error.
 *
 * If you call the disconnect method, and the socket wasn't already disconnected,
 * this delegate method will be called before the disconnect method returns.
 **/
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    //连接失败，或者网络异常导致网络断开
    NSLog(@"socketDidDisconnect:withError:");
    [[NSNotificationCenter defaultCenter] postNotificationName:SocketConnectFailedNotify object:nil];
}

/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"socket:didReadData:");
    NSArray * msgs = [self composeMsgPackage:data];
    
    for(JoyMsg * msg in msgs)
    {
        [self handleReceivedMsg:msg];
    }
    
    [self sendMsg];
    [sock readDataWithTimeout:-1 tag:0];
}

/**
 * Called when a socket has read in data, but has not yet completed the read.
 * This would occur if using readToData: or readToLength: methods.
 * It may be used to for things such as updating progress bars.
 **/
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"socket:didReadPartialDataOfLength:tag:");
}

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"socket:didWriteDataWithTag:");
    [self sendMsg];
}

/**
 * Called when a socket has written some data, but has not yet completed the entire write.
 * It may be used to for things such as updating progress bars.
 **/
- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"socket:didWritePartialDataOfLength:tag:");

}

/**
 * Called if a read operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the read's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the read will timeout as usual.
 *
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been read so far for the read operation.
 *
 * Note that this method may be called multiple times for a single read if you return positive numbers.
 **/
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    NSLog(@"socket:shouldTimeoutReadWithTag:elapsed:bytesDone:elapsed:bytesDone:");
    return 0;
}

/**
 * Called if a write operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the write's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the write will timeout as usual.
 *
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been written so far for the write operation.
 *
 * Note that this method may be called multiple times for a single write if you return positive numbers.
 **/
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    NSLog(@"socket:shouldTimeoutWriteWithTag:elapsed:bytesDone:");
    return 0;
}





@end
