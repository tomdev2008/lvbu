//
//  ModifyPwdViewController.m
//  DemoProject
//
//  Created by zzc on 14-4-27.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "ModifyPwdViewController.h"

@interface ModifyPwdViewController ()

@end

@implementation ModifyPwdViewController

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
    self.cancelButton = [UIFactory createButtonWithRect:CGRectMake(0, 0, 60, NavigationBarDefaultHeight)
                                                 normal:@""
                                              highlight:@""
                                               selector:@selector(onBack)
                                                 target:self];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.cancelButton];
    
    
    //标题
    self.titleLabel = [UIFactory createLabelWith:CGRectMake(80, 0, 160, NavigationBarDefaultHeight)
                                            text:@"修改密码"
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
    
    
    CGRect textfieldFrame = CGRectMake(40, 60, 200, 34);
    UIImageView *oldPwdBGImgView = [[UIImageView alloc] initWithFrame:textfieldFrame];
    [oldPwdBGImgView setBackgroundColor:[UIColor blueColor]];
    [oldPwdBGImgView setImage:[UIImage imageNamed:@""]];
    [self.backgroundView addSubview:oldPwdBGImgView];
    
    self.myOldPwdTextField = [UIFactory createTextFieldWithRect:textfieldFrame
                                                   keyboardType:UIKeyboardTypeDefault
                                                         secure:NO
                                                    placeholder:@"原密码"
                                                           font:[UIFont systemFontOfSize:18]
                                                          color:[UIColor redColor]
                                                       delegate:self];
    [self.backgroundView addSubview:self.myOldPwdTextField];
    
    
    textfieldFrame.origin.y += 60;
    UIImageView *myNewPwdBGImgView = [[UIImageView alloc] initWithFrame:textfieldFrame];
    [myNewPwdBGImgView setBackgroundColor:[UIColor blueColor]];
    [myNewPwdBGImgView setImage:[UIImage imageNamed:@""]];
    [self.backgroundView addSubview:myNewPwdBGImgView];
    
    self.myNewPwdTextField = [UIFactory createTextFieldWithRect:textfieldFrame
                                                   keyboardType:UIKeyboardTypeDefault
                                                         secure:YES
                                                    placeholder:@"原密码"
                                                           font:[UIFont systemFontOfSize:18]
                                                          color:[UIColor redColor]
                                                       delegate:self];
    [self.backgroundView addSubview:self.myNewPwdTextField];
    
    textfieldFrame.origin.y += 60;
    UIImageView *myConfirmPwdBGImgView = [[UIImageView alloc] initWithFrame:textfieldFrame];
    [myConfirmPwdBGImgView setBackgroundColor:[UIColor blueColor]];
    [myConfirmPwdBGImgView setImage:[UIImage imageNamed:@""]];
    [self.backgroundView addSubview:myConfirmPwdBGImgView];
    
    self.myConfirmPwdTextField = [UIFactory createTextFieldWithRect:textfieldFrame
                                                   keyboardType:UIKeyboardTypeDefault
                                                         secure:YES
                                                    placeholder:@"确认密码"
                                                           font:[UIFont systemFontOfSize:18]
                                                          color:[UIColor redColor]
                                                       delegate:self];
    [self.backgroundView addSubview:self.myConfirmPwdTextField];
    
    
    textfieldFrame.origin.y += 70;
    textfieldFrame.size.height = 40;
    self.doneButton = [UIFactory createButtonWithRect:textfieldFrame
                                                title:@"完成"
                                            titleFont:[UIFont systemFontOfSize:20]
                                           titleColor:[UIColor redColor]
                                               normal:nil
                                            highlight:nil
                                             selected:nil
                                             selector:@selector(onDone)
                                               target:self];
    [self.doneButton setBackgroundColor:[UIColor blueColor]];
    [self.backgroundView addSubview:self.doneButton];
    
    
    
    
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
    [self.myOldPwdTextField resignFirstResponder];
    [self.myNewPwdTextField resignFirstResponder];
    [self.myConfirmPwdTextField resignFirstResponder];
}

- (void)onTap
{
    [self hideKeyboard];
}

- (void)onDone
{
    NSString *oldPassword       = [self.myOldPwdTextField.text trim];
    NSString *newPassword       = [self.myNewPwdTextField.text trim];
    NSString *confimPassword    = [self.myConfirmPwdTextField.text trim];
    
    if (oldPassword == nil || [oldPassword length] == 0) {
        [PRPAlertView showWithTitle:@"请输入原密码"
                            message:nil
                        buttonTitle:@"确认"];
        
        return;
    }
    
    if (newPassword == nil || [newPassword length] == 0) {
        [PRPAlertView showWithTitle:@"请输入新密码"
                            message:nil
                        buttonTitle:@"确认"];
        
        return;
    } else if ([newPassword length] < 6) {
        [PRPAlertView showWithTitle:@"新密码长度不能少于6位"
                            message:nil
                        buttonTitle:@"确认"];
        
        return;
    }
    
    
    
    if (![newPassword isEqualToString:confimPassword]) {
        [PRPAlertView showWithTitle:@"新密码两次输入不一致"
                            message:nil
                        buttonTitle:@"确认"];
        
        return;
    }
    
    
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    [bodyParams setValue:[oldPassword MD5Sum] forKey:@"oldpass"];
    [bodyParams setValue:[newPassword MD5Sum] forKey:@"newpass"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_MODIFYPASSWORD];
    httpReq.bodyParams = bodyParams;
    
    [self showHud];
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        
        
        [self hideHud];
        NSLog(@"result = %@", result);
        NSLog(@"testModifyPassword.msg = %@", [result valueForKey:@"msg"]);
        NSInteger ret = [[result valueForKey:@"ret"] integerValue];
        if (ret == 0) {
            
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setValue:newPassword forKey:KEY_CurrentPassword];
            [userDefault synchronize];
            
            //修改成功
            [PRPAlertView showWithTitle:@"密码修改成功"
                                message:nil
                            buttonTitle:@"确定"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            

            //修改失败
            NSString *msg = [result valueForKey:@"msg"];
            [PRPAlertView showWithTitle:msg
                                message:nil
                            buttonTitle:@"确定"];
        }
    } Failure:^(NSError *err) {
        
        [self hideHud];
        NSLog(@"error = %@", [err description]);
        [self reportNetworkError:err];
    }];
    
    
}




- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
