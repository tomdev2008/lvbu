//
//  MainViewController.m
//  DemoProject
//  侣步主界面
//  Created by Proint on 14-3-18.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "MainViewController.h"
#import "AppCore.h"
#import "AppDelegate.h"
#import "ModelCollection.h"

#import "TestHttpRequest.h"

#import "BleMatchViewController.h"
#import "SportHistoryViewController.h"
#import "SportViewController.h"



@interface MainViewController ()

@property(nonatomic, strong)TestBLEAdapter *testBleAdapter;
@property(nonatomic, strong)HttpRequest *testHttp;

- (void)annotationAction;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.navigationController setNavigationBarHidden:YES];
    [self.view setBackgroundColor:GlobalNavBarBgColor];

    AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
    
    //自定义导航栏
    CGRect navBarFrame = [adapt getCustomNavigationBarFrame];
    self.customNavigationBar = [UIFactory createImageViewWithRect:navBarFrame image:nil];
    [self.customNavigationBar setUserInteractionEnabled:YES];
    [self.customNavigationBar setBackgroundColor:GlobalNavBarBgColor];
    [self.view addSubview:self.customNavigationBar];
    
    
    self.menuButton = [UIFactory createButtonWithRect:CGRectMake(8, 5, 40, 35)
                                               normal:@""
                                            highlight:@""
                                             selector:@selector(onMenu:)
                                               target:self];
    [self.menuButton setImage:[UIImage imageNamedNoCache:@"Global_menu.png"]
                     forState:UIControlStateNormal];
    [self.menuButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.customNavigationBar addSubview:self.menuButton];
    

    //背景view
    CGRect backViewFrame = [adapt getBackgroundViewFrame];
    
    //初始化地图
    self.mapView = [[MKMapView alloc] initWithFrame:backViewFrame];
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    [self.view addSubview:self.mapView];

    
    //数据视图：千里，卡路里，步数
    CGRect sportDataFrame = CGRectMake(0, backViewFrame.origin.y, 320, 214);
    CGRect sporterFrame = CGRectMake(0, backViewFrame.origin.y + backViewFrame.size.height - 140, 320, 140);
    
    self.sportDataView = [ViewFactory createSportDataView];
    [self.sportDataView setFrame:sportDataFrame];
    [self.sportDataView setBackgroundColor:[UIColor whiteColor]];
    [self.sportDataView.backgroundButton addTarget:self
                                            action:@selector(onSportData)
                                  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sportDataView];

    //人数视图：好友，附近
    self.sporterView = [ViewFactory createSporterView];
    [self.sporterView setFrame:sporterFrame];
    [self.sporterView.peopleButton addTarget:self
                                      action:@selector(onPeople)
                            forControlEvents:UIControlEventTouchUpInside];

    [self.sporterView.sportButton addTarget:self
                                      action:@selector(onSport)
                            forControlEvents:UIControlEventTouchUpInside];
    
    [self.sporterView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.sporterView];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


    static dispatch_once_t once;
    dispatch_once( &once, ^{
        
        //显示状态栏以及导航栏，重置scrollview的frame
        [[UIApplication sharedApplication] setStatusBarHidden:NO];

        AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
        
        //重置自定义navigationBar的frame
        CGRect navBarFrame = [adapt getCustomNavigationBarFrame];
        self.customNavigationBar.frame = navBarFrame;
        
        //重置地图的frame
        CGRect backViewFrame = [adapt getBackgroundViewFrame];
        self.mapView.frame = backViewFrame;

        CGRect sportDataFrame = CGRectMake(0, backViewFrame.origin.y, 320, 214);
        CGRect sporterFrame = CGRectMake(0, backViewFrame.origin.y + backViewFrame.size.height - 140, 320, 140);
        self.sportDataView.frame = sportDataFrame;
        self.sporterView.frame   = sporterFrame;

    });
 
}


#pragma mark - private

- (void)onMenu:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}


- (void)onSportData
{
    SportHistoryViewController *sportHistoryVC = [[SportHistoryViewController alloc] init];
    [self.navigationController pushViewController:sportHistoryVC animated:YES];
}


- (void)onPeople
{
    PartnerViewController *partnerVC = [[PartnerViewController alloc] init];
    [self.navigationController pushViewController:partnerVC animated:YES];
}

- (void)onSport
{
    
}


//放置标注
- (void)annotationAction {
    //创建CLLocation 设置经纬度
    
    NSString *longitude = @"121.49656";
    NSString *latitude  = @"31.21842";
    
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
    CLLocationCoordinate2D coord = [loc coordinate];
    //创建标题
    NSString *titile = [NSString stringWithFormat:@"%f,%f",coord.latitude,coord.longitude];
    MyPoint *myPoint = [[MyPoint alloc] initWithCoordinate:coord andTitle:titile];
    //添加标注
    [self.mapView addAnnotation:myPoint];
    
    //放大到标注的位置
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    [self.mapView setRegion:region animated:YES];
}



#pragma mark - MKMapViewDelegate

//MapView委托方法，当定位自身时调用
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    CLLocationCoordinate2D loc = [userLocation coordinate];

    //经度
    NSString *longitude = [NSString stringWithFormat:@"%f",loc.longitude];
    
    //纬度
    NSString *latitude  = [NSString stringWithFormat:@"%f",loc.latitude];
    
    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [self.mapView setRegion:region animated:YES];
}



@end
