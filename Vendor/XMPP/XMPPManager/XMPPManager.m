//
//  XMPPManager.m
//  TentinetIM
//
//  Created by YuanFromTentinet on 13-10-5.
//  Copyright (c) 2013年 Tentinet. All rights reserved.
//

#import "XMPPManager.h"
#import "Chat.h"
#import "NewFrineds.h"
#import "DataBase.h"
#import "BYDAppDelegate.h"
#import "XMPPManager+BasicOperation.h"
#import "SessionManager+Group.h"
#import "BYD_MPMainViewController.h"
#import "GBAlertView.h"

static XMPPManager *instance;

@implementation XMPPManager

char * convertDecimalToHex2(char restr[], int value)
{
	sprintf(restr,"%x",value);
	return restr;
}

@synthesize xmppvCardAvatarModule;
@synthesize xmppRoster;
@synthesize xmppStream;
@synthesize xmppRosterStorage;


+ (id)defaultInstance {
    @synchronized(self) {
        if(!instance) {
            instance = [[XMPPManager alloc] initBasicXMPP];
        }
    }
    return instance;
}

- (id)initBasicXMPP {
    self = [super init];
    if(self) {
        [self recordLog];   //日志
        [self setupStream]; //设置流
    }
    return self;
}

- (void)recordLog {
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

- (void)setupStream {
    xmppStream = [[XMPPStream alloc] init];
    #if !TARGET_IPHONE_SIMULATOR 
    {
        xmppStream.enableBackgroundingOnSocket = YES;
    }
    #endif
    
    //The XMPPReconnect module monitors for "accidental disconnect" and
    //automatically reconnects the stream for you.
    xmppReconnect = [[XMPPReconnect alloc] init];
    xmppReconnect.reconnectTimerInterval=10;
    
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    ///////////////////////////////
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];

    xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    ///////////////////////////////
	// Activate xmpp modules
    
	[xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    
    //stream_roster_reconnect = dispatch_queue_create("stream_roster_reconnect_delegate", nil);
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
}

- (void)teardownStream {
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
#warning 11.5日添加
    [xmppReconnect removeDelegate:self];
    //dispatch_release(stream_roster_reconnect);
	
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
}


- (BOOL)connectOpenfireUsername:(NSString *)myUsername password:(NSString *)myPassword {
    if(![xmppStream isDisconnected]) {
        return YES;
    }
    
    if(myUsername == nil || myPassword == nil) {
        return NO;
    }
    self.username = myUsername;
    self.password = myPassword;
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@/%@",myUsername,kJidDomain,kJidResource]];
    
    //DLog(@"%@",jid);
    
    [xmppStream setMyJID:jid];
    NSError *error = nil;
    if(![xmppStream connectWithTimeout:10 error:&error]) {
        GBAlertView *alertView = [GBAlertView alertWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitle:nil];
		[alertView show];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark 上线 下线
- (void)goOnline
{
    _isConnected = YES;
    
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[xmppStream sendElement:presence];
    
    [self xmppLoginState:@"已上线"];
    [[NSUserDefaults standardUserDefaults] setValue:@"登录成功" forKey:@"xmpp_loginState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)goOffline
{
    _isConnected = NO;
    
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[xmppStream sendElement:presence];
    
    //[self xmppLoginState:@"已下线"];
}

- (void)disconnect
{
    
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"xmpp_loginState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
	[self goOffline];
	[xmppStream disconnect];
}

#pragma mark -
#pragma mark XMPPStream Delegate
//服务器连接上
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
            [settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

//连接上服务器后 验证密码
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![xmppStream authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

//验证成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[self goOnline];
    
    
    //注册接收通知类型
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeNewsstandContentAvailability |
      UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
    
        User * user =[GlobalCommen CurrentUser];
        
        SessionManager * mgr=[SessionManager manager];
        mgr.failedBlock=^(NSString*errorStatus){
            NSLog(@"zhaohao test GetMyGroupList Block");
            
        };
        mgr.completeBlock=^(id result){
            NSArray *groupList = (NSArray*)result;
            NSLog(@"zhaohao test joinGroup data:%@",groupList);
            
            for (Group * group in groupList) {
                NSLog(@"zhaohao test join:%@",group);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                    [self setRoomManager:nil];
                    _roomManager = [[XMPPRoomManager alloc] initWithRoomName:group.group_id];
                    [_roomManager joinRoomByMyNick:user.dixun_number];
                });
            }
        };
    
    [mgr getMyGroupListByUserAccount:user.username andNumOfPage:nil andPageNum:nil andOrderByColumn:nil];

}
//验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    [self disconnect];
    
    [self xmppLoginState:@"用户信息验证失败!"];
}

//断开连接勒
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
    NSLog(@"%@",error);
    

	if (!isXmppConnected)
	{
        DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
    
    [self xmppLoginState:@"连接断开!"];
}

- (void)xmppLoginState:(NSString *)state {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationConnectXmppServerState" object:state];
}

#pragma mark -
#pragma mark 常用方法

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    /*
    XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
                                                             xmppStream:xmppStream
                                                   managedObjectContext:[self managedObjectContext_roster]];
     */
    
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        DLog(@"RECV MESSAGE:%@,AND SENDER:%@",message,sender);
        NSArray *fromSeparated = [[message attributeStringValueForName:@"from"] componentsSeparatedByString:@"@"];
        NSString *from = nil;
        if(fromSeparated.count > 0) {
            from = [fromSeparated objectAtIndex:0];
        } else {
            from = [message attributeStringValueForName:@"from"];
        }
        NSString *currUser = _username;//[[NSUserDefaults standardUserDefaults] stringForKey:kLoginUsername];
        if([from isEqualToString:currUser]) {
            
            return;
        }
        NSString *type = [message attributeStringValueForName:@"type"];
        if([type isEqualToString:@"error"]) {
            //错误消息，拒绝接收，比如某人给他人发信息，他人不在线时，会返回404的错误
            return;
        }

        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self recevieMessage:message from:from];
        });
    });
    
    
    
    
}

//收到好友上线 下线通知
//在某人加入某群时，也会调用此方法以获取用户的在线状态
//某人添加你时，会先执行此方法
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //接受（当前）用户
    NSString *userId = [[presence to] user];
    //发送用户
    NSString *presenceFromUser = [[presence from] user];
    
    DLog(@"好友状态:%@, 当前用户:%@, 发送用户:%@",presenceType,userId,presenceFromUser);
    
    if([presenceType isEqualToString:@"subscribed"]) {
        if(![presenceFromUser isEqualToString:userId]) {
            [self receivedFriendAgreeWithYourFriendRequest:presenceFromUser toUser:userId];
        }
    }
    else if([presenceType isEqualToString:@"subscribe"]) {
        if(![presenceFromUser isEqualToString:userId]) {
            DLog(@"didReceivePresenceSubscriptionRequest");
            [self friendRequestMessage:presenceFromUser toUser:userId];
        }
    }
    else if([presenceType isEqualToString:@"available"]) {
        if([presenceFromUser isEqualToString:userId]) {
            [self goOnline];
        } else {
            [self friendOnlineMessage:presenceFromUser];
        }
    }
    else if([presenceType isEqualToString:@"unavailable"]) {
        if([presenceFromUser isEqualToString:userId]) {
            [self receiveUserOfflineNews:presenceFromUser];
        } else {
            [self friendOfflineMessage:presenceFromUser];
        }
    }
}


//添加(添加后确认) 删除好友，调用
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    DLog(@"didReceiveIQ");
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSXMLElement *query = [iq elementForName:@"query"];
    NSString *tojid = [iq attributeStringValueForName:@"to"];
    if(query) {
        NSXMLElement *item = [query elementForName:@"item"];
        NSString *subscription = [item attributeStringValueForName:@"subscription"];
        NSString *ask = [item attributeStringValueForName:@"ask"];
        NSString *jid = [item attributeStringValueForName:@"jid"];
        NSString *jidUser = [[jid componentsSeparatedByString:@"@"] objectAtIndex:0];
        NSString *toJidUser = [[tojid componentsSeparatedByString:@"@"] objectAtIndex:0];
        if(tojid && jid) {
            if([subscription isEqualToString:@"remove"]) {
                [self friendRemoveMessage:jidUser toUser:toJidUser];
            } else if([ask isEqualToString:@"subscribe"]) {
                [self receiveSendFriendRequestReceiptMessage:jidUser toUser:toJidUser];
            }
        }
    }
    
    return  YES;
}
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
    DLog(@"didReceiveError");
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    DDXMLNode *errorNode = (DDXMLNode *)error;
    
    //遍历错误节点
    for(DDXMLNode *node in [errorNode children])
    {
        //若错误节点有【冲突】
        if([[node name] isEqualToString:@"conflict"])
        {
            [GlobalCommen setCurrentUser:nil];
            [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kLoginStatus];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"switchTabBarController" object:@"Conflict"];
        }
    }
    
}

#pragma mark XMPPRosterDelegate
- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
    DLog(@"didReceiveBuddyRequest");
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    DLog(@"=========didReceiveBuddyRequest:%@",presence);
	
	XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];
	
	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;
	
	if (![displayName isEqualToString:jidStrBare])
	{
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	}
	else
	{
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}
	
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
		GBAlertView *alertView = [GBAlertView alertWithTitle:displayName
		                                                    message:body
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitle:nil];
		[alertView show];
	}
	else
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
	}
	
}

//收到添加好友的请求
//- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
//{
//    DLog(@"didReceivePresenceSubscriptionRequest");
//    //NSString *type = [presence attributeStringValueForName:@"type"];
//    //NSString *tojid   = [presence attributeStringValueForName:@"to"];
//    //NSString *fromjid = [presence attributeStringValueForName:@"from"];
//    NSString *type = [presence type];
//    NSString *to   = [[presence to] user];
//    NSString *from = [[presence from] user];
//    
//    DLog(@"type:%@,to:%@,from:%@",type,to,from);
//    
//    if([type isEqualToString:@"subscribe"]) {
//        if(![from isEqualToString:to]) {
////            [self friendRequestMessage:from toUser:to];
//        }
//    }
//    //[[presence from] user] : luoyuan,[presence fromStr] : luoyuan@tentinet-002-pc
//}


#pragma mark -
#pragma mark Core Data

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
	return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}


@end


