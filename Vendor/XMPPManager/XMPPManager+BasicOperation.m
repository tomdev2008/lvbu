//
//  XMPPManager+BasicOperation.m
//  BYDFans
//
//  Created by YuanFromTentinet on 13-11-16.
//  Copyright (c) 2013年 Tentinet. All rights reserved.
//


#import "XMPPManager+BasicOperation.h"
#import "BYDAppDelegate.h"

#import "WBErrorNoticeView.h"

@implementation XMPPManager (BasicOperation)


- (void)updateHostName:(NSString *)hostName andHostPort:(long)hostPort {
    [xmppStream setHostName:hostName];
    [xmppStream setHostPort:hostPort];
}
- (BOOL)connect {
//    NSString *myUsername = [[NSUserDefaults standardUserDefaults] stringForKey:kLoginUsername];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kLoginPassword];
    BOOL isConnect = [self connectOpenfireUsername:[[GlobalCommen CurrentUser] dixun_number] password:myPassword];
    return isConnect;
}

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

#pragma mark -
#pragma mark 添加 删除好友 发送消息 
- (void)addBuddy:(XMPPJID *)jid {
    [xmppRoster subscribePresenceToUser:jid];
}
- (void)removeFriend:(NSString *)jidUser {
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",jidUser,kJidDomain]];
    [xmppRoster removeUser:jid];
}
- (void)sendMessage:(NSXMLElement *)message {
    [xmppStream sendElement:message];
}
- (void)recevieMessage:(id)message_ from:(NSString *)from {
    
    BYDAppDelegate *app = (BYDAppDelegate *)[[UIApplication sharedApplication] delegate];
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        
        //当正在和用户聊天
        if(app.currentChatUsernameluo && [from rangeOfString:app.currentChatUsernameluo].location != NSNotFound) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                
                NSString *sendUsername= [[from componentsSeparatedByString:@"@"] objectAtIndex:0];
                
                NSString *subject      = [[message_ elementForName:@"subject"] stringValue];
                NSMutableDictionary *dicNoti = [[NSMutableDictionary alloc] init];
                [dicNoti setValue:message_ forKey:@"xmppMessage"];
                NSString *sendUserNick = nil;
                NSArray  *arrProperty = [[message_ elementForName:@"properties"] elementsForName:@"property"];
                for(NSXMLElement *property in arrProperty) {
                    NSXMLElement *name = [property elementForName:@"name"];
                    NSString     *nameValue = [name stringValue];
                    NSString     *value= [[property elementForName:@"value"] stringValue];
                    if([nameValue isEqualToString:@"chat_object_nick"]) {
                        sendUserNick = value ? value : nil;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{

                    if (subject.intValue<5||subject.intValue==14) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:ChatReciveNewMessage object:dicNoti];
                        
                        User *user = [GlobalCommen CurrentUser];
                        if (!sendUserNick||[user.nick isEqualToString:sendUserNick]) {
                            return;
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:GroupReciveNewMessage object:dicNoti];
                    }else if (subject.intValue>11&&subject.intValue<14){
                        [[NSNotificationCenter defaultCenter] postNotificationName:GroupReciveNewMessage object:dicNoti];
                    }else if (subject.intValue==15){
                        
                        Friend *friend = [DataBaseManager selectFriendDetailsAccordingFriendUserName:sendUsername];
                        friend.beforbid = @"1";
                        [DataBaseManager updateFriendAccordingFriend:friend];
                        [DataBaseManager closeDataBase];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:ReciveBeForbidden object:dicNoti];
                    }else if (subject.intValue==17){
                        Friend *friend = [DataBaseManager selectFriendDetailsAccordingFriendUserDiXinNum:sendUsername];
                        [DataBaseManager deleteChatListByObjectId:friend.username];
                        [DataBaseManager deleteChatTableByUserDiXinNum:friend.dixun_number];
                        [DataBaseManager deleteFriendByUserDiXinNum:friend.dixun_number];
                        [[NSNotificationCenter  defaultCenter]postNotificationName:ReciveBeDelete object:nil];
                    }else if (subject.intValue==18){
                        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
                        [body setStringValue:@"欢迎加入迪讯"];
                        NSXMLElement *subject = [NSXMLElement elementWithName:@"subject"];
                        [subject setStringValue:[NSString stringWithFormat:@"%i",kFileText]];
                        NSXMLElement *properties = [NSXMLElement elementWithName:@"properties" xmlns:@"http://www.jivesoftware.com/xmlns/xmpp/properties"];
                        NSXMLElement *propertie1 = [NSXMLElement elementWithName:@"property"];
                        NSXMLElement *name1 = [NSXMLElement elementWithName:@"name" stringValue:@"chat_object_nick"];
                        NSXMLElement *value1= [NSXMLElement elementWithName:@"value"];
                        [value1 addAttributeWithName:@"type" stringValue:@"string"];
                        [value1 setStringValue:sendUsername];
                        [propertie1 addChild:name1];
                        [propertie1 addChild:value1];
                        [properties addChild:propertie1];
                        
                        NSString *portraiter = nil;
                        if ([sendUsername isEqualToString:@"bydpublicboutique"]) {
                            portraiter = @"/upload/group_portrait/12.png";
                        }else if ([sendUsername isEqualToString:@"bydpublicccar"]){
                            portraiter = @"/upload/group_portrait/1.png";
                        }else if ([sendUsername isEqualToString:@"bydpubliccustomerser"]){
                            portraiter = @"/upload/group_portrait/10.png";
                        }
                        
                        NSXMLElement *propertie2 = [NSXMLElement elementWithName:@"property"];
                        NSXMLElement *name2 = [NSXMLElement elementWithName:@"name" stringValue:@"chat_object_portrait"];
                        NSXMLElement *value2= [NSXMLElement elementWithName:@"value"];
                        [value2 addAttributeWithName:@"type" stringValue:@"string"];
                        [value2 setStringValue:portraiter];
                        [propertie2 addChild:name2];
                        [propertie2 addChild:value2];
                        [properties addChild:propertie2];
                        
                        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
                        NSString *to = [NSString stringWithFormat:@"%@@%@",[[GlobalCommen CurrentUser] username],kJidDomain];
                        [mes addAttributeWithName:@"to" stringValue:to];
                        [mes addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@%@",sendUsername,kJidDomain]];
                        [mes addAttributeWithName:@"type" stringValue:@"chat"];
                        [mes addChild:body];
                        [mes addChild:subject];
                        [mes addChild:properties];
                        
                        NSMutableDictionary *dicNot = [[NSMutableDictionary alloc] init];
                        [dicNot setValue:mes forKey:@"xmppMessage"];


                        [[NSNotificationCenter defaultCenter] postNotificationName:ChatReciveNewMessage object:dicNot];
                    }
                    
                    
                });
                
            });
            
                
        }else {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            XMPPMessage *message = message_;
            
                
            //first of all, wo should check if the message be a group invite message   zhaohao
            NSXMLElement *eleX = [message elementForName:@"x"];
            NSXMLElement *eleInvite = [eleX elementForName:@"invite"];
            
            NSLog(@"zhaohao test normal element");
            //<!_____找到发送人的用户登录名_____>[user displayName];//获取全称
                NSArray  *arrProperty = [[message elementForName:@"properties"] elementsForName:@"property"];
                NSString *object_type = [message attributeStringValueForName:@"type"];
                NSString *from        = [message attributeStringValueForName:@"from"];
                NSString *sendUsername= [[from componentsSeparatedByString:@"@"] objectAtIndex:0];
                NSString *groupChatUser = nil;
                if ([from contains:@"/"]) {
                    groupChatUser = [[from componentsSeparatedByString:@"/"] objectAtIndex:1];
                }
                NSString *type        = [[message elementForName:@"subject"] stringValue];
                NSString *body        = [[message elementForName:@"body"] stringValue];
                NSString *sendUserPortrait = nil;
                NSString *sendUserNick = nil;
                NSString *sendTime = nil;
                NSString *group_name = nil;
                NSString *userAccount = nil;
                for(NSXMLElement *property in arrProperty) {
                    NSXMLElement *name      = [property elementForName:@"name"];
                    NSString     *nameValue = [name stringValue];
                    NSString     *value     = [[property elementForName:@"value"] stringValue];
                    if([nameValue isEqualToString:@"chat_object_nick"]) {
                        sendUserNick = value ? value : nil;
                    } else if([nameValue isEqualToString:@"chat_object_portrait"]){
                        sendUserPortrait = value ? value : nil;
                    }else if ([nameValue isEqualToString:@"chat_group_portrait"]){
                        sendUserPortrait = value ? value :nil;
                    }else if([nameValue isEqualToString:@"send_time"]) {
                        sendTime = value ? value : nil;
                    }else if ([nameValue isEqualToString:@"chat_group_name"]){
                        group_name = value ? value : @"";
                    }else if ([nameValue isEqualToString:@"group_name"]){
                        group_name = value ? value:nil;
                    }else if ([nameValue isEqualToString:@"portrait"]){
                        sendUserPortrait = value ? value : nil;
                    }else if ([nameValue isEqualToString:@"username"]){
                        userAccount = value;
                    }
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    if (eleInvite){
                        [self saveGroupMessage:sendUsername :sendUserNick :sendUserPortrait :sendTime : @"8" :nil :@"2" :group_name :groupChatUser :userAccount];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"SendAddToRoomRequestSuccess" object:from];
                        
                    }else {
                        if(object_type && [object_type isEqualToString:@"chat"])
                        {
                            if (type.intValue==6) {
                                NSMutableDictionary *dicNoti = [[NSMutableDictionary alloc] init];
                                
                                User *user = [GlobalCommen CurrentUser];
                                self.roomManager = [[XMPPRoomManager alloc] initWithRoomName:body];
                                NSLog(@"body:%@",body);
                                [self.roomManager joinRoomByMyNick:user.dixun_number];
                                [dicNoti setValue:message forKey:@"xmppMessage"];
                                [self getJoinRequestAbout:dicNoti];
                                
                                
                            }else if (type.intValue==7){
                                [self getInviteGroupDic:message];
                            }else if(type.intValue==8){
                                User *user = [GlobalCommen CurrentUser];
                                self.roomManager = [[XMPPRoomManager alloc] initWithRoomName:body];
                                NSLog(@"body:%@",body);
                                [self.roomManager joinRoomByMyNick:user.dixun_number];
                                [self.roomManager inviteGroupMember:sendUsername message:@"hello" roomnick:group_name andProtrait:sendUserPortrait];
                            }else if(type.intValue<9||(type.intValue==14)){
                                
                            
                                [self saveChatMessage:sendUsername :sendUserNick :sendUserPortrait :sendTime :type :body :@"1" :userAccount];
                            }else if (type.intValue>11&&type.intValue<14) {
                                

                                
                                [DataBaseManager deleteGroupByGroupId:body];
                                [DataBaseManager deleteChatListByObjectId:body];
                                [DataBaseManager deleteChatGroupTableByGroupId:body];
                                
                            }else if (type.intValue==15){
                                [DataBaseManager stampBeForbidByDiXunNum:sendUsername];
                            }else if ([type isEqualToString:@"16"]){
                                [DataBaseManager stampNotBeForbidByDiXunNum:sendUsername];
                            }else if (type.intValue==17){
                                Friend *friend = [DataBaseManager selectFriendDetailsAccordingFriendUserDiXinNum:sendUsername];
                                [DataBaseManager deleteChatListByObjectId:friend.username];
                                [DataBaseManager deleteChatTableByUserDiXinNum:friend.dixun_number];
                                [DataBaseManager deleteFriendByUserDiXinNum:friend.dixun_number];
                            }
                            
                            
                        } else if(object_type && [object_type isEqualToString:@"groupchat"])
                        {
                            
                            NSString *subject = [[message elementForName:@"subject"] stringValue];
                            
                            if (subject) {//
                                if (subject.intValue<9||subject.intValue==14) {
                                    NSDate *date = [self dateFromString:sendTime];
                                    NSDate *dateLocal = [[NSUserDefaults standardUserDefaults]valueForKey:sendUsername];
                                    if (dateLocal) {
                                        if ([[dateLocal earlierDate:date]isEqualToDate:dateLocal]&&![dateLocal isEqualToDate:date]) {
                                            if (![group_name isEqualToString:@""]) {
                                                [self saveGroupMessage:sendUsername :sendUserNick :sendUserPortrait :sendTime :type :body :@"2" :group_name :groupChatUser :userAccount];
                                            }
                                            [[NSUserDefaults standardUserDefaults]setValue:date forKey:sendUsername];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                        }else{
                                            return;
                                        }
                                    }else{
                                        if (![group_name isEqualToString:@""]) {
                                            [self saveGroupMessage:sendUsername :sendUserNick :sendUserPortrait :sendTime :type :body :@"2" :group_name :groupChatUser :userAccount];
                                        }
                                        [[NSUserDefaults standardUserDefaults]setValue:date forKey:sendUsername];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                    }
                                    
                                    
                                }else if (subject.intValue==19){
                                    ChatList *cl = [DataBaseManager selectChatListByChatObjectUserName:sendUsername];
                                    NSArray*arr_group = [DataBaseManager selectGroupDetailByGroupId:sendUsername];
                                    Group *group = arr_group[0];
                                    group.name = body;
                                    if ([DataBaseManager updateGroupInfo:group]) {
                                        
                                    }
                                    if (cl) {
                                        cl.chat_object_username = body;
                                        [DataBaseManager updateChatListByChatList:cl];
                                    }
                                    
                                }
                            }
                            
                        }else{
                            if (type.intValue==18) {
                                NSString *portraiter = nil;
                                NSString *strChatName = nil;
                                if ([sendUsername isEqualToString:@"bydpublicboutique"]) {
                                    portraiter = @"/upload/group_portrait/12.png";
                                    strChatName = @"比亚迪精品";
                                }else if ([sendUsername isEqualToString:@"bydpublicccar"]){
                                    portraiter = @"/upload/group_portrait/1.png";
                                    strChatName = @"比亚迪汽车";
                                }else if ([sendUsername isEqualToString:@"bydpubliccustomerser"]){
                                    portraiter = @"/upload/group_portrait/10.png";
                                    strChatName = @"比亚迪客服";
                                }
                                [self saveChatMessage:sendUsername :strChatName :portraiter :[GeneralToolClass fetchStringLocalDateAndTime] :@"1" :body :@"1" :sendUsername];
                            }
                        }

                    }
                });
            
            });
            
        }
    }
    
}

-(void)getInviteGroupDic:(XMPPMessage*)message{
    NSMutableDictionary *inviteDic = [[NSMutableDictionary alloc]init];
    NSString *from = [message attributeStringValueForName:@"from"];
    NSString *sendUserName= [[from componentsSeparatedByString:@"@"] objectAtIndex:0];
    NSArray  *arrProperty = [[message elementForName:@"properties"] elementsForName:@"property"];
    NSString *sendGroupId = [[message elementForName:@"body"] stringValue];
    NSString *sendUserNick = nil;
    NSString *sendGroupNick = nil;
    NSString *sendGroupPortrait = nil;
    NSString *userAccount = nil;
    for(NSXMLElement *property in arrProperty) {
        NSXMLElement *name = [property elementForName:@"name"];
        NSString     *nameValue = [name stringValue];
        NSString     *value= [[property elementForName:@"value"] stringValue];
        if([nameValue isEqualToString:@"chat_object_nick"]) {
            sendUserNick = value ? value : nil;
        } else if([nameValue isEqualToString:@"group_name"]){
            sendGroupNick = value ? value : nil;
        }else if ([nameValue isEqualToString:@"portrait"]){
            sendGroupPortrait = value ? value : nil;
        } else if ([nameValue isEqualToString:@"username"]){
            userAccount = value;
        }
    }
    
    NewFrineds *newF = [[NewFrineds alloc] init];
    newF.friend_username = sendGroupId;
    newF.friend_nick = sendUserNick;
    newF.friend_type = @"20";    //组请求
    newF.is_read     = @"1";    //wei du,表示要从服务器获取数
    newF.source      = sendGroupNick;
    newF.friend_portrait = sendGroupPortrait;
    newF.friend_id = userAccount;
    newF.dixun_number = sendUserName;
    GroupJoined *groupJoined = [[GroupJoined alloc]init];
    groupJoined.groupId = sendGroupId;
    
    NSMutableArray * arr_friend = [[NSMutableArray alloc]init];
    for (NewFrineds*friend in [DataBaseManager selectIFThereISNewFriendAccordingFriendUsername:newF]) {
        if (friend.friend_type.intValue>=20) {
            [arr_friend addObject:friend];
        }
    }
    
    if (arr_friend.count==0) {
        if(![DataBaseManager insertNewFriends:newF]) {
            DLog(@"XMPPManager 插入新朋友失败!");
        }
    }else{
        if (![DataBaseManager updateNewFriendAccordingFriendUsername:newF]) {
            DLog(@"XMPPManager 插入新朋友失败（接到邀请进群）!");
        }
    }
    
    
//    if(![DataBaseManager fetchIfthereHasTheGroupJoinRequest:groupJoined]){
//        if(![DataBaseManager insertNewFriends:newF]) {
//            DLog(@"XMPPManager 插入新朋友失败!");
//        }
//    }
    
    
    [DataBaseManager closeDataBase];
    
    [inviteDic setObject:sendGroupId forKey:@"groupId"];
    [inviteDic setObject:sendGroupNick forKey:@"groupNick"];
    [inviteDic setObject:sendUserNick forKey:@"userNick"];
    User *user = [GlobalCommen CurrentUser];
    self.roomManager = [[XMPPRoomManager alloc] initWithRoomName:sendGroupId];
    [self.roomManager joinRoomByMyNick:user.dixun_number];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:DiYouReciveInviteGroupRequest object:inviteDic];
}

-(void)getJoinRequestAbout:(NSDictionary*)dic{

    XMPPMessage *message = [dic objectForKey:@"xmppMessage"];
    

    NSString *from        = [message attributeStringValueForName:@"from"];
    NSString *sendUsername= [[from componentsSeparatedByString:@"@"] objectAtIndex:0];
//    NSString *type        = [[message elementForName:@"subject"] stringValue];
//    NSString *body        = [[message elementForName:@"body"] stringValue];
    NSString *strMes      = [[message elementForName:@"body"] stringValue];
    NSLog(@"strMes:%@",strMes);
    
    NSString *sendUserNick = nil;
    NSString *sendTime = nil;
    NSString *userAccount = nil;
    NSString *groupPortrait = nil;
    NSArray  *arrProperty = [[message elementForName:@"properties"] elementsForName:@"property"];
    for(NSXMLElement *property in arrProperty) {
        NSXMLElement *name = [property elementForName:@"name"];
        NSString     *nameValue = [name stringValue];
        NSString     *value= [[property elementForName:@"value"] stringValue];
        if([nameValue isEqualToString:@"chat_object_nick"]) {
            sendUserNick = value ? value : nil;
        } else if([nameValue isEqualToString:@"send_time"]) {
            sendTime = value ? value : nil;
        }else if ([nameValue isEqualToString:@"username"]){
            userAccount = value ? value :nil;
        }else if ([nameValue isEqualToString:@"portrait"]){
            groupPortrait = value;
        }
    }
    
    NewFrineds *newF = [[NewFrineds alloc] init];
    newF.dixun_number = sendUsername;
    newF.friend_username = userAccount;
    newF.friend_nick = sendUserNick;
    newF.friend_type = @"10";    //组请求
    newF.is_read     = @"1";    //wei du,表示要从服务器获取数
    newF.source      =strMes;
    newF.friend_portrait = groupPortrait;
    
    NSMutableArray * arr_friend = [[NSMutableArray alloc]init];
    for (NewFrineds*friend in [DataBaseManager selectIFThereISNewFriendAccordingFriendUsername:newF]) {
        if (friend.friend_type.intValue>=10&&friend.friend_type.intValue<20) {
            [arr_friend addObject:friend];
        }
    }
    
    if (arr_friend.count==0) {
        if(![DataBaseManager insertNewFriends:newF]) {
            DLog(@"XMPPManager 插入新朋友失败!");
        }
    }else{
        if (![DataBaseManager updateNewFriendAccordingFriendUsername:newF]) {
            DLog(@"XMPPManager 插入新朋友失败（接到申请进群）!");
        }
    }
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:DiYouReciveJoinGroupRequest object:nil];
    [DataBaseManager closeDataBase];

}

- (void)saveChatMessage:(NSString *)sendUsername :(NSString *)sendUserNick :(NSString *)sendUserPortrait :(NSString *)sendTime :(NSString *)type :(NSString *)body :(NSString *)object_type :(NSString*)userAccount{
    Chat *chat = [[Chat alloc] init];
    chat.chat_object_username = userAccount;
    chat.chat_object_nick     = sendUserNick;
    chat.chat_object_portrait = sendUserPortrait;
    chat.send_time            = sendTime;
    chat.type                 = type;
    chat.dixun_number         = sendUsername;
    chat.is_mine = [userAccount isEqualToString:[GlobalCommen CurrentUser].username]?@"1":@"2";//2为对方发出，1为我发出
    chat.message = body;
    chat.is_read = @"1";//未读，2为已读
    chat.timestamp = [NSString stringWithFormat:@"%lf",[[NSDate date] timeIntervalSince1970]];
    if(![DataBaseManager insertChat:chat]) {
        [[GeneralToolClass defaultInstance] popUpWarningView:@"DiYouViewController插入Chat失败"];
    }
    
    ChatList *theChatList = [DataBaseManager selectChatListByChatObjectUserName:chat.chat_object_username];

    if(!theChatList)
    {
        ChatList *cl = [[ChatList alloc] init];
        cl.chat_object_id = chat.chat_object_username;
        cl.chat_object_nick = chat.chat_object_nick;//呢称
        cl.chat_object_portrait = chat.chat_object_portrait;//
        cl.last_chat_message = chat.message;
        cl.type = chat.type;//1:文本，2:语音，3:图片，4:文件
        cl.last_time = chat.send_time;//
        cl.not_read = [NSString stringWithFormat:@"%i",[theChatList.not_read intValue]+1];
        cl.object_type = object_type;
        cl.chat_object_username=userAccount;
        cl.chat_account = userAccount;
        cl.dixun_number = sendUsername;
        //cl.chat_object_sex = chat.chat_object_sex;//
        if(![DataBaseManager insertChatList:cl]) {
            [[GeneralToolClass defaultInstance] popUpWarningView:@"XMPPManagerBasicOperation插入ChatList失败"];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:DiYouReciveNewMessage object:sendUsername];
        }
    } else {
        ChatList *chatList =theChatList;
        chatList.last_chat_message = chat.message;
        chatList.last_time = chat.send_time;
        chatList.not_read = [NSString stringWithFormat:@"%i",([theChatList.not_read intValue]+1)];
        chatList.type = chat.type;
        chatList.object_type = object_type;
        chatList.chat_account = userAccount;
        chatList.dixun_number = sendUsername;
        if(![DataBaseManager updateChatListByChatList:chatList]) {
            [[GeneralToolClass defaultInstance] popUpWarningView:@"DiYouViewController更新ChatList失败"];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:DiYouReciveNewMessage object:sendUsername];
        }
    }
    
    [DataBaseManager closeDataBase];
    
    
}

- (void)saveGroupMessage:(NSString *)sendUsername :(NSString *)sendUserNick :(NSString *)sendUserPortrait :(NSString *)sendTime :(NSString *)type :(NSString *)body :(NSString *)object_type :(NSString*)groupName :(NSString*)chatUserDixunnum :(NSString*)userAccount {
    ChatGroup *chat = [[ChatGroup alloc] init];
    
    chat.chat_group_name      = groupName;
    chat.chat_object_nick     = sendUserNick;
    if ([DataBaseManager selectIFThereISFriendAccordingUsername:[userAccount lowercaseString]]) {
        NSString*strNote = [[DataBaseManager selectFriendDetailsAccordingFriendUserName:[userAccount lowercaseString]] note_name];
        if (strNote) {
            chat.chat_object_nick = strNote;
        }
    }
    chat.chat_group_id        = sendUsername;
    chat.chat_object_portrait = sendUserPortrait;
    chat.send_time            = sendTime;
    chat.type                 = type;
    chat.chat_object_username = userAccount;
    chat.is_mine = [[userAccount lowercaseString] isEqualToString:[[GlobalCommen CurrentUser].username lowercaseString]]?@"1":@"2";//2为对方发出，1为我发出
    chat.message = body;
    chat.is_read = @"1";//未读，2为已读
    
    //查询tb_chat表,求出未读个数
    ChatList *theChatList = [DataBaseManager selectChatListByChatObjectUserName:chat.chat_group_id];
    if(!theChatList) {
        ChatList *cl = [[ChatList alloc] init];
        cl.chat_object_id = sendUsername;//chat.chat_object_username;
        cl.chat_object_nick = chat.chat_object_nick;//呢称
        cl.chat_object_portrait = chat.chat_object_portrait;//
        cl.last_chat_message = chat.message;
        cl.type = chat.type;//1:文本，2:语音，3:图片，4:文件
        cl.last_time = chat.send_time;//
        cl.not_read = [NSString stringWithFormat:@"%i",[theChatList.not_read intValue]+1];
        cl.object_type = object_type;
        cl.chat_object_username=chat.chat_group_name;
        cl.chat_account = userAccount;
        //cl.chat_object_sex = chat.chat_object_sex;//
        if(![DataBaseManager insertChatList:cl]) {
            [[GeneralToolClass defaultInstance] popUpWarningView:@"XMPPManagerBasicOperation插入ChatList失败"];
        }
            
    } else {
        ChatList *chatList = theChatList;
        chatList.last_chat_message = chat.message;
        chatList.chat_object_id = sendUsername;
        chatList.chat_object_nick = chat.chat_object_nick;
        chatList.not_read = [NSString stringWithFormat:@"%i",[theChatList.not_read intValue]+1];
        chatList.last_time = chat.send_time;
        chatList.type = chat.type;
        chatList.object_type = object_type;
        chatList.chat_object_portrait = chat.chat_object_portrait;
        chatList.chat_account = userAccount;
        chatList.chat_object_username = chat.chat_group_name;
        if(![DataBaseManager updateChatListByChatList:chatList]) {
//            [[GeneralToolClass defaultInstance] popUpWarningView:@"DiYouViewController更新ChatList失败"];
        }
    }
    
    if(![DataBaseManager insertChatGroup:chat isSend:0]) {
        //        [[GeneralToolClass defaultInstance] popUpWarningView:@"DiYouViewController插入ChatGroup失败"];    
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:DiYouReciveNewMessage object:sendUsername];
    }
    
    [DataBaseManager closeDataBase];
    
    
}

#pragma mark -
#pragma mark 收到好友请求消息 好友删除消息
- (void)friendRequestMessage:(NSString *)fromUser toUser:(NSString *)toUser {
    
    NewFrineds *newF = [[NewFrineds alloc] init];
    newF.dixun_number = fromUser;
    newF.friend_type = @"1";//好友
    newF.is_read     = @"1";    //wei du,表示要从服务器获取数
    NSMutableArray *arr_friend = [[NSMutableArray alloc]init];
    for (NewFrineds*friend in [DataBaseManager selectIFThereISNewFriendAccordingFriendUsername:newF]) {
        if (friend.friend_type.intValue<4) {
            [arr_friend addObject:friend];
        }
    }
    if(arr_friend.count==0) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:nil];
        
        newF.friend_type = @"2";
        SessionManager *mgr = [SessionManager manager];
        mgr.failedBlock = ^(NSString*errorInfo){
            if(![DataBaseManager insertNewFriends:newF]) {
                DLog(@"XMPPManager 插入新朋友失败!");
                //发出添加我为好友请求消息
                
                
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiveAddMeForFriendMessage" object:newF];
            }
        };
        mgr.completeBlock = ^(NewFrineds*nf){
            nf.friend_type = newF.friend_type;
            nf.is_read = newF.is_read;
            if(![DataBaseManager insertNewFriends:nf]) {
                DLog(@"XMPPManager 插入新朋友失败!");
                //发出添加我为好友请求消息
                
                
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiveAddMeForFriendMessage" object:nf];
            }
        };
        [mgr getUserInfoByDiXunNum:newF.dixun_number];
    }else{
        NewFrineds *nf = [arr_friend objectAtIndex:0];
        if ([nf.friend_type isEqualToString:@"3"]) {
//            nf.friend_type = @"2";
//            [DataBaseManager updateNewFriendAccordingFriendUsername:nf];
        }else if ([nf.friend_type isEqualToString:@"1"]){
            nf.friend_type = @"3";
            [DataBaseManager updateNewFriendAccordingFriendUsername:nf];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiveAddMeForFriendMessage" object:newF];
        }
        
    }
    
    [DataBaseManager closeDataBase];
}
- (void)friendRemoveMessage:(NSString *)toUser toUser:(NSString *)fromUser{
    //jid 删除 tojid用户成功
    if(![DataBaseManager deleteFriendAccordingFriendUsername:fromUser]) {
        [[GeneralToolClass defaultInstance] popUpWarningView:@"数据库删除用户失败!"];
    }
    if([DataBaseManager selectNewFriendAccordingFriendUsername:fromUser]) {
        [DataBaseManager deleteNewFriendAccordingFriendUsername:fromUser];
    }
    
    [DataBaseManager closeDataBase];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivedFriendRemoveMeMessage" object:username];
}

#pragma mark -
#pragma mark 好友上线消息 好友下线消息
- (void)friendOnlineMessage:(NSString *)fromUser {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:fromUser];
}
- (void)friendOfflineMessage:(NSString *)fromUser {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:fromUser];
}
- (void)receiveUserOnlineNews:(NSString *)fromUser {
    
}
- (void)receiveUserOfflineNews:(NSString *)fromUser {
    
}
#pragma mark -
#pragma mark 收到[发送好友请求消息 好友删除消息]消息回执
- (void)receiveSendFriendRequestReceiptMessage:(NSString *)fromUser toUser:(NSString *)toUser {
    
}
- (void)receiveSendRemoveFriendReceiptMessage:(NSString *)fromUser {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SendFriendRemoveSuccess" object:nil];
}

#pragma mark -
#pragma mark 收到好友同意您的好友请求
- (void)receivedFriendAgreeWithYourFriendRequest:(NSString *)fromUser toUser:(NSString *)toUser{
    
    NewFrineds *newF = [[NewFrineds alloc] init];
    newF.dixun_number = fromUser;
    NSMutableArray*arr_friend = [DataBaseManager selectIFThereISNewFriendAccordingFriendUsername:newF];

    for (NewFrineds*friend in arr_friend) {
        if (friend.friend_type.intValue<4) {
            [arr_friend addObject:friend];
        }
    }
    
    if (arr_friend.count>0) {
        NewFrineds*nef = [arr_friend objectAtIndex:0];
        if([nef.friend_type isEqualToString:@"2"]) {
            nef.friend_type = @"3";
            nef.is_read = @"1";
            if(![DataBaseManager updateNewFriendAccordingFriendUsername:newF]) {
                DLog(@"XMPPManager 更新新朋友失败!");
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReceiveAddFriendSuccessMessage" object:newF];
        }
    }
    
    
    
    [DataBaseManager closeDataBase];
}


@end
