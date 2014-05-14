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


@interface MainViewController: BaseViewController
<UIScrollViewDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate, IIViewDeckControllerDelegate>


@property(nonatomic, strong)UIView *mainView;                               //主视图
@property(nonatomic, strong)UIImageView *customNavigationBar;               //导航栏
@property(nonatomic, strong)UIButton    *menuButton;                        //菜单按钮

@property(nonatomic, strong)MKMapView       *mainMapView;                       //主视图中的地图
@property(nonatomic, strong)UITapGestureRecognizer *tapGestureRecognizer;       //手势，用于切换主,次视图


@property(nonatomic, strong)UIScrollView    *containerScrollview;               //运动数据视图容器
@property(nonatomic, strong)UISwipeGestureRecognizer *leftSwipeGesture;
@property(nonatomic, strong)UISwipeGestureRecognizer *rightSwipeGesture;

@property(nonatomic, strong)SportDataView   *todaySportDataView;                //今天运动数据
@property(nonatomic, strong)SportDataView   *historySportDataView;              //历史运动数据
@property(nonatomic, strong)SporterView     *sporterView;                       //运动人数，运动开始

@property(nonatomic, strong)UIView      *reverseView;                           //背面视图
@property(nonatomic, strong)MKMapView   *reverseMapView;                        //背面地图
@property(nonatomic, strong)UIButton    *backButton;                            //返回
@property(nonatomic, strong)UIButton    *eyeButton;                             //眼睛

@end
