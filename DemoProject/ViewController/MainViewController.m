//
//  MainViewController.m
//  DemoProject
//  侣步主界面
//  Created by Proint on 14-3-18.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "MainViewController.h"
#import "AppCore.h"
#import "ModelCollection.h"

#import "TestHttpRequest.h"

#import "BleMatchViewController.h"
#import "SportHistoryViewController.h"
#import "SportViewController.h"



@interface MainViewController ()

@property(nonatomic, strong)TestBLEAdapter *testBleAdapter;
@property(nonatomic, strong)HttpRequest *testHttp;

- (void)onBleScan:(id)sender;
- (void)onShowKm:(id)sender;
- (void)onShowCal:(id)sender;
- (void)onShowStep:(id)sender;
- (void)onFriend:(id)sender;
- (void)onNearby:(id)sender;

- (void)onLeftSwipe;
- (void)onRightSwipe;

- (void)annotationAction;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
//        self.testBleAdapter = [[TestBLEAdapter alloc] init];
//        
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(handleCentralManagerStatePoweredOn:)
//                                                     name:CentralManagerStatePoweredOnNotify
//                                                   object:nil];
//        
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(handleDidDiscoverPeripheral:)
//                                                     name:DidDiscoverPeripheralNotify
//                                                   object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(handleDidConnectPeripheralSuccess:)
//                                                     name:DidConnectPeripheralSuccessNotify
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(handleDidFailToConnectPeripheral:)
//                                                     name:DidFailToConnectPeripheralNotify
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(handleDidDisconnectPeripheral:)
//                                                     name:DidDisconnectPeripheralNotify
//                                                   object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(handleGetMacAddress:)
//                                                     name:GetMacAddressNotify
//                                                   object:nil];
        
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.navigationController setNavigationBarHidden:YES];

    AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
    
    //自定义导航栏
    CGRect navBarFrame = [adapt getCustomNavigationBarFrame];
    NSLog(@"navBarFrame = %@", NSStringFromCGRect(navBarFrame));
    
    self.customNavigationBar = [UIFactory createImageViewWithRect:navBarFrame image:nil];
    [self.customNavigationBar setUserInteractionEnabled:YES];
    [self.customNavigationBar setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:self.customNavigationBar];
    
    
    self.bleButton = [UIFactory createButtonWithRect:CGRectMake(4, 6, 60, 32)
                                               normal:@""
                                            highlight:@""
                                             selector:@selector(onBleScan:)
                                               target:self];
    
    [self.bleButton setBackgroundColor:[UIColor redColor]];
    [self.bleButton setTitle:@"蓝牙连接" forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.bleButton];
    


    //背景view
    CGRect backViewFrame = [adapt getBackgroundViewFrame];
    
    //初始化地图
    self.mapView = [[MKMapView alloc] initWithFrame:backViewFrame];
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    [self.view addSubview:self.mapView];

    
    //数据视图：千里，卡路里，步数
    self.kmDataView     = [ViewFactory createSportDataView];
    self.calDataView    = [ViewFactory createSportDataView];
    self.stepDataView   = [ViewFactory createSportDataView];
    
    [self.kmDataView setBackgroundColor:[UIColor clearColor]];
    [self.calDataView setBackgroundColor:[UIColor clearColor]];
    [self.stepDataView setBackgroundColor:[UIColor clearColor]];

    
    self.kmDataView.frame   = CGRectMake(107*0, backViewFrame.origin.y, 107, 80);
    self.calDataView.frame  = CGRectMake(107*1, backViewFrame.origin.y, 107, 80);
    self.stepDataView.frame = CGRectMake(107*2, backViewFrame.origin.y, 107, 80);
    
    [self.view addSubview:self.kmDataView];
    [self.view addSubview:self.calDataView];
    [self.view addSubview:self.stepDataView];
    
    
    [self.kmDataView.selectButton addTarget:self
                                     action:@selector(onShowKm:)
                           forControlEvents:UIControlEventTouchUpInside];
    
    [self.calDataView.selectButton addTarget:self
                                     action:@selector(onShowCal:)
                           forControlEvents:UIControlEventTouchUpInside];
    
    [self.stepDataView.selectButton addTarget:self
                                     action:@selector(onShowStep:)
                           forControlEvents:UIControlEventTouchUpInside];
    
    //人数视图：好友，附近
    self.friendSportView = [ViewFactory createSporterView];
    self.nearbySportView = [ViewFactory createSporterView];
    
    [self.friendSportView setBackgroundColor:[UIColor clearColor]];
    [self.nearbySportView setBackgroundColor:[UIColor clearColor]];

    self.friendSportView.frame  = CGRectMake(0, backViewFrame.origin.y + CGRectGetHeight(backViewFrame) - 60, 160, 60);
    self.nearbySportView.frame  = CGRectMake(160, backViewFrame.origin.y + CGRectGetHeight(backViewFrame) - 60, 160, 60);
    
    [self.view addSubview:self.friendSportView];
    [self.view addSubview:self.nearbySportView];
    
    [self.friendSportView.selectButton addTarget:self
                                      action:@selector(onFriend:)
                            forControlEvents:UIControlEventTouchUpInside];
    
    [self.nearbySportView.selectButton addTarget:self
                                       action:@selector(onNearby:)
                             forControlEvents:UIControlEventTouchUpInside];

    
    //手势：左扫，右扫
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(onLeftSwipe)];
    leftSwipeGesture.numberOfTouchesRequired = 1;
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(onRightSwipe)];
    rightSwipeGesture.numberOfTouchesRequired = 1;
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGesture];
    
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
        
        //重置数据视图
        self.kmDataView.frame   = CGRectMake(107*0, backViewFrame.origin.y, 107, 60);
        self.calDataView.frame  = CGRectMake(107*1, backViewFrame.origin.y, 107, 60);
        self.stepDataView.frame = CGRectMake(107*2, backViewFrame.origin.y, 107, 60);
        
        //重置人数视图
        self.friendSportView.frame  = CGRectMake(0, backViewFrame.origin.y + CGRectGetHeight(backViewFrame) - 60, 160, 60);
        self.nearbySportView.frame  = CGRectMake(160, backViewFrame.origin.y + CGRectGetHeight(backViewFrame) - 60, 160, 60);

    });
 
}


- (void)onAction
{
    NSLog(@"helloworld");
}

#pragma mark - private

- (void)onBleScan:(id)sender
{
    
    TestHttpRequest *testHttp = [[TestHttpRequest alloc] init];
    [testHttp testRegister];
    
    
//    TestHttpRequest *testHttp2= [[TestHttpRequest alloc] init];
//    [testHttp2 testLogin];
    
//    BleMatchViewController *bleMatchVC = [[BleMatchViewController alloc] init];
//    bleMatchVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:bleMatchVC animated:YES];
}


- (void)onShowKm:(id)sender
{
    NSLog(@"show KM");
    
    TestHttpRequest *testHttp = [[TestHttpRequest alloc] init];
    [testHttp testLogin];
    
//    SportHistoryViewController *sportHistoryVC = [[SportHistoryViewController alloc] init];
//    sportHistoryVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:sportHistoryVC animated:YES];
}

- (void)onShowCal:(id)sender
{
    NSLog(@"show CAL");
    
    TestHttpRequest *testHttp = [[TestHttpRequest alloc] init];
    [testHttp testModifyInfo];
    //[testHttp testModifyInfoByGet];

//    SportViewController *sportVC = [[SportViewController alloc] init];
//    sportVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:sportVC animated:YES];

}

- (void)onShowStep:(id)sender
{
    NSLog(@"show STEP");
    
    TestHttpRequest *testHttp = [[TestHttpRequest alloc] init];
    //[testHttp testModifyPassword];
    //[testHttp testCancelEye];
    //[testHttp testLogout];
    [testHttp testLogoutByGet];
}

- (void)onFriend:(id)sender
{
    NSLog(@"show Friend");
    
    TestHttpRequest *testHttp = [[TestHttpRequest alloc] init];
    [testHttp testEye];
}

- (void)onNearby:(id)sender
{
    NSLog(@"show Nearby");
    
    TestHttpRequest *testHttp = [[TestHttpRequest alloc] init];
    [testHttp testGetFans];
    
//   [self annotationAction];
    
}

- (void)onLeftSwipe
{
    NSLog(@"leftSwipe");
}

- (void)onRightSwipe
{
    NSLog(@"rightSwipe");
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
