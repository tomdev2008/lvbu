//
//  UserMsg.h
//  LVBU
//
//  Created by _xLonG on 14-4-17.
//  Copyright (c) 2014年 PK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserMsg : NSObject
{
    NSMutableArray * userNameArrModel;
    NSMutableArray * passwordArrModel;
}
@property (nonatomic,copy) NSString * userid;
@property (nonatomic,copy) NSString * userscode;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString *pass;
@property (nonatomic,copy) NSString *confirmPassWord;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *birth;
@property (nonatomic,copy) NSString *height;
@property (nonatomic,copy) NSString *weight;
@property(nonatomic,strong)NSMutableArray * userNameArrModel;
@property(nonatomic,strong)NSMutableArray * passwordArrModel;
@end
