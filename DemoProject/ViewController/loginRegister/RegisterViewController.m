//
//  RegisterViewController.m
//  DemoProject
//
//  Created by zzc on 14-4-27.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
	// Do any additional setup after loading the view.
    
    
    
    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
    [self.navigationController setNavigationBarHidden:YES];
    
    //背景色
    [self.view setBackgroundColor:GlobalNavBarBgColor];
    AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
    
    
    //导航栏
    CGRect navBarFrame = [[AdaptiverServer sharedInstance] getCustomNavigationBarFrame];
    self.customNavigationBar = [[UIView alloc] initWithFrame:navBarFrame];
    [self.customNavigationBar setBackgroundColor:GlobalNavBarBgColor];
    [self.customNavigationBar setUserInteractionEnabled:YES];
    [self.view addSubview:self.customNavigationBar];
    
    
    //返回按钮
    self.backButton = [UIFactory createButtonWithRect:CGRectMake(0, 0, 60, NavigationBarDefaultHeight)
                                               normal:@""
                                            highlight:@""
                                             selector:@selector(onBack)
                                               target:self];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.backButton];
    
    
    //标题
    self.titleLabel = [UIFactory createLabelWith:CGRectMake(80, 0, 160, NavigationBarDefaultHeight)
                                            text:@"注册"
                                            font:[UIFont systemFontOfSize:18]
                                       textColor:[UIColor colorWithHex:@"0xffffff"]
                                 backgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.customNavigationBar addSubview:self.titleLabel];
    
    
    //背景view
    CGRect backViewFrame = [adapt getBackgroundViewFrame];
    self.backgroundView = [[UIView alloc] initWithFrame:backViewFrame];
    [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.backgroundView];
    
    

    //logo图片
    self.logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(38, 38, 48, 48)];
    [self.logoImgView setImage:[UIImage imageNamedNoCache:@""]];
    [self.logoImgView setBackgroundColor:[UIColor redColor]];
    [self.backgroundView addSubview:self.logoImgView];
    
    self.appNameLabel = [UIFactory createLabelWith:CGRectMake(90, 38, 100,30)
                                              text:@"侣步"
                                              font:[UIFont systemFontOfSize:18]
                                         textColor:[UIColor redColor]
                                   backgroundColor:[UIColor clearColor]];
    [self.backgroundView addSubview:self.appNameLabel];
    
    self.appEnNameLabel = [UIFactory createLabelWith:CGRectMake(90, 68, 100, 18)
                                                text:@"REALLYBE"
                                                font:[UIFont systemFontOfSize:18]
                                           textColor:[UIColor redColor]
                                     backgroundColor:[UIColor clearColor]];
    [self.backgroundView addSubview:self.appEnNameLabel];
    
    
    //用户名背景
    CGRect userNameFrame = CGRectMake(40, 140, 236, 32);
    self.userNameBgImgView = [[UIImageView alloc] initWithFrame: userNameFrame];
    [self.userNameBgImgView setImage:[UIImage imageNamedNoCache:@""]];
    [self.userNameBgImgView setBackgroundColor:[UIColor redColor]];
    [self.backgroundView addSubview:self.userNameBgImgView];
    
    self.userNameTextField = [UIFactory createTextFieldWithRect:userNameFrame
                                                   keyboardType:UIKeyboardTypeDefault
                                                         secure:NO
                                                    placeholder:@"邮箱/手机号码"
                                                           font:[UIFont systemFontOfSize:20]
                                                          color:[UIColor blueColor]
                                                       delegate:self];
    [self.userNameTextField setText:@"hello@mkm.com"];
    [self.backgroundView addSubview:self.userNameTextField];
    
    
    //密码背景
    CGRect passwordFrame = CGRectMake(40, 140 + 52, 236, 32);
    self.passwordBgImgView = [[UIImageView alloc] initWithFrame:passwordFrame];
    [self.passwordBgImgView setImage:[UIImage imageNamedNoCache:@""]];
    [self.passwordBgImgView setBackgroundColor:[UIColor redColor]];
    [self.backgroundView addSubview:self.passwordBgImgView];
    
    self.passwordTextField = [UIFactory createTextFieldWithRect:passwordFrame
                                                   keyboardType:UIKeyboardTypeDefault
                                                         secure:YES
                                                    placeholder:@"密码"
                                                           font:[UIFont systemFontOfSize:20]
                                                          color:[UIColor blueColor]
                                                       delegate:self];
    [self.passwordTextField setText:@"hello@mkm.com"];
    [self.backgroundView addSubview:self.passwordTextField];
    
    
    //密码背景
    CGRect confirmPwdFrame = CGRectMake(40, 140 + 52*2, 236, 32);
    self.confirmPwdBgImgView = [[UIImageView alloc] initWithFrame:confirmPwdFrame];
    [self.confirmPwdBgImgView setImage:[UIImage imageNamedNoCache:@""]];
    [self.confirmPwdBgImgView setBackgroundColor:[UIColor redColor]];
    [self.backgroundView addSubview:self.confirmPwdBgImgView];
    
    self.confirmPwdTextField = [UIFactory createTextFieldWithRect:confirmPwdFrame
                                                   keyboardType:UIKeyboardTypeDefault
                                                         secure:YES
                                                    placeholder:@"确认密码"
                                                           font:[UIFont systemFontOfSize:20]
                                                          color:[UIColor blueColor]
                                                       delegate:self];
    [self.confirmPwdTextField setText:@"hello@mkm.com"];
    [self.backgroundView addSubview:self.confirmPwdTextField];
    
    
    CGRect buttonFrame = CGRectMake(40, 310, 240, 40);
    self.doneButton = [UIFactory createButtonWithRect:buttonFrame
                                                 title:@"完成注册"
                                             titleFont:[UIFont systemFontOfSize:20]
                                            titleColor:[UIColor redColor]
                                                normal:@""
                                             highlight:@""
                                              selected:@""
                                              selector:@selector(onDone)
                                                target:self];
    [self.backgroundView addSubview:self.doneButton];
    
    
    
    self.copyrightLabel = [UIFactory createLabelWith:CGRectMake(0, CGRectGetHeight(backViewFrame) - 36, 320, 20)
                                                text:@"@2014 REALLYBE ALL rights reserved"
                                                font:[UIFont systemFontOfSize:14]
                                           textColor:[UIColor redColor]
                                     backgroundColor:[UIColor clearColor]];
    [self.copyrightLabel setTextAlignment:NSTextAlignmentCenter];
    [self.backgroundView addSubview:self.copyrightLabel];
    
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(onTap)];
    self.tapGestureRecognizer.delegate = self;
    [self.tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];

    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private

- (void)onTap
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPwdTextField resignFirstResponder];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onDone
{
    
//    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
//    [self.navigationController pushViewController:userInfoVC animated:YES];
//    return;

    
    [self hideKeyboard];
    NSString *userName = [self.userNameTextField.text trim];
    NSString *password = [self.passwordTextField.text trim];
    NSString *confirmPwd = [self.confirmPwdTextField.text trim];
    
    if ( userName == nil || [userName length] == 0) {
        [PRPAlertView showWithTitle:@"用户名为空，请重新输入"
                            message:nil
                        buttonTitle:@"确定"];
        
        return;
    }
    
    if (password == nil  || [password length] == 0) {
        [PRPAlertView showWithTitle:@"密码为空，请重新输入"
                            message:nil
                        buttonTitle:@"确定"];
        return;
    } else if ([password length] < 6) {
        [PRPAlertView showWithTitle:@"密码长度必须大于或等于6位"
                            message:nil
                        buttonTitle:@"确定"];
        return;
    }
    
    
    if (![password isEqualToString:confirmPwd]) {
        
        [PRPAlertView showWithTitle:@"密码前后输入不一致，请重新输入"
                            message:nil
                        buttonTitle:@"确定"];
        return;
    }
    
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:userName forKey:@"email"];
    [bodyParams setValue:[password MD5Sum] forKey:@"password"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_REGISTER];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        
        NSLog(@"Register.dic = %@", result);
        NSInteger ret = [[result valueForKey:@"ret"] integerValue];
        if (ret == 0) {
            
            //注册成功,登陆请求
            NSMutableDictionary *loginBodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
            [loginBodyParams setValue:userName forKey:@"email"];
            [loginBodyParams setValue:[password MD5Sum] forKey:@"password"];
            
            HttpRequest *httpReq = [[HttpRequest alloc] init];
            httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_LOGIN];
            httpReq.bodyParams = loginBodyParams;
            [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
                
                
                NSLog(@"login.dic = %@", result);
                NSInteger ret = [[result valueForKey:@"ret"] integerValue];
                if (ret == 0) {
                    //登陆成功, 保存用户信息
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                    NSString *isFirstLaunch = [userDefault valueForKey:KEY_IsFirstLaunch];
                    if (isFirstLaunch == nil /*|| ![isFirstLaunch isEqualToString:@"NO"]*/) {
                        [userDefault setValue:@"NO" forKey:KEY_IsFirstLaunch];
                    }
                    
                    [userDefault setValue:userName forKey:KEY_CurrentUserName];
                    [userDefault setValue:password forKey:KEY_CurrentPassword];
                    [userDefault setValue:[result valueForKey:@"scode"] forKey:KEY_GLOBAL_SESSIONCODE];
                    [userDefault synchronize];

                    //跳转到用户信息界面
                    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
                    [self.navigationController pushViewController:userInfoVC animated:YES];
                } else {
                    
                    //登陆失败
                    NSString *msg = [result valueForKey:@"msg"];
                    [PRPAlertView showWithTitle:msg
                                        message:nil
                                    buttonTitle:@"确定"];

                }

                
            } Failure:^(NSError *err) {

                //网络错误
                NSLog(@"error = %@", [err description]);
                [self reportNetworkError:err];
            }];
    
        } else {
            
            //注册失败
            NSString *msg = [result valueForKey:@"msg"];
            [PRPAlertView showWithTitle:msg
                                message:nil
                            buttonTitle:@"确定"];
        }
        
    } Failure:^(NSError *err) {
        
        //网络错误
        NSLog(@"error = %@", [err description]);
        [self reportNetworkError:err];
    }];
    
}

@end
