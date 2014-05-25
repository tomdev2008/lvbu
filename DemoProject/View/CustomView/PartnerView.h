//
//  PartnerView.h
//  DemoProject
//
//  Created by zzc on 14-5-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewFactory.h"
#import "CellFactory.h"
#import "AppCore.h"

enum SportViewStatus {
    ViewStatus_SportView_noPartner = 0,   //没有跑伴
    ViewStatus_SportView_inviting,        //正在邀请中
    ViewStatus_SportView_simple,          //简单运动数据
    ViewStatus_SportView_detail,          //详细运动数据
};

@interface PartnerView : UIView
{
    NSInteger _curViewStatus;
}

@property(nonatomic, assign)NSInteger curViewStatus;

@property(nonatomic, weak)MKMapView *backMapView;   //用于转发触摸事件


//没有跑伴
@property(nonatomic, strong)UILabel *tipLabel;                              //当前没有人陪你跑步的提示语
@property(nonatomic, strong)SporterCountView *countView;                    //人数
@property(nonatomic, strong)SporterInfoView *sporter1InfoView;              //第一个运动者信息
@property(nonatomic, strong)SporterInfoView *sporter2InfoView;              //第二个运动者信息


//正在邀跑
@property(nonatomic, strong)PartnerCell *partnerCell;                       //正在邀跑的对象


//已经跑步中
@property(nonatomic, strong)ParterSportDataView *partnerSportDataView;      //跑伴运动数据
@property(nonatomic, strong)ParterSportDataView *mySportDataView;           //我的运动数据
@property(nonatomic, strong)UIView *lineView;                               //分割线


@property(nonatomic, strong)JSMessageTableView *msgTableView;               //消息列表

//没有跑步
- (void)updateViewByFriendCount:(NSInteger)friendCount
                    NearByCount:(NSInteger)nearbyCount
              RecommendRunerArr:(NSArray *)runerArr;

//正在约跑中
- (void)updateViewByPartnerInfo;

//已经跑步中
- (void)updateMySportData;
- (void)updatePartnerSportData;




@end
