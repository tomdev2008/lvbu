//
//  RegistViewController.m
//  LVBU
//
//  Created by _xLonG on 14-4-15.
//  Copyright (c) 2014年 PK. All rights reserved.
//

#import "RegistViewController.h"
#import "AppCore.h"
#import "AppConfig.h"
#import<CommonCrypto/CommonDigest.h>

@interface RegistViewController ()<UITextFieldDelegate,ASIHTTPRequestDelegate>
{
    UIView * topView;
    UILabel * titleLabel;
    UILabel * subLabel;
    UIView * navView ;
    UILabel * navtitleLabel;
    UITextField * registtextfield;
    UIButton * endRegistlBtn;
    UIButton * backBtn;
    NSString *emailAddr;
    BOOL flag1;
    UITextField * confirmPWView;
    ASIFormDataRequest * formDataRequest;
    ASIHTTPRequest * _request;
    BOOL flagEmail;
}
-(BOOL)isValidateEmail:(NSString *)email;
-(BOOL)isMobileNumber:(NSString *)emailAddr;
@end

@implementation RegistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       // self.title=@"注册";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"注册";

//    
    backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 80, 40);
    [backBtn setTitle:@"登录" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarButtom =[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarButtom;

   
    
    
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
    
    
    
    NSArray * arr =@[@"邮箱或手机号",@"密码",@"确认密码"];
    for (int i=0; i<3; i++) {
        registtextfield = [[UITextField alloc] initWithFrame:CGRectMake(50, 150+60*i, 220, 50)];
        registtextfield.backgroundColor = [UIColor grayColor];
        registtextfield.tag = 200+i;
        
        registtextfield.borderStyle = UITextBorderStyleRoundedRect;
        registtextfield.placeholder = arr[i];
        if (registtextfield.tag == 200) {
            registtextfield.secureTextEntry = NO;
        }else{
            registtextfield.secureTextEntry = YES;
        }
        registtextfield.clearButtonMode = UITextFieldViewModeAlways;
        registtextfield.delegate = self;
        [self.view addSubview:registtextfield];
    }
    
    endRegistlBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    endRegistlBtn.backgroundColor =[UIColor grayColor];
    endRegistlBtn.layer.borderColor =[UIColor grayColor].CGColor;
    endRegistlBtn.layer.borderWidth = 2.0;
    endRegistlBtn.frame = CGRectMake(100, 360, 120, 50);
    [endRegistlBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [endRegistlBtn setTitle:@"完成注册" forState:UIControlStateNormal];
    [endRegistlBtn addTarget:self action:@selector(EndClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:endRegistlBtn];
    
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismessKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self AboutHiddeView];
}
-(void)AboutHiddeView
{
    confirmPWView =[[UITextField alloc]initWithFrame:CGRectMake(50,kScreenHeight-256, 250, 40)];
    confirmPWView.backgroundColor =[UIColor whiteColor];
    confirmPWView.layer.cornerRadius = 8.0;
    confirmPWView.layer.borderWidth = 2.0;
    confirmPWView.secureTextEntry = YES;
    confirmPWView.layer.borderColor =[UIColor grayColor].CGColor;
    confirmPWView.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:confirmPWView];
    confirmPWView.hidden = YES;
}
bool hiddenSta = YES;
#pragma mark -- UItextField Delegate
// 用户点击UITextField进入编辑状态调用
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == 202) {
        [self performSelector:@selector(hiddenToDisplay) withObject:self afterDelay:0.25];
        
        textField.text =confirmPWView.text;
       // [self hiddenToDisplay];
       
    }
    
}
-(void)hiddenToDisplay
{
   confirmPWView.hidden = NO;
}
-(void)dismessKeyboard
{
    [self.view endEditing:YES];
    confirmPWView.hidden = YES;
    UITextField * comfirmPwdTextfield =(UITextField *)[self.view viewWithTag:202];
    comfirmPwdTextfield.text =confirmPWView.text;

}
-(void)backClick
{
  //  RootViewController * ctl =[[RootViewController alloc]init];
  //  [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)EndClick
{
    
    UITextField * emailTextField =(UITextField *)[self.view viewWithTag:200];
    UITextField * passwordTextField =(UITextField *)[self.view viewWithTag:201];
    UITextField * comfirmPwdTextfield =(UITextField *)[self.view viewWithTag:202];
    
    emailAddr = emailTextField.text;
    NSString *password = passwordTextField.text;
    comfirmPwdTextfield.text =confirmPWView.text;
    NSLog(@"comfirmPwdTextfield is %@",comfirmPwdTextfield);
    NSString *confirmPwd = comfirmPwdTextfield.text;
    
//    //目前只做测试
//    NSMutableArray * emailArr =[NSMutableArray arrayWithObjects:@"@qq.com",@"@sina.com",@"@126.com",@"@163.com",@"@foxmail.com",@"@msn.com",@"@msn.com.cn",@"@gmail.com", nil];
//    for (int i=0; i<emailArr.count; i++) {
//        NSString * str =[NSString stringWithFormat:emailArr[i]];
//        
//    }
    
    NSRange range = [emailAddr rangeOfString:@"@"];
//    NSRange range1 =[emailAddr rangeOfString:@"@."];
  //  range.location = NSNotFound;//不包含
 //   NSLog(@"emailTextField is %@",emailAddr);
    
    
    if (emailAddr == nil  || [emailAddr length] == 0  ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮箱不能为空"
                                                         message:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
        [alert show];
        return;
    }else if (range.location == NSNotFound){
        flag1 = YES;
        [self isMobileNumber:(NSString *)emailAddr];
        return;
    }else {
        [self isValidateEmail:(NSString *)emailAddr];
        if (flagEmail == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您输入的邮箱有误，请重新输入"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    
    
    
    if (password == nil || [password length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码不能为空"
                                                         message:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    if ((confirmPwd == nil || [confirmPwd length] == 0) || ![confirmPwd isEqualToString:password]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码和确认密码不一致"
                                                         message:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
        [alert show];
        return;
    }
    self.email = emailAddr;
    self.password = password;
    if( (flag1 != NO || range.location>0)  && [confirmPwd isEqualToString:password]){
        if (password.length <6) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您输入的密码过于简单请重新设置"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
          
            [alert show];
           return;
        }else{
        
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ 正确无误?", emailAddr]
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定",nil];
    alert.tag = 100;
    [alert show];

       //每次请求会来得token都不一样，目前记住用户名
            
     //   [self performSelector:@selector(pushOtherVC)  withObject:self afterDelay:2.0];
        //加密后上传
            UserMsg * user =[[UserMsg alloc]init];
            user.name=self.email;
            user.pass=self.password;
            
            NSString * textString = self.password;
            NSString* secretData=[self encryptMD5String:textString];
//            NSString * urlString = @"http://api.reallybe.com/v1/user/registe?email=123411@qq.com&password=12312";
//            ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
//            //设置需要POST的数据，这里提交两个数据，A=a&B=b
//            [requestForm addPostValue:self.email forKey:@"username"];
//            [requestForm addPostValue:secretData forKey:@"password"];
//            requestForm.delegate =self;
//            [requestForm startAsynchronous];          //输入返回的信息
//            NSLog(@"responsen%@",[requestForm responseString]);
            
            
            NSString * postURL = [NSString stringWithFormat:@"http://api.reallybe.com/v1/user/registe?email=%@&password=%@",self.email,secretData];
            NSLog(@"postURL is %@",postURL);
            ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
            request.delegate =self;
            NSLog(@"self.email is %@,secretData is %@",self.email,secretData);
            [request startAsynchronous];
   
            
       }
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

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
   
  //  NSDictionary * dic = [[request responseString] JSONValue];
   
   NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"dic is %@ ,%@",dic,[dic objectForKey:@"msg"]);
    NSString * ret =[dic objectForKey:@"ret"];
    //ret  msg
    if (ret) {
        [self pushOtherVC];
    }else{
        return;
    }
    
}

-(void)pushOtherVC
{
//    detailMsgViewController * ctl =[[detailMsgViewController alloc]init];
//    [self.navigationController pushViewController:ctl animated:YES];

    RootViewController * root =[[RootViewController alloc]init];
    
    [self.navigationController pushViewController:root animated:YES];
}

#pragma mark--

#pragma mark 正则表达式 判断手机号码是否合法
/*邮箱验证 MODIFIED BY HELENSONG*/
-(BOOL)isValidateEmail:(NSString *)email
{
    NSLog(@"email is %@",email);
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
   // NSString *emailRegex = @"^[a-z0-9]+([._\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){2,63}[a-z0-9]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    flagEmail = [emailTest evaluateWithObject:email];
    NSLog(@"flag2 is %d",flagEmail);
    return flagEmail;
}

// 正则判断手机号码地址格式

-(BOOL)isMobileNumber:(NSString *)mobileNum

{
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
     NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    /**
     
     25         * 大陆地区固话及小灵通
     
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     
     27         * 号码：七位或八位
     
     28         */
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
        
    {
         return YES;
        
    }
    
    else
        
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您输入的号码有误，请重新核对"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        flag1 = NO;
        return NO;
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
