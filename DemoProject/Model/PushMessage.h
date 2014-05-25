//
//  PushMessage.h
//  DemoProject
//
//  Created by zzc on 14-5-24.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


/**
 *  推送消息
 */


@interface PushMessage : NSManagedObject

@property (nonatomic, retain) NSString * alert;         //提示信息
@property (nonatomic, retain) NSNumber * badge;         //消息个数
@property (nonatomic, retain) NSNumber * dst;           //消息目标UID
@property (nonatomic, retain) NSString * func;          //功能号
@property (nonatomic, retain) NSString * msg;           //消息内容
@property (nonatomic, retain) NSNumber * msgid;         //消息ID
@property (nonatomic, retain) NSNumber * msgtype;       //消息内容类型
@property (nonatomic, retain) NSString * sound;         //提示声音
@property (nonatomic, retain) NSNumber * src;           //消息来源UID
@property (nonatomic, retain) NSString * tick;          //消息产生时间
@property (nonatomic, retain) NSNumber * uid;           //当前用户ID

@end
