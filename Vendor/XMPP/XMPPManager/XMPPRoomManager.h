//
//  XMPPRoomManager.h
//  BYDFans
//
//  Created by YuanFromTentinet on 13-10-30.
//  Copyright (c) 2013年 Tentinet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "XMPPRoom.h"

@protocol XMPPRoomManagerDelegate;

@interface XMPPRoomManager : NSObject<XMPPRoomDelegate>
{
    dispatch_queue_t xmppRoomDelegateQueue;
}

@property (nonatomic, assign) id<XMPPRoomManagerDelegate> delegate;
@property (nonatomic, retain) XMPPRoom *xmppRoom;
@property (nonatomic, retain) NSXMLElement *elementx;

- (id)initWithRoomName:(NSString *)roomname;

//创建加入房间
- (void)createGroupRoomMyNick:(NSString *)myNick roomPassword:(NSString *)pass;
//邀请好友
- (void)inviteGroupMember:(NSString *)username message:(NSString *)mess roomnick:(NSString *)nick andProtrait:(NSString*)portrait;
//邀请多个好友
- (void)inviteGroupMembers:(NSArray *)arrUsername message:(NSString *)mess roomnick:(NSString *)nick;
//离开房间
- (void)leaveTheRoom;
//删除房间
- (void)deleteTheRoom;
//发送消息
- (void)sendXMPPMessage:(XMPPMessage *)message;
- (void)sendNSStringMessageWithBody:(NSString *)messageBody;
//改变呢称
- (void)changeUserNickname:(NSString *)newNickname;
//更改房间主题
- (void)changeCurrRoomSubject:(NSString *)newRoomSubject;
- (void)addToGroup:(NSString *)usernick;
//加入房间
- (void)joinRoomByMyNick:(NSString*)nick;
//修改房间信息
-(void)editGroupRoomByMyNick:(NSString*)myNick andGroupInfo:(NSArray*)myEditInfo;
@end


@protocol XMPPRoomManagerDelegate <NSObject>

- (void)createGroupRoomSuccess:(NSString *)groupNumber;

@end
