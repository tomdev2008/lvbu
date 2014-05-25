//
//  XMPPManager+BasicOperation.h
//  BYDFans
//
//  Created by YuanFromTentinet on 13-11-16.
//  Copyright (c) 2013年 Tentinet. All rights reserved.
//

#import "XMPPManager.h"

@class XMPPRoomManager;

@interface XMPPManager (BasicOperation)


- (void)updateHostName:(NSString *)hostName andHostPort:(long)hostPort;
- (BOOL)connect;


- (void)addBuddy:(XMPPJID *)jidUser;
- (void)removeFriend:(NSString *)jidUser;
- (void)sendMessage:(NSXMLElement *)message;


- (void)recevieMessage:(id)message from:(NSString *)from;
- (void)receivedFriendAgreeWithYourFriendRequest:(NSString *)fromUser toUser:(NSString *)toUser;
- (void)receiveSendFriendRequestReceiptMessage:(NSString *)fromUser toUser:(NSString *)toUser;
- (void)receiveSendRemoveFriendReceiptMessage:(NSString *)fromUser;
- (void)friendOfflineMessage:(NSString *)fromUser;
- (void)friendOnlineMessage:(NSString *)fromUser;
- (void)friendRemoveMessage:(NSString *)toUser toUser:(NSString *)fromUser;
- (void)friendRequestMessage:(NSString *)fromUser toUser:(NSString *)toUser;
- (void)receiveUserOnlineNews:(NSString *)fromUser;
- (void)receiveUserOfflineNews:(NSString *)fromUser;

@end
