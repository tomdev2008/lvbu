//
//  SplashViewController.m
//  DemoProject
//
//  Created by zzc on 13-12-26.
//  Copyright (c) 2013年 zzc. All rights reserved.
//

#import "SplashViewController.h"
#import "AppCore.h"
#import "HttpRequest.h"


@interface SplashViewController ()

- (void)onStart;

@end

@implementation SplashViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        if (isIP5Screen) {
            self.splashImage = [UIImage imageNamed:@"Default-568h@2x.png"];
        } else {
            self.splashImage = [UIImage imageNamed:@"Default@2x.png"];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
}

- (void)loadView
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:self.splashImage];
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imgView.contentMode = UIViewContentModeScaleAspectFill; // UIViewContentModeCenter;
    self.view = imgView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    
    //测试用
    [self onStart];
    return;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefault valueForKey:KEY_CurrentUserName];
    NSString *password = [userDefault valueForKey:KEY_CurrentPassword];
    
//    userName = @"test";
//    password = @"test";
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:userName forKey:@"email"];
    [bodyParams setValue:[password MD5Sum] forKey:@"password"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_LOGIN];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        
        NSLog(@"login.dic = %@", result);
        NSInteger ret = [[result valueForKey:@"ret"] integerValue];
        if (ret == 0) {
            
            //登陆成功, 保存用户信息
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setValue:[result valueForKey:@"scode"] forKey:KEY_GLOBAL_SESSIONCODE];
            [userDefault synchronize];
            
            [self onStart];
            
        } else {
            
            [self toLogin];
            NSString *msg = [result valueForKey:@"msg"];
            [PRPAlertView showWithTitle:msg
                                message:nil
                            buttonTitle:@"确定"];
        }
        
    } Failure:^(NSError *err) {
        
        [self toLogin];
        NSLog(@"error = %@", [err description]);
        [self reportNetworkError:err];
    }];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private

- (void)onStart
{
    //动画初始化
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1.0f;          //动画时长
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = @"fade";           //过度效果
    //animation.subtype = @"formLeft";  //过渡方向
    animation.startProgress = 0.0;      //动画开始起点(在整体动画的百分比)
    animation.endProgress = 1.0;        //动画停止终点(在整体动画的百分比)
    animation.removedOnCompletion = NO;
    self.view.userInteractionEnabled = NO;
    [self.navigationController.view.layer addAnimation:animation forKey:@"animation"];
    
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    [self.navigationController popToRootViewControllerAnimated:NO];

}




- (void)toLogin
{
    //动画初始化
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1.0f;          //动画时长
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = @"fade";           //过度效果
    //animation.subtype = @"formLeft";  //过渡方向
    animation.startProgress = 0.0;      //动画开始起点(在整体动画的百分比)
    animation.endProgress = 1.0;        //动画停止终点(在整体动画的百分比)
    animation.removedOnCompletion = NO;
    self.view.userInteractionEnabled = NO;
    [self.navigationController.view.layer addAnimation:animation forKey:@"animation"];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:NO];
}

@end
