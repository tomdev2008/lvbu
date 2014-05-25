//
//  XMPPReplyOperation.m
//  BYDFans
//
//  Created by YuanFromTentinet on 13-11-18.
//  Copyright (c) 2013年 Tentinet. All rights reserved.
//

#import "XMPPReplyOperation.h"

@interface XMPPReplyOperation()
{
    /**
     1 邀请
     2 邀请消息发送成功
     3 邀请消息发送失败
     */
    short invitation_friend_state;
    
    /**
     1 删除
     2 删除消息发送成功
     3 删除消息发送失败
     */
    short remove_friend_state;
    
    /**
     1 添加到群
     2 添加成功
     2 添加失败
     */
    short add_to_room_state;
}

@end

@implementation XMPPReplyOperation

#pragma mark -
#pragma mark 添加好友
- (void)invitationFriend:(NSString *)jidUser {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmppSendFriendInvitationSuccess:) name:@"SendFriendRequestSuccess" object:nil];
    [SVProgressHUD showWithStatus:@"请求好友..."];
    invitation_friend_state = 1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",jidUser,kJidDomain]];
        [[[XMPPManager defaultInstance] xmppRoster] subscribePresenceToUser:jid];
    });
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(xmppSendFriendInvitationFail:) userInfo:nil repeats:NO];
}
- (void)xmppSendFriendInvitationSuccess:(NSNotification *)noti {
    [SVProgressHUD dismiss];
    invitation_friend_state = 2;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SendFriendRequestSuccess" object:nil];
    
    if([_replyDelegate respondsToSelector:@selector(xmppReplyOperationInvitationFriendSuccess:)]) {
        [_replyDelegate xmppReplyOperationInvitationFriendSuccess:nil];
    }
}

- (void)xmppSendFriendInvitationFail:(id)object {
    if(invitation_friend_state != 2) {
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SendFriendRequestSuccess" object:nil];
        
        if([_replyDelegate respondsToSelector:@selector(xmppReplyOperationInvitationFriendFial:)]) {
            [_replyDelegate xmppReplyOperationInvitationFriendFial:nil];
        }
    }
}

#pragma mark -
#pragma mark 删除好友
- (void)removeFriend:(NSString *)jidUser {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmppSendFriendInvitationSuccess:) name:@"SendFriendRemoveSuccess" object:nil];
    [SVProgressHUD showWithStatus:@"删除好友..."];
    remove_friend_state = 1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",jidUser,kJidDomain]];
        [[[XMPPManager defaultInstance] xmppRoster] removeUser:jid];
    });
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(xmppSendFriendRemoveFail:) userInfo:nil repeats:NO];
}

- (void)xmppSendFriendRemoveSuccess:(NSString *)from {
    [SVProgressHUD dismiss];
    remove_friend_state = 2;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SendFriendRemoveSuccess" object:nil];
    
    if([_replyDelegate respondsToSelector:@selector(xmppReplyOperationRemoveFriendSuccess:)]) {
        [_replyDelegate xmppReplyOperationInvitationFriendSuccess:nil];
    }
}

- (void)xmppSendFriendRemoveFail:(id)object {
    if(remove_friend_state != 2) {
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SendFriendRemoveSuccess" object:nil];
        
        if([_replyDelegate respondsToSelector:@selector(xmppReplyOperationInvitationFriendFial:)]) {
            [_replyDelegate xmppReplyOperationRemoveFriendSuccess:nil];
        }
    }
}

#pragma mark -
#pragma mark 添加到群
- (void)addToRoom:(NSString *)roomname myNick:(NSString *)nick password:(NSString *)pass {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmppSendAddToRoomSuccess:) name:@"SendAddToRoomRequestSuccess" object:nil];
    [SVProgressHUD showWithStatus:@"正在请求..."];
    add_to_room_state = 1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *strRoomJID = [NSString stringWithFormat:@"%@@%@",roomname,kJidRoom];
        XMPPJID *roomJID = [XMPPJID jidWithString:strRoomJID];
        XMPPRoomCoreDataStorage *rosterstorage = [XMPPRoomCoreDataStorage sharedInstance];
        XMPPRoom *xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:rosterstorage jid:roomJID dispatchQueue:dispatch_get_main_queue()];
        [xmppRoom activate:[[XMPPManager defaultInstance] xmppStream]];
        [xmppRoom joinRoomUsingNickname:nick history:nil password:pass];
    });
    [NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(xmppSendAddToRoomFail:) userInfo:nil repeats:NO];
}
- (void)xmppSendAddToRoomSuccess:(NSNotification *)noti {
    add_to_room_state = 2;
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SendAddToRoomRequestSuccess" object:nil];
    if([_replyDelegate respondsToSelector:@selector(xmppReplyOperationAddToRoomSuccess:)]) {
        [_replyDelegate xmppReplyOperationAddToRoomSuccess:nil];
    }
}
- (void)xmppSendAddToRoomFail:(id)object {
    if(add_to_room_state != 2) {
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SendAddToRoomRequestSuccess" object:nil];
        
        if([_replyDelegate respondsToSelector:@selector(xmppReplyOperationAddToRoomFail:)]) {
            [_replyDelegate xmppReplyOperationAddToRoomFail:nil];
        }
    }
}

@end
