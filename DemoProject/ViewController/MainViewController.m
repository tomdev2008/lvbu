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



@interface MainViewController ()

@property(nonatomic, strong)TestBLEAdapter *testBleAdapter;
@property(nonatomic, strong)HttpRequest *testHttp;

- (void)onLeftSwipe;
- (void)onRightSwipe;


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
    
    UIImageView *fullBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamedNoCache:@"MainView_background.png"]];
    fullBackgroundImageView.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:fullBackgroundImageView];
    
    AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
    
    
    //自定义导航栏
    CGRect navBarFrame = [adapt getCustomNavigationBarFrame];
    self.customNavigationBar = [UIFactory createImageViewWithRect:navBarFrame
                                                            image:nil];
    [self.customNavigationBar setUserInteractionEnabled:YES];
    [self.customNavigationBar setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.customNavigationBar];
    
    self.leftButton = [UIFactory createButtonWithRect:CGRectMake(4, 6, 32, 32)
                                               normal:@"MainView_home_n.png"
                                            highlight:@"MainView_home_c.png"
                                             selector:@selector(onLeft:)
                                               target:self];
    [self.customNavigationBar addSubview:self.leftButton];
    
    self.titleLabel = [UIFactory createLabelWith:CGRectMake(160 - 40, 0, 80, NavigationBarDefaultHeight)
                                            text:@"标题"
                                            font:[UIFont systemFontOfSize:18]
                                       textColor:[UIColor colorWithHex:@"#ffffff"]
                                 backgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setText:[UIFactory localized:@"ScaleView_title"]];
    [self.customNavigationBar addSubview:self.titleLabel];
    
    
    
    self.graphButton = [UIFactory createButtonWithRect:CGRectMake(284, 6, 32, 32)
                                               normal:@"MainView_graph_n.png"
                                            highlight:@"MainView_graph_c.png"
                                             selector:@selector(onGraph:)
                                               target:self];
    
    [self.graphButton setBackgroundColor:[UIColor redColor]];
    [self.graphButton setTitle:@"测试注册" forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.graphButton];
    
    
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(navBarFrame) -2 , 320, 2)];
    [lineImgView setImage:[UIImage imageNamedNoCache:@"MainView_navbar_separator.png"]];
    [self.customNavigationBar addSubview:lineImgView];
    

//
//    //背景view
//    CGRect backViewFrame = [adapt getBackgroundViewFrame];
//    
////    self.scaleView = [[ScaleView alloc] initWithFrame:backViewFrame];
////    [self.scaleView setBackgroundColor:[UIColor clearColor]];
////    [self.view addSubview:self.scaleView];
////    self.scaleView.weekdayView.delegate = self;
    

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



- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


    static dispatch_once_t once;
    dispatch_once( &once, ^{
        
        //显示状态栏以及导航栏，重置scrollview的frame
        [[UIApplication sharedApplication] setStatusBarHidden:NO];

        AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
        CGRect backViewFrame = [adapt getBackgroundViewFrame];
//        self.scaleView.frame = backViewFrame;

    });


}


- (void)onLeftSwipe
{

}

- (void)onRightSwipe
{

}

- (void)onGraph:(id)sender
{

    
    if (self.testHttp == nil) {
        
        self.testHttp = [[HttpRequest alloc] init];
        
        NSString *pwd = @"gogogo";
        NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
        [bodyParams setValue:@"zhouzhiqun@163.com" forKey:@"email"];
        [bodyParams setValue:[pwd MD5Sum] forKey:@"password"];
        
        self.testHttp.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_REGISTER];
        self.testHttp.bodyParams = bodyParams;
    }

    [self.testHttp sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
}

@end
