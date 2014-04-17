//
//  UdpSocketWrapper.m
//  SpeakHere
//
//  Created by zzc on 14-1-16.
//
//

#import "UdpSocketWrapper.h"

static UdpSocketWrapper *socketWrapper;

@implementation UdpSocketWrapper

+ (UdpSocketWrapper *)sharedInstance
{
    if (socketWrapper == nil) {
        socketWrapper = [[UdpSocketWrapper alloc] init];
    }
    return socketWrapper;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self setupSocket];
    }
    return self;
}


- (void)send:(NSData *)mdata
{
	//NSString *host = @"10.10.10.254";
    NSString *host = @"192.168.3.1";
	int port = 9000;
    //NSLog(@"data length = %d", [mdata length]);
	[self.udpSocket sendData:mdata toHost:host port:port withTimeout:-1 tag:mTag];
	//NSLog(@"SENT (%i)", (int)mTag);
	mTag++;
}

- (void)sendControl:(NSDictionary *)controlData
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:controlData options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"err = %@", error);
    }
    NSLog(@"data length = %d", [jsonData length]);
    //NSString *host = @"10.10.10.254";
    NSString *host = @"192.168.3.1";
	int port = 9001;
	[self.udpSocket sendData:jsonData toHost:host port:port withTimeout:-1 tag:mTag];
	NSLog(@"SENT (%i)", (int)mTag);
	mTag++;
}

#pragma mark - udp socket
- (void)setupSocket
{
	self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	NSError *error = nil;
	if (![self.udpSocket bindToPort:0 error:&error])
	{
		NSLog(@"Error binding: %@", error);
		return;
	}
	if (![self.udpSocket beginReceiving:&error])
	{
		NSLog(@"Error receiving: %@", error);
		return;
	}
    NSLog(@"socket Ready");
}



- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
	// You could add checks here
    NSLog(@"send tag(%ld) sucessful", tag);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	// You could add checks here
    NSLog(@"send tag(%ld) failed", tag);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock
   didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
	NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if(msg){
		NSLog(@"RECV: %@", msg);
	}else{
		NSString *host = nil;
		uint16_t port = 0;
		[GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
		NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
	}
}

@end
