//
//  MainViewController.h
//  DemoProject
//
//  Created by Proint on 14-3-18.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BaseViewController.h"
#import "AppCore.h"
#import "ViewFactory.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>




@interface MainViewController: BaseViewController<UIScrollViewDelegate, MKMapViewDelegate>

@property(nonatomic, strong)UIImageView *customNavigationBar;
@property(nonatomic, strong)UIButton *menuButton;                       //菜单按钮
@property(nonatomic, strong)UIButton *bleButton;                        //蓝牙连接

@property(nonatomic, strong)MKMapView *mapView;                         //地图
@property(nonatomic, strong)SportDataView *kmDataView;                  //公里
@property(nonatomic, strong)SportDataView *calDataView;                 //卡路里
@property(nonatomic, strong)SportDataView *stepDataView;                //公里

@property(nonatomic, strong)SporterView *friendSportView;               //正在运动的好友
@property(nonatomic, strong)SporterView *nearbySportView;               //附近正在运动的人
@property(nonatomic, strong)UIButton    *startButton;                   //开始运动


@end
