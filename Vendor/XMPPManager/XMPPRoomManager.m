//
//  XMPPRoomManager.m
//  BYDFans
//
//  Created by YuanFromTentinet on 13-10-30.
//  Copyright (c) 2013年 Tentinet. All rights reserved.
//

#import "XMPPRoomManager.h"
#import "XMPPRoomCoreDataStorage.h"
#import "XMPPManager.h"


@interface XMPPRoomManager()
{
    int maxmen;
}

@end

@implementation XMPPRoomManager

- (id)initWithRoomName:(NSString *)roomname {
    if(self = [super init]) {
        xmppRoomDelegateQueue = dispatch_queue_create("xmppRoomMangerxmppRoomDelegateQueue", NULL);
        NSString *strRoomJID = [NSString stringWithFormat:@"%@@%@",roomname,kJidRoom];
        XMPPJID *roomJID = [XMPPJID jidWithString:strRoomJID];
        XMPPRoomCoreDataStorage *rosterstorage = [XMPPRoomCoreDataStorage sharedInstance];
        _xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:rosterstorage jid:roomJID dispatchQueue:xmppRoomDelegateQueue];
        [self.xmppRoom activate:[[XMPPManager defaultInstance] xmppStream]];
        
    }
    return self;
}

//加入房间
-(void)joinRoomByMyNick:(NSString *)nick{
    [self.xmppRoom joinRoomUsingNickname:nick history:nil];
}

- (void)createGroupRoomMyNick:(NSString *)myNick roomPassword:(NSString *)pass{
    [self.xmppRoom joinRoomUsingNickname:myNick history:nil password:nil];
    [self.xmppRoom addDelegate:self delegateQueue:xmppRoomDelegateQueue];
}

-(void)editGroupRoomByMyNick:(NSString*)myNick andGroupInfo:(NSArray*)myEditInfo {
    [self.xmppRoom joinRoomUsingNickname:myNick history:nil password:nil];
    [self.xmppRoom editRoomPrivileges:myEditInfo];
}

- (void)inviteGroupMember:(NSString *)username message:(NSString *)mess roomnick:(NSString *)nick andProtrait:(NSString*)portrait{
        NSString *strJID = [NSString stringWithFormat:@"%@@%@",username,kJidDomain];
        [self.xmppRoom inviteUser:[XMPPJID jidWithString:strJID] withMessage:mess andSender:[GlobalCommen CurrentUser].username andsenderGroupNick:nick andGroupPortrait:portrait];
}


- (void)inviteGroupMembers:(NSArray *)arrUsername message:(NSString *)mess roomnick:(NSString *)nick{
//    [self.xmppRoom joinRoomUsingNickname:nick history:nil password:nil];
    for(NSString *username in arrUsername) {
        NSString *strJID = [NSString stringWithFormat:@"%@@%@",username,kJidDomain];
        [self.xmppRoom inviteUser:[XMPPJID jidWithString:strJID] withMessage:mess andSender:[GlobalCommen CurrentUser].username andsenderGroupNick:nick andGroupPortrait:nil];
    }
}

- (void)addToGroup:(NSString *)usernick {
//    XMPPJID *jid = [XMPPJID jidWithString:usernick];
    [self.xmppRoom joinRoomUsingNickname:usernick history:nil password:nil];
    //[[XMPPManager defaultInstance] xmppRoster] add
}

- (void)sendXMPPMessage:(XMPPMessage *)message {
    [self.xmppRoom sendMessage:message];
}

- (void)sendNSStringMessageWithBody:(NSString *)messageBody {
    [self.xmppRoom sendMessageWithBody:messageBody];
}

- (void)changeUserNickname:(NSString *)newNickname {
    [self.xmppRoom changeNickname:newNickname];
}
- (void)changeCurrRoomSubject:(NSString *)newRoomSubject {
    [self.xmppRoom changeRoomSubject:newRoomSubject];
}
- (void)leaveTheRoom {
    [self.xmppRoom deactivate];
}
- (void)deleteTheRoom {
    [self.xmppRoom destroyRoom];
}

#pragma mark ------------xmppRoom Delegate-----------------
//Create Room Success
- (void)xmppRoomDidCreate:(XMPPRoom *)sender {
    
}
//leave the chat room
- (void)xmppRoomDidLeave:(XMPPRoom *)sender {
    NSLog(@"离开了聊天室");
}
//new people to join the room
- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}
//someone quit the room
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}
//recive news
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID {
    
}
//配置房间
- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(DDXMLElement *)configForm {

    [self.xmppRoom configureRoomUsingOptions:_elementx];
    
    if([_delegate respondsToSelector:@selector(createGroupRoomSuccess:)]) {
        [_delegate createGroupRoomSuccess:nil];
    }
}

//Featch Room Info
- (void)xmppRoomDidJoin:(XMPPRoom *)sender {
    [self.xmppRoom fetchConfigurationForm];
}
//###if there is Room, will Call the following three methods
// 收到好友名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items {
    NSLog(@"%i",items.count);
}
// 收到主持人名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items {
    NSLog(@"%i",items.count);
}
//if there room does not exist,would call the following three methods
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError {
    
}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError {
    
}


@end
