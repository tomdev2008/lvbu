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

#import "BleMatchViewController.h"
#import "SportHistoryViewController.h"
#import "SportViewController.h"

static double kRegionDistance = 500;

@interface MainViewController ()


@property(nonatomic, strong)MyPoint *curMyPoint;
@property(nonatomic, assign)MKUserLocation *curLocation;
@property(nonatomic, strong)NSDateFormatter *formatter;


@property(nonatomic, strong)NSMutableArray *myLocationArr;


@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.myLocationArr = [[NSMutableArray alloc] initWithCapacity:0];
        
        self.formatter = [[NSDateFormatter alloc] init];
        [self.formatter setDateFormat:@"yyyy-MM-dd"];
        
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
    [self.todaySportDataView.backgroundButton addTarget:self
                                                 action:@selector(onSportData)
                                       forControlEvents:UIControlEventTouchUpInside];
    [self.todaySportDataView.dataViewTitleLabel setText:@"当天运动记录"];
    self.todaySportDataView.curViewStatus = DataViewStatus_NonSync;
    [self.containerScrollview addSubview:self.todaySportDataView];
    
    
    //历史运动数据视图：千里，卡路里，步数
    sportDataFrame.origin.x = 320;
    self.historySportDataView = [ViewFactory createSportDataView];
    [self.historySportDataView setFrame:sportDataFrame];
    [self.historySportDataView.backgroundButton addTarget:self
                                                   action:@selector(onSportData)
                                         forControlEvents:UIControlEventTouchUpInside];
    [self.historySportDataView.dataViewTitleLabel setText:@"历史运动记录"];
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
    
    //重置frame
    self.sporterView.curViewStatus = ViewStatus_nonRequest;
    sporterFrame = CGRectMake(0, CGRectGetHeight([self.mainView bounds]) - 130, 130, 130);
    self.sporterView.frame = sporterFrame;
    [self.sporterView setBackgroundColor:[UIColor whiteColor]];
    [self.mainView addSubview:self.sporterView];

    
    /**************************背面界面********************************************************/
    //self.reverseView = [[UIView alloc] initWithFrame:bodyFrame];
    self.reverseView = [[UIView alloc] initWithFrame:[self.view bounds]];
    [self.view insertSubview:self.reverseView belowSubview:self.mainView];
    [self.reverseView setHidden:YES];
    
    
    
    //背面地图
    self.reverseMapView = [[MKMapView alloc] initWithFrame:[self.reverseView bounds]];
//    [self.reverseMapView setScrollEnabled:NO];
//    [self.reverseMapView setDelegate:self];
//    [self.reverseMapView setShowsUserLocation:YES];
    [self.reverseView addSubview:self.reverseMapView];
    
    
    //返回
    self.backButton = [UIFactory createButtonWithRect:CGRectMake(15, 50, 40, 40)
                                               normal:@"Lvbu_map_back_n.png"
                                            highlight:@"Lvbu_map_back_c.png"
                                             selector:@selector(onBack)
                                               target:self];
//    [self.backButton setBackgroundColor:[UIColor redColor]];
//    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.reverseView addSubview:self.backButton];

    //眼睛
    self.eyeButton = [UIFactory createButtonWithRect:CGRectMake(260, 50, 40, 40)
                                              normal:@"Lvbu_map_location_n.png"
                                           highlight:@"Lvbu_map_location_c.png"
                                            selector:@selector(onEye)
                                              target:self];
//    [self.eyeButton setBackgroundColor:[UIColor redColor]];
//    [self.eyeButton setTitle:@"eye" forState:UIControlStateNormal];
    [self.reverseView addSubview:self.eyeButton];
    
    
    //开启定时器，每隔30s上报自己的GPS位置
    [NSTimer scheduledTimerWithTimeInterval:30
                                     target:self
                                   selector:@selector(updateMyLocation)
                                   userInfo:nil
                                    repeats:YES];
    
    
    
    
    //开启定时器，每隔15s获取正在运动的好友，以及附近的人
    [NSTimer scheduledTimerWithTimeInterval:15
                                     target:self
                                   selector:@selector(getSporterCount)
                                   userInfo:nil
                                    repeats:YES];
    
    //获取人数，今天的运动记录，历史的运动总和
    [self getSporterCount];
    [self getTodaySportData];
    [self getHistorySportData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //禁用viewDeckController的手势处理
    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
    
    [self.containerScrollview addGestureRecognizer:self.leftSwipeGesture];
    [self.containerScrollview addGestureRecognizer:self.rightSwipeGesture];

    
//    static dispatch_once_t once;
//    dispatch_once( &once, ^{
//        
//        //显示状态栏以及导航栏，重置scrollview的frame
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//        AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
//        
//        //重置frame
//        CGRect bodyFrame = [adapt getBackgroundViewFrameWithoutNavigationBar];
//        self.mainView.frame = bodyFrame;
//        //self.reverseView.frame = bodyFrame;
//        self.reverseView.frame = [self.view bounds];
//
//    });
    
    
    
    
    
    //优化代码
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
    
    CGRect bodyFrame = [adapt getBackgroundViewFrameWithoutNavigationBar];
    self.mainView.frame = bodyFrame;
    
    if (self.mainMapView == nil) {
        
        //主视图中的地图
        self.mainMapView = [[MKMapView alloc] initWithFrame:bodyFrame];
        [self.mainMapView setScrollEnabled:YES];
        [self.mainMapView setDelegate:self];
        [self.mainMapView setShowsUserLocation:YES];
        [self.mainMapView addGestureRecognizer:self.tapGestureRecognizer];
        [self.mainView insertSubview:self.mainMapView atIndex:0];
    } else {
        self.mainMapView.frame = bodyFrame;
    }
    
    bodyFrame = [self.view bounds];
    self.reverseView.frame = bodyFrame;
    if (self.reverseMapView == nil) {
        self.reverseMapView = [[MKMapView alloc] initWithFrame:bodyFrame];
        [self.reverseMapView setScrollEnabled:YES];
        [self.reverseMapView setDelegate:self];
        [self.reverseMapView setShowsUserLocation:YES];
        [self.reverseView insertSubview:self.reverseMapView atIndex:0];
    } else {
        self.reverseMapView.frame = bodyFrame;
    }
    
    
}


#pragma mark - private

- (void)onMenu:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}



- (void)onTap
{
    //翻转视图
    
    [self.reverseView setHidden:NO];
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = .7;
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
    
    [self.reverseView setHidden:YES];
    
    if (self.curMyPoint) {
        [self.reverseMapView removeAnnotation:self.curMyPoint];
    }
    //当前位置
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([self.curLocation coordinate], kRegionDistance, kRegionDistance);
    [self.mainMapView setRegion:region animated:YES];

}


- (void)onLeftSwipe
{
    //左滑
    [self.containerScrollview setContentOffset:CGPointMake(320, 0) animated:YES];
}

- (void)onRightSwipe
{
    //右滑
    [self.containerScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
}


- (void)onSportData
{
    //点击运动数据区域，进入运动历史界面
    
    SportHistoryViewController *sportHistoryVC = [[SportHistoryViewController alloc] init];
    [self.navigationController pushViewController:sportHistoryVC animated:YES];
}


- (void)onPeople
{
    //点击正在运动的好友或者附近正在运动的人，进入陪伴界面
    PartnerViewController *partnerVC = [[PartnerViewController alloc] init];
    [self.navigationController pushViewController:partnerVC animated:YES];
}

- (void)onSport
{
    
    //开始运动
    [[CommonVariable shareCommonVariable] setIsRunning:YES];
    kAppDelegate.sportVC = [[SportViewController alloc] init];
    
    //初始化运动界面显示哪个子界面(自己，伴跑还是群跑)
    //初始化当前伴跑界面显示哪种样式(无邀跑对象，正在邀跑, 陪跑中简单运动数据， 陪跑中运动数据详情)
    kAppDelegate.sportVC.curViewStatus = SPORTTYPE_SELF;
    kAppDelegate.sportVC.curParterBodyViewStatus = ViewStatus_SportView_noPartner;
    [self.navigationController pushViewController:kAppDelegate.sportVC animated:YES];
    
    
    //优化代码
    [self.mainMapView removeFromSuperview];
    [self.reverseMapView removeFromSuperview];
    self.mainMapView.delegate = nil;
    self.reverseMapView.delegate = nil;
    self.mainMapView = nil;
    self.reverseMapView = nil;
    
}



- (void)onEye
{
    [self.reverseMapView removeAnnotation:self.curMyPoint];
    
    //创建标题
    NSString *titile = @"我在这儿";
    
    CLLocationCoordinate2D loc = [self.curLocation coordinate];
    self.curMyPoint = [[MyPoint alloc] initWithCoordinate:loc
                                                 andTitle:titile];
    [self.reverseMapView addAnnotation:self.curMyPoint];
    
    //放大到标注的位置
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, kRegionDistance, kRegionDistance);
    [self.reverseMapView setRegion:region animated:YES];
}



- (void)updateMyLocation
{
    //定时更新当前GPS位置
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
        
        CLLocation *loc = userLocation.location;
        CLLocationCoordinate2D coordinate = [userLocation coordinate];
        [locDic setValue:[NSNumber numberWithFloat:coordinate.longitude] forKey:@"j"];
        [locDic setValue:[NSNumber numberWithFloat:coordinate.latitude] forKey:@"w"];
        [locDic setValue:[NSNumber numberWithFloat:loc.altitude] forKey:@"h"];
        [locDic setValue:[NSNumber numberWithLong:[loc.timestamp timeIntervalSince1970]] forKey:@"t"];
    
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


- (void)getSporterCount
{
    
    //请求正在运动的好友人数以及附近的人
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    
//    NSMutableDictionary *gpsDic = [[NSMutableDictionary alloc] initWithCapacity:0];
//    MKUserLocation *userLocation = self.curLocation;
//    
//    CLLocation *loc = userLocation.location;
//    CLLocationCoordinate2D coordinate = [userLocation coordinate];
//    [gpsDic setValue:[NSNumber numberWithFloat:coordinate.longitude] forKey:@"j"];
//    [gpsDic setValue:[NSNumber numberWithFloat:coordinate.latitude] forKey:@"w"];
//    [gpsDic setValue:[NSNumber numberWithFloat:loc.altitude] forKey:@"h"];
//    [gpsDic setValue:[NSNumber numberWithLong:[loc.timestamp timeIntervalSince1970]] forKey:@"t"];
//    [bodyParams setValue:gpsDic forKey:@"gps"];
    

    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_RECOMMEND];
    httpReq.bodyParams = bodyParams;
    
    NSLog(@"recommend.url = %@", httpReq.url);
    NSLog(@"httpReq.bodyParams = %@", httpReq.bodyParams);
    
    
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        
        NSLog(@"result = %@", result);
        NSInteger ret = [[result valueForKey:@"ret"] integerValue];
        if (ret == 0) {

            NSInteger friendCount = [[result valueForKey:@"friends_count"] integerValue];
            NSInteger nearbyCount = [[result valueForKey:@"user_count"] integerValue];
            
            //请求成功
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //更新附近的人
                CGRect frame = self.sporterView.frame;
                frame.size = CGSizeMake(320, 130);
                self.sporterView.frame = frame;
                [self.sporterView updateViewWithParter:friendCount Nearby:nearbyCount];
                self.sporterView.curViewStatus = ViewStatus_Requested;
                
            });
        }
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];

}



- (void)getTodaySportData
{
    
    //请求今天运动数据
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];


    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_SPORT_HISTORY];
    httpReq.bodyParams = bodyParams;
    
    
    NSLog(@"sportHistory.url = %@", httpReq.url);
    NSLog(@"sportHistory.body = %@", httpReq.bodyParams);

    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        
        NSLog(@"result = %@", result);
        NSInteger ret = [[result valueForKey:@"ret"] integerValue];
        NSLog(@"getTodaySportData.msg = %@", [result valueForKey:@"msg"]);
        if (ret == 0) {

            //解析数据
            NSArray *historyArr = [result valueForKey:@"sport_list"];
            if ((historyArr != nil) && [historyArr count] > 0) {

                NSDictionary *dic = [historyArr objectAtIndex:0];
                NSString *day = [dic valueForKey:@"day"];
                
                NSDate *today = [NSDate date];
                NSString *todayStr = [self.formatter stringFromDate:today];
                if ([todayStr isEqualToString:day]) {
                    
                    //是今天的数据
                    NSInteger steps = [[dic valueForKey:@"steps"] integerValue];            //步数
                    NSInteger dist  = [[dic valueForKey:@"dist"] integerValue];             //距离
                    NSInteger cal   = [[dic valueForKey:@"cal"] integerValue];              //大卡
                    NSInteger count = [[dic valueForKey:@"count"] integerValue];            //次数
                    NSInteger timelength = [[dic valueForKey:@"timelength"] integerValue];  //时长
                    
                    //更新UI
                    dispatch_async(dispatch_get_main_queue(), ^{

                        //更新今天运动历数据
                        [self.todaySportDataView updateViewWithKM:[NSString stringWithFormat:@"%.2f", dist/1000.0]
                                                              Cal:[NSString stringWithFormat:@"%d", cal]
                                                              Min:[NSString stringWithFormat:@"%02d:%02d", timelength/3600, timelength/60%60]
                                                            Times:[NSString stringWithFormat:@"%d", count]
                                                             Step:[NSString stringWithFormat:@"%d", steps]];
                        
                    });
                    
                }
              
                

            }
            

        } else {
            [PRPAlertView showWithTitle:@"请求失败"
                                message:[result valueForKey:@"msg"]
                            buttonTitle:@"确定"];
        }
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
        
    }];
    
}

- (void)getHistorySportData
{
    //请求历史运动数据
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_CurrentUserid] forKey:@"uid"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_SPORT_SUM];
    httpReq.bodyParams = bodyParams;
    
    NSLog(@"getHistorySportData.url = %@", httpReq.url);
    NSLog(@"getHistorySportData.body = %@", httpReq.bodyParams);
    
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        
        NSLog(@"result = %@", result);
        NSLog(@"getHistorySportData.msg = %@", [result valueForKey:@"msg"]);
        
        NSInteger ret = [[result valueForKey:@"ret"] integerValue];
        if (ret == 0) {
            
            //请求成功
            NSDictionary *sportSum = [result valueForKey:@"sport_sum"];
            
            //距离(米)，步数，天数，时长(秒)，次数
            NSInteger distance  = [[sportSum valueForKey:@"sport_distance"] integerValue];
            NSInteger steps     = [[sportSum valueForKey:@"sport_steps"] integerValue];
            NSInteger days      = [[sportSum valueForKey:@"sport_days"] integerValue];
            NSInteger time      = [[sportSum valueForKey:@"sport_time"] integerValue];
            NSInteger count     = [[sportSum valueForKey:@"sport_count"] integerValue];
            NSInteger cal       = 1000;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            
                [self.historySportDataView updateViewWithKM:[NSString stringWithFormat:@"%.2f", distance/1000.0]
                                                      Cal:[NSString stringWithFormat:@"%d", cal]
                                                      Min:[NSString stringWithFormat:@"%02d:%02d", time/3600, time/60%60]
                                                    Times:[NSString stringWithFormat:@"%d", count]
                                                     Step:[NSString stringWithFormat:@"%d", steps]];
                
            });
        } else {
            [PRPAlertView showWithTitle:@"请求失败"
                                message:[result valueForKey:@"msg"]
                            buttonTitle:@"确定"];
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
            
            MKUserLocation *curUserLocation = [userLocation copy];
            self.curLocation = curUserLocation;
            
            //如果GPS采样超过6个，则删除第一个，并添加当前位置到数组末尾
            if ([self.myLocationArr count] >= 6) {
                [self.myLocationArr removeObjectAtIndex:0];
            }
            [self.myLocationArr addObject:curUserLocation];
            
        }

        //放大地图到自身的经纬度位置。
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, kRegionDistance, kRegionDistance);
        [self.mainMapView setRegion:region animated:YES];
        
    }
}



@end
