//
//  XMPPReplyOperation.h
//  BYDFans
//
//  Created by YuanFromTentinet on 13-11-18.
//  Copyright (c) 2013年 Tentinet. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMPPReplyOperationDelegate <NSObject>

- (void)xmppReplyOperationInvitationFriendSuccess:(NSString *)jidUser;
- (void)xmppReplyOperationInvitationFriendFial:(NSString *)jidUser;

- (void)xmppReplyOperationRemoveFriendSuccess:(NSString *)jidUser;
- (void)xmppReplyOperationRemoveFriendFial:(NSString *)jidUser;

- (void)xmppReplyOperationAddToRoomSuccess:(NSString *)roomJid;
- (void)xmppReplyOperationAddToRoomFail:(NSString *)roomJid;

@end

@interface XMPPReplyOperation : NSObject

@property (nonatomic, assign) id<XMPPReplyOperationDelegate>replyDelegate;

- (void)invitationFriend:(NSString *)jidUser;

- (void)removeFriend:(NSString *)jidUser;

- (void)addToRoom:(NSString *)roomname myNick:(NSString *)nick password:(NSString *)pass;



@end
