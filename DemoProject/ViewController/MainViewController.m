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


@property(nonatomic, strong)NSMutableArray *myLocationArr;


@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.myLocationArr = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.viewDeckController.delegate = self;
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];

    [self.navigationController setNavigationBarHidden:YES];
    [self.view setBackgroundColor:GlobalNavBarBgColor];

    
    AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
    CGRect bodyFrame = [adapt getBackgroundViewFrameWithoutNavigationBar];
    
    /**************************主界面********************************************************/
    self.mainView = [[UIView alloc] initWithFrame:bodyFrame];
    [self.view addSubview:self.mainView];
    
    //主视图中的地图
    self.mainMapView = [[MKMapView alloc] initWithFrame:[self.mainView bounds]];
    [self.mainMapView setScrollEnabled:YES];
    [self.mainMapView setDelegate:self];
    [self.mainMapView setShowsUserLocation:YES];
    [self.mainView addSubview:self.mainMapView];
    
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(onTap)];
    self.tapGestureRecognizer.delegate = self;
    [self.tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self.mainMapView addGestureRecognizer:self.tapGestureRecognizer];
    
    
    //导航栏
    CGRect navBarFrame = CGRectMake(0, 0, 320, 44);
    self.customNavigationBar = [UIFactory createImageViewWithRect:navBarFrame image:nil];
    [self.customNavigationBar setUserInteractionEnabled:YES];
    [self.customNavigationBar setBackgroundColor:GlobalNavBarBgColor];
    [self.mainView addSubview:self.customNavigationBar];
    
    
    self.menuButton = [UIFactory createButtonWithRect:CGRectMake(8, 5, 40, 35)
                                               normal:@""
                                            highlight:@""
                                             selector:@selector(onMenu:)
                                               target:self];
    [self.menuButton setImage:[UIImage imageNamedNoCache:@"Global_menu.png"]
                     forState:UIControlStateNormal];
    [self.menuButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.customNavigationBar addSubview:self.menuButton];
    
    
    CGRect sportDataFrame = CGRectMake(0, 44, 320, 214);

    //今天运动数据，历史运动数据
    self.containerScrollview = [[UIScrollView alloc] initWithFrame:sportDataFrame];
    [self.containerScrollview setScrollEnabled:NO];
    CGSize contentSize = sportDataFrame.size;
    contentSize.width += 320;
    [self.containerScrollview setContentSize:contentSize];
    [self.containerScrollview setUserInteractionEnabled:YES];
    [self.containerScrollview setBackgroundColor:[UIColor whiteColor]];
    [self.mainView addSubview:self.containerScrollview];
    
    
    self.leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(onLeftSwipe)];
    self.leftSwipeGesture.numberOfTouchesRequired = 1;
    self.leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    self.rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(onRightSwipe)];
    self.rightSwipeGesture.numberOfTouchesRequired = 1;
    self.rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
//    [self.containerScrollview addGestureRecognizer:self.leftSwipeGesture];
//    [self.containerScrollview addGestureRecognizer:self.rightSwipeGesture];
    
    
    
    //今天运动数据视图：千里，卡路里，步数
    sportDataFrame.origin.y = 0;
    self.todaySportDataView = [ViewFactory createSportDataView];
    [self.todaySportDataView setFrame:sportDataFrame];
    [self.todaySportDataView setBackgroundColor:[UIColor redColor]];
    [self.todaySportDataView.backgroundButton addTarget:self
                                                 action:@selector(onSportData)
                                       forControlEvents:UIControlEventTouchUpInside];
    self.todaySportDataView.curViewStatus = DataViewStatus_NonSync;
    [self.containerScrollview addSubview:self.todaySportDataView];
    
    
    //历史运动数据视图：千里，卡路里，步数
    sportDataFrame.origin.x = 320;
    self.historySportDataView = [ViewFactory createSportDataView];
    [self.historySportDataView setFrame:sportDataFrame];
    [self.historySportDataView setBackgroundColor:[UIColor whiteColor]];
    [self.historySportDataView.backgroundButton addTarget:self
                                                   action:@selector(onSportData)
                                         forControlEvents:UIControlEventTouchUpInside];
    self.historySportDataView.curViewStatus = DataViewStatus_Sync;
    [self.containerScrollview addSubview:self.historySportDataView];
    
    
    //运动人数视图：开始运动，好友，附近
    CGRect sporterFrame = CGRectMake(0, CGRectGetHeight([self.mainView bounds]) - 130, 320, 130);
    self.sporterView = [ViewFactory createSporterView];
    [self.sporterView setFrame:sporterFrame];
    self.sporterView.curViewStatus = ViewStatus_Requested;
    [self.sporterView.peopleButton addTarget:self
                                      action:@selector(onPeople)
                            forControlEvents:UIControlEventTouchUpInside];
    
    [self.sporterView.sportButton addTarget:self
                                     action:@selector(onSport)
                           forControlEvents:UIControlEventTouchUpInside];
    
//    self.sporterView.curViewStatus = ViewStatus_nonRequest;
//    sporterFrame = CGRectMake(0, CGRectGetHeight([self.mainView bounds]) - 130, 130, 130);
//    self.sporterView.frame = sporterFrame;
    [self.sporterView setBackgroundColor:[UIColor whiteColor]];
    [self.mainView addSubview:self.sporterView];

    
    /**************************背面界面********************************************************/
    self.reverseView = [[UIView alloc] initWithFrame:bodyFrame];
    [self.view insertSubview:self.reverseView belowSubview:self.mainView];
    
    
    //背面地图
    self.reverseMapView = [[MKMapView alloc] initWithFrame:[self.reverseView bounds]];
//    [self.reverseMapView setScrollEnabled:NO];
//    [self.reverseMapView setDelegate:self];
//    [self.reverseMapView setShowsUserLocation:YES];
    [self.reverseView addSubview:self.reverseMapView];
    
    
    //返回
    self.backButton = [UIFactory createButtonWithRect:CGRectMake(15, 50, 43, 43)
                                               normal:@""
                                            highlight:@""
                                             selector:@selector(onBack)
                                               target:self];
    [self.backButton setBackgroundColor:[UIColor redColor]];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.reverseView addSubview:self.backButton];

    //眼睛
    self.eyeButton = [UIFactory createButtonWithRect:CGRectMake(260, 50, 43, 43)
                                              normal:@""
                                           highlight:@""
                                            selector:@selector(onEye)
                                              target:self];
    [self.eyeButton setBackgroundColor:[UIColor redColor]];
    [self.eyeButton setTitle:@"eye" forState:UIControlStateNormal];
    [self.reverseView addSubview:self.eyeButton];
    
    
    //开启定时器，每隔30s上报自己的GPS位置
    [NSTimer scheduledTimerWithTimeInterval:30
                                     target:self
                                   selector:@selector(updateMyLocation)
                                   userInfo:nil
                                    repeats:YES];
    
    
    
    
    //开启定时器，每隔120s获取正在运动的好友，以及附近的人
    [NSTimer scheduledTimerWithTimeInterval:121
                                     target:self
                                   selector:@selector(getSporter)
                                   userInfo:nil
                                    repeats:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //禁用viewDeckController的手势处理
    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
    
    [self.containerScrollview addGestureRecognizer:self.leftSwipeGesture];
    [self.containerScrollview addGestureRecognizer:self.rightSwipeGesture];

    
    static dispatch_once_t once;
    dispatch_once( &once, ^{
        
        //显示状态栏以及导航栏，重置scrollview的frame
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
        
        //重置frame
        CGRect bodyFrame = [adapt getBackgroundViewFrameWithoutNavigationBar];
        self.mainView.frame = bodyFrame;
        self.reverseView.frame = bodyFrame;

    });
 
}


#pragma mark - private

- (void)onMenu:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}



- (void)onTap
{
    //翻转视图
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    
    NSUInteger main     = [[self.view subviews] indexOfObject:self.mainView];
    NSUInteger reverse  = [[self.view subviews] indexOfObject:self.reverseView];
    [self.view exchangeSubviewAtIndex:main withSubviewAtIndex:reverse];
    [[self.view layer] addAnimation:animation forKey:@"animation"];
    
}


- (void)onBack
{
    //翻转视图
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    
    NSUInteger main     = [[self.view subviews] indexOfObject:self.mainView];
    NSUInteger reverse  = [[self.view subviews] indexOfObject:self.reverseView];
    [self.view exchangeSubviewAtIndex:reverse withSubviewAtIndex:main];
    [[self.view layer] addAnimation:animation forKey:@"animation"];
    
    
    
    if (self.curMyPoint) {
        [self.reverseMapView removeAnnotation:self.curMyPoint];
    }
    //当前位置
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.curLocation, kRegionDistance, kRegionDistance);
    [self.reverseMapView setRegion:region animated:YES];
}


- (void)onLeftSwipe
{
    [self.containerScrollview setContentOffset:CGPointMake(320, 0) animated:YES];
}

- (void)onRightSwipe
{
    [self.containerScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
}


- (void)onSportData
{
    //测试
    SportHistoryViewController *sportHistoryVC = [[SportHistoryViewController alloc] init];
    [self.navigationController pushViewController:sportHistoryVC animated:YES];
}


- (void)onPeople
{
    //测试
    PartnerViewController *partnerVC = [[PartnerViewController alloc] init];
    [self.navigationController pushViewController:partnerVC animated:YES];
}

- (void)onSport
{
    //测试
    SportViewController *sportVC = [[SportViewController alloc] init];
    [self.navigationController pushViewController:sportVC animated:YES];
}



- (void)onEye
{
    [self.reverseMapView removeAnnotation:self.curMyPoint];
    
    //创建标题
    NSString *titile = @"我在这儿";
    self.curMyPoint = [[MyPoint alloc] initWithCoordinate:self.curLocation
                                                 andTitle:titile];
    [self.reverseMapView addAnnotation:self.curMyPoint];
    
    //放大到标注的位置
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.curLocation, kRegionDistance, kRegionDistance);
    [self.reverseMapView setRegion:region animated:YES];
}


- (void)updateMyLocation
{

    NSMutableArray *gpsArr = nil;
    if ([self.myLocationArr count] < 6) {
        return;
    }
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    
    gpsArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [self.myLocationArr count]; ++i) {
        NSMutableDictionary *locDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        MKUserLocation *userLocation = [self.myLocationArr objectAtIndex:i];
        CLLocationCoordinate2D loc = [userLocation coordinate];
        [locDic setValue:[NSNumber numberWithFloat:loc.longitude] forKey:@"longitude"];
        [locDic setValue:[NSNumber numberWithFloat:loc.latitude] forKey:@"latitude"];
        
        [gpsArr addObject:locDic];
    }
    
    
    [bodyParams setValue:gpsArr forKey:@"gps"];
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_GPSUPDATE];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
}


- (void)getSporter
{
    
    //请求正在运动的好友人数以及附近的人
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    NSMutableDictionary *gpsDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [gpsDic setValue:[NSNumber numberWithFloat:self.curLocation.latitude] forKey:@"latitude"];
    [gpsDic setValue:[NSNumber numberWithFloat:self.curLocation.longitude] forKey:@"longitude"];
    [bodyParams setValue:gpsDic forKey:@"gps"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_GETFANS];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
        NSLog(@"testGetFans.msg = %@", [result valueForKey:@"msg"]);
        NSInteger ret = [[result valueForKey:@"ret"] integerValue];
        if (ret == 0) {

            //请求成功
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CGRect frame = self.sporterView.frame;
                frame.size = CGSizeMake(320, 130);
                self.sporterView.frame = frame;
                [self.sporterView updateViewWithParter:10 Nearby:20];
                self.sporterView.curViewStatus = ViewStatus_Requested;
            });
        }
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];

}


#pragma mark IIViewDeckControllerDelegate

- (void)viewDeckController:(IIViewDeckController*)viewDeckController willOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    //禁止dataScrollview手势处理， 开始viewDeckController手势处理
    [self.containerScrollview removeGestureRecognizer:self.leftSwipeGesture];
    [self.containerScrollview removeGestureRecognizer:self.rightSwipeGesture];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
}


- (void)viewDeckController:(IIViewDeckController*)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    //开始dataScrollview手势处理， 禁止viewDeckController手势处理
    [self.containerScrollview addGestureRecognizer:self.leftSwipeGesture];
    [self.containerScrollview addGestureRecognizer:self.rightSwipeGesture];
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
}


#pragma mark - MKMapViewDelegate

//MapView委托方法，当定位自身时调用
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    
    CLLocationCoordinate2D loc = [userLocation coordinate];
    if (loc.latitude > 0 && loc.longitude > 0 ) {
        
        
        if (mapView == self.mainMapView) {
            self.curLocation = loc;
            
            //如果GPS采样超过6个，则删除第一个，并添加当前位置到数组末尾
            if ([self.myLocationArr count] >= 6) {
                [self.myLocationArr removeObjectAtIndex:0];
            }
            
            MKUserLocation *userLocation = [[MKUserLocation alloc] init];
            userLocation.coordinate = loc;
            [self.myLocationArr addObject:userLocation];
            
        }

        //放大地图到自身的经纬度位置。
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, kRegionDistance, kRegionDistance);
        [self.mainMapView setRegion:region animated:YES];
        
    }
}



@end
