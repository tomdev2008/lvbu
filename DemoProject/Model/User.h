//
//  User.h
//  DemoProject
//
//  Created by zzc on 14-5-24.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


/**
 *  用户信息
 */


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatarurl;             //头像
@property (nonatomic, retain) NSString * birthday;              //生日19990808
@property (nonatomic, retain) NSNumber * height;                //身高厘米
@property (nonatomic, retain) NSNumber * sex;                   //性别，0男1女
@property (nonatomic, retain) NSString * nickname;              //昵称
@property (nonatomic, retain) NSNumber * uid;                   //用户ID
@property (nonatomic, retain) NSNumber * weight;                //体重0.1公斤
@property (nonatomic, retain) NSString * password;              //密码
@property (nonatomic, retain) NSString * regtime;               //注册时间, 19990808121212
@property (nonatomic, retain) NSString * bind_email;            //绑定邮箱
@property (nonatomic, retain) NSString * bind_handset;          //绑定手机
@property (nonatomic, retain) NSString * bind_qq;               //绑定QQ
@property (nonatomic, retain) NSString * bind_qqweibo;          //绑定微博
@property (nonatomic, retain) NSString * bind_sinaweibo;        //绑定新浪微博
@property (nonatomic, retain) NSString * bind_163;              //绑定163邮箱

@end
