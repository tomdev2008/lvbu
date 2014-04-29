//
//  LoginViewController.m
//  DemoProject
//
//  Created by zzc on 14-4-26.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "LoginViewController.h"
#import "AppCore.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
    [self.view setBackgroundColor:GlobalNavBarBgColor];
    AdaptiverServer *adapt = [AdaptiverServer sharedInstance];

    //自定义导航栏
    CGRect navBarFrame = [adapt getCustomNavigationBarFrame];
    self.customNavigationBar = [UIFactory createImageViewWithRect:navBarFrame
                                                            image:nil];
    [self.customNavigationBar setUserInteractionEnabled:YES];
    [self.customNavigationBar setBackgroundColor:GlobalNavBarBgColor];
    [self.view addSubview:self.customNavigationBar];
    
    
    //背景
    CGRect backgroundframe = [adapt getBackgroundViewFrame];
    self.backgroundView = [[UIView alloc] initWithFrame:backgroundframe];
    [self.backgroundView setBackgroundColor:RGBCOLOR(240, 240, 240)];
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
    CGRect userNameFrame = CGRectMake(40, 130, 236, 32);
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
    [self.userNameTextField setText:@"hello123@mkm.com"];
    [self.backgroundView addSubview:self.userNameTextField];
    
    
    //密码背景
    CGRect passwordFrame = CGRectMake(40, 130 + 52, 236, 32);
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
    [self.passwordTextField setText:@"hello123@mkm.com"];
    [self.backgroundView addSubview:self.passwordTextField];
    
    
    CGRect buttonFrame = CGRectMake(40, 220, 118, 40);
    self.loginButton = [UIFactory createButtonWithRect:buttonFrame
                                                 title:@"登录"
                                             titleFont:[UIFont systemFontOfSize:20]
                                            titleColor:[UIColor redColor]
                                                normal:@""
                                             highlight:@""
                                              selected:@""
                                              selector:@selector(onLogin)
                                                target:self];
    [self.backgroundView addSubview:self.loginButton];
    
    
    buttonFrame.origin.x += 127;
    self.regitsterButton = [UIFactory createButtonWithRect:buttonFrame
                                                     title:@"注册"
                                                 titleFont:[UIFont systemFontOfSize:20]
                                                titleColor:[UIColor redColor]
                                                    normal:@""
                                                 highlight:@""
                                                  selected:@""
                                                  selector:@selector(onRegister)
                                                    target:self];
    [self.backgroundView addSubview:self.regitsterButton];
    
    
    self.otherLoginLabel = [UIFactory createLabelWith:CGRectMake(45, 367, 200, 23)
                                                 text:@"其他登录方式"
                                                 font:[UIFont systemFontOfSize:16]
                                            textColor:[UIColor redColor]
                                      backgroundColor:[UIColor clearColor]];
    [self.backgroundView addSubview:self.otherLoginLabel];
    
    
    
    self.QQbutton = [UIFactory createButtonWithRect:CGRectMake(47, 410, 24, 24)
                                              title:@"Q"
                                          titleFont:[UIFont systemFontOfSize:16]
                                         titleColor:[UIColor redColor]
                                             normal:@""
                                          highlight:@""
                                           selected:@""
                                           selector:@selector(onQQLogin)
                                             target:self];
    [self.QQbutton setBackgroundColor:[UIColor blueColor]];
    [self.backgroundView addSubview:self.QQbutton];
    
    
    
    self.sinaButton = [UIFactory createButtonWithRect:CGRectMake(47 + 44, 410, 24, 24)
                                              title:@"微"
                                          titleFont:[UIFont systemFontOfSize:16]
                                         titleColor:[UIColor redColor]
                                             normal:@""
                                          highlight:@""
                                           selected:@""
                                           selector:@selector(onSinaLogin)
                                             target:self];
    [self.sinaButton setBackgroundColor:[UIColor blueColor]];
    [self.backgroundView addSubview:self.sinaButton];
    
    
    self.copyrightLabel = [UIFactory createLabelWith:CGRectMake(0, CGRectGetHeight(backgroundframe) - 36, 320, 20)
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


- (void)hideKeyboard
{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)onTap
{
    [self hideKeyboard];
}

- (void)onLogin
{
    [self hideKeyboard];
    NSString *userName = [self.userNameTextField.text trim];
    NSString *password = [self.passwordTextField.text trim];
    
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
            NSString *isFirstLaunch = [userDefault valueForKey:KEY_IsFirstLaunch];
            if (isFirstLaunch == nil /*|| ![isFirstLaunch isEqualToString:@"NO"]*/) {
                [userDefault setValue:@"NO" forKey:KEY_IsFirstLaunch];
            }
            
            [userDefault setValue:userName forKey:KEY_CurrentUserName];
            [userDefault setValue:password forKey:KEY_CurrentPassword];
            [userDefault setValue:[result valueForKey:@"scode"] forKey:KEY_GLOBAL_SESSIONCODE];
            [userDefault synchronize];
            
            [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } else {
            
            NSString *msg = [result valueForKey:@"msg"];
            [PRPAlertView showWithTitle:msg
                                message:nil
                            buttonTitle:@"确定"];
        }

    } Failure:^(NSError *err) {
        
        NSLog(@"error = %@", [err description]);
        [self reportNetworkError:err];
    }];
}

- (void)onRegister
{
    [self hideKeyboard];
    RegisterViewController *regVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:regVC animated:YES];
}
- (void)onQQLogin
{
    [self hideKeyboard];
}

- (void)onSinaLogin
{
    [self hideKeyboard];
}

@end
