//
//  PartnerRelation.h
//  DemoProject
//
//  Created by zzc on 14-5-25.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>

enum RunningStatus {
    RunningStatus_NORUN = 0,            //没有运动
    RunningStatus_INVITEING,            //陪跑正在邀请
    RunningStatus_CANCEL,               //陪跑邀请被取消
    RunningStatus_REJECT,               //陪跑邀请被拒绝
    RunningStatus_ACCEPT,               //陪跑邀请被接受
    RunningStatus_TIMEOUT,              //陪跑等待超时
    RunningStatus_RUNING,               //陪跑运动中
    RunningStatus_FINISH,               //陪跑结束
    };

@interface PartnerRelation : NSObject

@property(nonatomic, assign)NSInteger partnerid;
@property(nonatomic, assign)NSInteger runStatus;

@end
