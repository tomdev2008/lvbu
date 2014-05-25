//
//  XMPPManager.h
//  TentinetIM
//
//  Created by YuanFromTentinet on 13-10-5.
//  Copyright (c) 2013年 Tentinet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPPStream.h"
#import "TURNSocket.h"
#import "GCDAsyncSocket.h"

@class XMPPRoomManager;

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

typedef enum {
    kChatNewsNone,
    kChatNewsChat,
    kChatNewsGroupchat,
    kChatNewsHeadline,
    kChatNewsNormal,
    kChatNewsError
}kChatNewsType;

@interface XMPPManager : NSObject<XMPPRosterDelegate, UIApplicationDelegate, XMPPRoomDelegate, TURNSocketDelegate, GCDAsyncSocketDelegate> {
    XMPPStream *xmppStream;                             //xmpp流
    XMPPReconnect *xmppReconnect;                       //重连
    XMPPRoster *xmppRoster;                             //花名册
	XMPPRosterCoreDataStorage *xmppRosterStorage;       //花名册持久存储
    XMPPvCardCoreDataStorage *xmppvCardStorage;         //vCard持久存储
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    dispatch_queue_t stream_roster_reconnect;
    

    BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
    BOOL isXmppConnected;
    NSString *proxyHost;
    NSString *proxyPort;
}

@property BOOL isConnected;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;

@property (nonatomic,retain) XMPPRoomManager *roomManager;

+ (id)defaultInstance;
- (BOOL)connectOpenfireUsername:(NSString *)myUsername password:(NSString *)myPassword;
- (void)disconnect;
- (NSManagedObjectContext *)managedObjectContext_roster;


@end
