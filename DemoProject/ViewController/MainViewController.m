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

static double kRegionDistance = 500;

@interface MainViewController ()

@property(nonatomic, strong)HttpRequest *testHttp;

@property(nonatomic, strong)MyPoint *curMyPoint;
@property(nonatomic, assign)CLLocationCoordinate2D curLocation;


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

    //背景view
    CGRect mapFrame = [adapt getBackgroundViewFrameWithoutNavigationBar];
    
    //初始化地图
    self.mapView = [[MKMapView alloc] initWithFrame:mapFrame];
    [self.mapView setScrollEnabled:NO];
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    [self.view addSubview:self.mapView];
    

    self.backButton = [UIFactory createButtonWithRect:CGRectMake(15, 50, 43, 43)
                                               normal:@""
                                            highlight:@""
                                             selector:@selector(onBack)
                                               target:self];
    [self.backButton setBackgroundColor:[UIColor redColor]];
    [self.backButton setHidden:YES];
    [self.view addSubview:self.backButton];

    self.eyeButton = [UIFactory createButtonWithRect:CGRectMake(260, 50, 43, 43)
                                              normal:@""
                                           highlight:@""
                                            selector:@selector(onEye)
                                              target:self];
    [self.eyeButton setBackgroundColor:[UIColor redColor]];
    [self.eyeButton setHidden:YES];
    [self.view addSubview:self.eyeButton];
    
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
    


    
    CGRect backViewFrame = [adapt getBackgroundViewFrame];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(onTap)];
    self.tapGestureRecognizer.delegate = self;
    [self.tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self.mapView addGestureRecognizer:self.tapGestureRecognizer];


    CGRect sportDataFrame = CGRectMake(0, backViewFrame.origin.y, 320, 214);
    CGRect sporterFrame = CGRectMake(0, backViewFrame.origin.y + backViewFrame.size.height - 130, 320, 130);
    
    
    self.dataScrollview = [[UIScrollView alloc] initWithFrame:sportDataFrame];
    CGSize contentSize = sportDataFrame.size;
    contentSize.width += 320;
    [self.dataScrollview setContentSize:contentSize];
    [self.dataScrollview setUserInteractionEnabled:YES];
    [self.dataScrollview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.dataScrollview];
    
    //数据视图：千里，卡路里，步数
    sportDataFrame.origin.y = 0;
    self.sportDataView = [ViewFactory createSportDataView];
    [self.sportDataView setFrame:sportDataFrame];
    [self.sportDataView setBackgroundColor:[UIColor redColor]];
    [self.sportDataView.backgroundButton addTarget:self
                                            action:@selector(onSportData)
                                  forControlEvents:UIControlEventTouchUpInside];
    self.sportDataView.curViewStatus = DataViewStatus_NonSync;
    [self.dataScrollview addSubview:self.sportDataView];
    
    sportDataFrame.origin.x = 320;
    self.sportHistoryDataView = [ViewFactory createSportDataView];
    [self.sportHistoryDataView setFrame:sportDataFrame];
    [self.sportHistoryDataView setBackgroundColor:[UIColor whiteColor]];
    [self.sportHistoryDataView.backgroundButton addTarget:self
                                            action:@selector(onSportData)
                                  forControlEvents:UIControlEventTouchUpInside];
    self.sportDataView.curViewStatus = DataViewStatus_Sync;
    [self.dataScrollview addSubview:self.sportHistoryDataView];
    

    //人数视图：开始运动，好友，附近
    self.sporterView = [ViewFactory createSporterView];
    [self.sporterView setFrame:sporterFrame];
    [self.sporterView.peopleButton addTarget:self
                                      action:@selector(onPeople)
                            forControlEvents:UIControlEventTouchUpInside];

    [self.sporterView.sportButton addTarget:self
                                      action:@selector(onSport)
                            forControlEvents:UIControlEventTouchUpInside];
    
    self.sporterView.curViewStatus = ViewStatus_nonRequest;
    sporterFrame = CGRectMake(0, backViewFrame.origin.y + backViewFrame.size.height - 130, 130, 130);
    self.sporterView.frame = sporterFrame;
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
        CGRect mapFrame = [adapt getBackgroundViewFrameWithoutNavigationBar];
        self.mapView.frame = mapFrame;

         CGRect backViewFrame = [adapt getBackgroundViewFrame];
        //重置datascrollview的frame
        CGRect sportDataFrame = CGRectMake(0, backViewFrame.origin.y, 320, 214);
        self.dataScrollview.frame = sportDataFrame;
        
        
        //重置datascrollview的frame
        CGRect sporterFrame = CGRectMake(0, backViewFrame.origin.y + backViewFrame.size.height - 130, 320, 130);
        if (self.sporterView.curViewStatus == ViewStatus_nonRequest) {
            sporterFrame = CGRectMake(0, backViewFrame.origin.y + backViewFrame.size.height - 130, 130, 130);
        }
        self.sporterView.frame   = sporterFrame;

    });
 
}


#pragma mark - private

- (void)onMenu:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}



- (void)onTap
{
    [self.customNavigationBar setHidden:YES];
    [self.dataScrollview setHidden:YES];
    [self.sporterView setHidden:YES];
    [self.backButton setHidden:NO];
    [self.eyeButton setHidden:NO];

    [self.mapView removeGestureRecognizer:self.tapGestureRecognizer];
    [self.mapView setScrollEnabled:YES];
}


- (void)onBack
{
    [self.customNavigationBar setHidden:NO];
    [self.dataScrollview setHidden:NO];
    [self.sporterView setHidden:NO];
    [self.backButton setHidden:YES];
    [self.eyeButton setHidden:YES];

    [self.mapView addGestureRecognizer:self.tapGestureRecognizer];
    [self.mapView setScrollEnabled:YES];
}



- (void)onSportData
{

    self.sportDataView.curViewStatus = DataViewStatus_NonSync;
    return;

    SportHistoryViewController *sportHistoryVC = [[SportHistoryViewController alloc] init];
    [self.navigationController pushViewController:sportHistoryVC animated:YES];
}


- (void)onPeople
{
    self.sportDataView.curViewStatus = DataViewStatus_Sync;
    return;
    
    PartnerViewController *partnerVC = [[PartnerViewController alloc] init];
    [self.navigationController pushViewController:partnerVC animated:YES];
}

- (void)onSport
{
    //测试
//    AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
//    CGRect backViewFrame = [adapt getBackgroundViewFrame];
//    CGRect sporterFrame = CGRectMake(0, backViewFrame.origin.y + backViewFrame.size.height - 130, 320, 130);
    
    CGRect frame = self.sporterView.frame;
    frame.size = CGSizeMake(320, 130);
    self.sporterView.frame = frame;
    self.sporterView.curViewStatus = ViewStatus_Requested;
    return;
    
    SportViewController *sportVC = [[SportViewController alloc] init];
    [self.navigationController pushViewController:sportVC animated:YES];
}



- (void)onEye
{
    [self.mapView removeAnnotation:self.curMyPoint];
    
    //创建标题
    NSString *titile = @"我在这儿";
    self.curMyPoint = [[MyPoint alloc] initWithCoordinate:self.curLocation
                                                 andTitle:titile];
    [self.mapView addAnnotation:self.curMyPoint];
    
    //放大到标注的位置
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.curLocation, kRegionDistance, kRegionDistance);
    [self.mapView setRegion:region animated:YES];
}


#pragma mark - MKMapViewDelegate

//MapView委托方法，当定位自身时调用
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    
    CLLocationCoordinate2D loc = [userLocation coordinate];
    self.curLocation = loc;

    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, kRegionDistance, kRegionDistance);
    [self.mapView setRegion:region animated:YES];
}



@end
