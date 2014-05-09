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
<UIScrollViewDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong)UIImageView *customNavigationBar;
@property(nonatomic, strong)UIButton *menuButton;                       //菜单按钮

@property(nonatomic, strong)MKMapView       *mapView;                   //地图
@property(nonatomic, strong)UITapGestureRecognizer *tapGestureRecognizer;


@property(nonatomic, strong)UIScrollView    *dataScrollview;
@property(nonatomic, strong)SportDataView   *sportDataView;
@property(nonatomic, strong)SportDataView   *sportHistoryDataView;
@property(nonatomic, strong)SporterView     *sporterView;


@property(nonatomic, strong)UIButton *backButton;
@property(nonatomic, strong)UIButton *eyeButton;

@end
