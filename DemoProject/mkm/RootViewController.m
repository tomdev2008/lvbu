//
//  RootViewController.m
//  LVBU
//
//  Created by _xLonG on 14-4-15.
//  Copyright (c) 2014年 PK. All rights reserved.
//

#import "RootViewController.h"
#import "AppCore.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
//#import <CommonCrypto/CommonDigest.h>
//#import <CommonCrypto/CommonCryptor.h>
//#import "UIDevice+IdentifierAddition.h"
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface RootViewController ()<UITextFieldDelegate>
{
    UIView * topView;
    UILabel * titleLabel;
    UILabel * subLabel;
    UITextField * emailTextField;
    UITextField * passWordTextField;
    UIButton * registBtn;
    UIButton * loginBtn;
    UIButton * btn;
    UILabel * bottomLabel;
    ASIHTTPRequest * _request;
    UIImageView * imgView;
    
}
@end

@implementation RootViewController

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
    
    _root2 =[[SportMainVC2 alloc]init];
    [self.view sendSubviewToBack:_root2.view];
    
    
    NSUserDefaults * myDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userName = [myDefaults objectForKey:@"userName"];//提取用户名
    NSString * passWord = [myDefaults objectForKey:@"passWord"];
  
    
    topView =[[UIView alloc]initWithFrame:CGRectMake(50, 80, 50, 50)];
    topView.backgroundColor =[UIColor grayColor];
    topView.layer.cornerRadius = 25.0;
    [self.view  addSubview:topView];
    
    titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(100, 80, 100, 40)];
    titleLabel.text =@"侣步";
    titleLabel.font =[UIFont systemFontOfSize:24];
    [self.view addSubview:titleLabel];
    
    subLabel =[[UILabel alloc]initWithFrame:CGRectMake(100, 120, 100, 10)];
    subLabel.text =@"REALLYBE";
    subLabel.font =[UIFont systemFontOfSize:10];
    [self.view addSubview:subLabel];
    
    NSArray * arr =@[@"邮箱/手机号码",@"密码"];
    emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 160, 200, 50)];
    emailTextField.backgroundColor = [UIColor grayColor];
    emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    emailTextField.placeholder = arr[0];
   // emailTextField.secureTextEntry = YES;
    emailTextField.clearButtonMode = UITextFieldViewModeAlways;
    emailTextField.delegate = self;
    [self.view addSubview:emailTextField];
       
    
    passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 220, 200, 50)];
    passWordTextField.backgroundColor = [UIColor grayColor];
    passWordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passWordTextField.placeholder = arr[1];
    passWordTextField.secureTextEntry = YES;
    passWordTextField.clearButtonMode = UITextFieldViewModeAlways;
    passWordTextField.delegate = self;
    [self.view addSubview:passWordTextField];

    
    NSArray * btnArr =@[@"登录",@"注册"];
    for (int i=0; i<2; i++) {
        btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor =[UIColor grayColor];
        btn.tag = 100+i;
        btn.layer.borderColor =[UIColor grayColor].CGColor;
        btn.layer.borderWidth = 2.0;
        btn.frame = CGRectMake(50+100*i,iPhone5?290:300, 80, 50);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:btnArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    
    bottomLabel =[[UILabel alloc]initWithFrame:CGRectMake(50, 350, 200, 20)];
    bottomLabel.text =@"其他快捷登录";
    bottomLabel.textColor =[UIColor grayColor];
    bottomLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:bottomLabel];
    
    UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(50, 370, 200, 3)];
    lineView.backgroundColor =[UIColor grayColor];
    [self.view addSubview:lineView];
//sina  qq  login
    
    
    imgView=[[UIImageView alloc]initWithFrame:CGRectMake(50, 375, 30, 30)];
    imgView.image =[UIImage imageNamed:@"sinalogin.png"];
    imgView.userInteractionEnabled=YES;
    UITapGestureRecognizer * imgTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thirdLogin)];
    [imgView addGestureRecognizer:imgTap];
    [self.view addSubview:imgView];
    
    
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismessKeyboard)];
    [self.view addGestureRecognizer:tap];
//提取用户名
    NSUserDefaults * myDefault = [NSUserDefaults standardUserDefaults];
    NSString * userName1 = [myDefault objectForKey:@"userName"];
    if(userName1 !=0){
           emailTextField.text = userName1;
    }else{
       emailTextField.text=@"";
    }
    
    _passWDStr = passWordTextField.text;
}
-(void)dismessKeyboard
{
    [self.view endEditing:YES];
}
-(void)thirdLogin
{
    NSLog(@"tap......");
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
//    NSLog(@"authOptions is %@",authOptions);
//    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:authOptions result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//        if (result)
//        {
//            id<ISSPlatformCredential> creadential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];
////            NSLog(@"[creadential uid] is %@",[creadential uid]);
////            NSLog(@"[creadential token] is %@",[creadential token]);
//            UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
//                                                                 message:[NSString stringWithFormat:
//                                                                          @"登录成功\n uid = %@\ntoken = %@\nsecret = %@\n expired = %@\nextInfo = %@",
//                                                                          [creadential uid],
//                                                                          [creadential token],
//                                                                          [creadential secret],
//                                                                          [creadential expired],
//                                                                          [creadential extInfo]]
//                                                                delegate:nil
//                                                       cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了")
//                                                       otherButtonTitles:nil];
//            [alertView1 show];
//         }
//        else
//        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"欢迎您再次回来" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alertView show];
//            
//            
//        }
//    }];
    
}
-(void)Click:(UIButton *)button
{
     if (button.tag == 101) {
        RegistViewController * registCtl =[[RegistViewController alloc]init];
        [self.navigationController pushViewController:registCtl animated:YES];
//        registCtl.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        [self presentViewController:registCtl animated:YES completion:nil];
    }else if(button.tag == 100) {
        NSString * textString = passWordTextField.text;
        NSString* secretData=[self encryptMD5String:textString];
        //手机序列号
        //uniqueDeviceIdentifier (返回MAC和CFBundleIdentifier的MD5值)
       // uniqueGlobalDeviceIdentifier(返回MAC的MD5值)
//        NSString * identifierNumber =[[UIDevice currentDevice]uniqueGlobalDeviceIdentifier];
//        NSLog(@"identifierNumber is %@",identifierNumber);
        //设备名称uniqueGlobalDeviceIdentifier
        NSString * deviceName =[[UIDevice currentDevice]systemName];
        NSLog(@"deviceName is %@",deviceName);
        NSString * url = [NSString stringWithFormat:@"http://api.reallybe.com/v1/login/login1?email=%@&password=%@&appid=%@",emailTextField.text,secretData,@"0"];
                 _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
                  _request.delegate = self;
        NSLog(@"emailTextField.text is %@,passWordTextField.text is %@",emailTextField.text,secretData);
        NSLog(@"passWordTextField is %@",passWordTextField.text);
        NSLog(@"url is %@",url);
                 [_request startAsynchronous];

                }else{
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"错误" message:@"没有该用户，请先注册。" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertView show];
        }

}
-(NSString *)encryptMD5String:(NSString*)string{
    const char *cStr = [string UTF8String];
    
    unsigned char result[32];
    
    CC_MD5( cStr, strlen(cStr),result );
    
    NSMutableString *hash =[NSMutableString string];
    
    for (int i = 0; i < 16; i++)
        
        [hash  appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 需要告诉苹果的服务器，当前应用程序需要接收远程通知
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    
    return YES;
}
#pragma mark - 获取到设备的代号（令牌）
// 接收到苹果返回的设备代号
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 将deviceToken转换成字符串，以便后续使用
    NSString *token = [deviceToken description];
    NSLog(@"description %@", token);
    
    // =======================================================
    // 如果DeviceToken发生变化，需要通知服务器
    // 每次都记录住从服务器获取到得DeviceToken
    // 再次获取时进行比对
    // 从偏好设置取出当前保存的Token
    NSString *oldToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
    
    //当Token发生变化时，提交给服务器保存新的Token
    if (![oldToken isEqualToString:token]) {
        
        // 将deviceToken通过Post请求，提交给自己的服务器即可！
        // 发送Post请求
        NSURL *url = [NSURL URLWithString:@"http://api.reallybe.com/v1/login/login1?email=a222@qq.com&password=1f3870be274f6c49b3e31a0c6728957f"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
        
        request.HTTPMethod = @"POST";
       // request.HTTPBody = @"转换后的设备ID以及其他信息[之前的Token]";
        
        // SQL: update t_deviceTable set token = newToken where token = oldToken;
        
        // 同步：必须执行完才能继续
        // 异步：直接交给其他线程工作，不干扰主线程工作，用户也感觉不到延迟
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            // 偷偷的将用户信息传送到公司的服务器
        }];
    }
    
    // 将Token保存至系统偏好
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"DeviceToken"];
}
#pragma mark - ASIHttpRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
     UserMsg * user =[[UserMsg alloc]init];
    user.userscode =[dic objectForKey:@"scode"];
    NSLog(@"dic is %@",dic);
    NSDictionary *dict=[dic objectForKey:@"user"];
    
    user.userid = [dict objectForKey:@"u_id"];
    NSString *  ret = [dic objectForKey:@"ret"];
    NSString * height = [dic objectForKey:@"height"];
    
    if (ret ==0) {
        
    }
    
       if (!ret) {
           NSLog(@"[dic objectForKey:@ret] is %@",[dic objectForKey:@"ret"]);

           UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"登录失败" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
           [alertView show];
       }else{
           
           if (height) {
               SportMainVC * ctl =[[SportMainVC alloc]init];
               //  SportMainVC2 * ctl =[[SportMainVC2 alloc]init];
               ctl.IDStr1 = user.userid;
               ctl.userscode1 = user.userscode;
               ctl.hidesBottomBarWhenPushed=YES;
               
               [self.navigationController pushViewController:ctl animated:YES];
           }else{
               detailMsgViewController * ctl =[[detailMsgViewController alloc]init];
               
               [self.navigationController pushViewController:ctl animated:YES];
           }
           
              // 保存用户名
           NSUserDefaults * myDefaults = [NSUserDefaults standardUserDefaults];
           [myDefaults setObject:emailTextField.text forKey:@"userName"];
            [myDefaults synchronize];
           
       }

    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
