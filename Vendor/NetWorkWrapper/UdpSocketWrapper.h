//
//  UdpSocketWrapper.h
//  SpeakHere
//
//  Created by zzc on 14-1-16.
//
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

@interface UdpSocketWrapper : NSObject
{
    NSInteger mTag;
}

@property(nonatomic, retain)GCDAsyncUdpSocket *udpSocket;

+(UdpSocketWrapper *)sharedInstance;
-(id)init;

- (void)send:(NSData *)mdata;
- (void)sendControl:(NSDictionary *)controlData;

@end
