//
//  SportViewController.h
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BaseViewController.h"
#import "SelfView.h"
#import "PartnerView.h"
#import "GroupView.h"

enum SPORTTYPE {
    SPORTTYPE_SELF = 1,
    SPORTTYPE_PARTNER,
    SPORTTYPE_GROUP,
};


@interface SportViewController : BaseViewController
<JSMessagesViewDataSource, JSMessagesViewDelegate,UIScrollViewDelegate,
MKMapViewDelegate, UIGestureRecognizerDelegate, IIViewDeckControllerDelegate>


@property(nonatomic, assign)NSInteger curViewStatus;                //当前显示哪个界面(自己，陪跑，群跑)
@property(nonatomic, assign)NSInteger curParterBodyViewStatus;      //当前陪跑界面状态

@property(nonatomic, strong)UIImageView *customNavigationBar;
@property(nonatomic, strong)UIButton *menuButton;

@property(nonatomic, strong)UIButton *selfButton;
@property(nonatomic, strong)UIButton *partnerButton;
@property(nonatomic, strong)UIButton *groupButton;

@property(nonatomic, strong)UIButton *stopPartButton;       //停止伴跑
@property(nonatomic, strong)UIButton *switchGroupButton;    //换群
@property(nonatomic, strong)UIButton *stopGroupButton;      //停止群跑


@property(nonatomic, strong)MKMapView *mainMapView;         //地图


@property(nonatomic, strong)SelfView    *selfBodyView;
@property(nonatomic, strong)PartnerView *partnerBodyView;
@property(nonatomic, strong)GroupView   *groupBodyView;


@end
