//
//  ChangePSW.m
//  LVBU
//
//  Created by _xLonG on 14-4-22.
//  Copyright (c) 2014年 PK. All rights reserved.
//

#import "ChangePSW.h"
#import "AppCore.h"
@interface ChangePSW ()<UITextFieldDelegate>
{
    UILabel * conditionLabel;
    UITextField * conditionTextf;
}
@end

@implementation ChangePSW

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
    NSArray * detailMsgArr = @[@"旧密码",@"新密码",@"确认密码"];
    for (int i=0; i<3; i++) {
        conditionLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 100+50*i, 70, 50)];
        conditionLabel.text = detailMsgArr[i];
        conditionLabel.font=[UIFont systemFontOfSize:14.0];
        [self.view addSubview:conditionLabel];
        
        conditionTextf = [[UITextField alloc] initWithFrame:CGRectMake(100, 100+50*i, 180, 45)];
        conditionTextf.tag = 100+i;
      
        conditionTextf.borderStyle = UITextBorderStyleRoundedRect;
        conditionTextf.secureTextEntry = YES;
        conditionTextf.clearButtonMode = UITextFieldViewModeAlways;
        conditionTextf.delegate = self;
        [self.view addSubview:conditionTextf];
        
    }
    
    
    UIButton * sureBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureBtn.frame = CGRectMake(50, 310, 220, 40);
    [sureBtn setTitle:@"修改成功" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    sureBtn.backgroundColor=[UIColor purpleColor];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismessKeyboard)];
    [self.view addGestureRecognizer:tap];
}
-(void)sureClick
{
   //给其请求，给提示信息  （http://api.reallybe.com）   修改密码 /v1/user/modpass
     UITextField * oldPsw =(UITextField *)[self.view viewWithTag:100];
    UITextField * psw =(UITextField *)[self.view viewWithTag:102];
    NSString* oldPswData=[self encryptMD5String:oldPsw.text];
    NSString* newPswData=[self encryptMD5String:psw.text];
//post
//     NSString * urlString = [NSString stringWithFormat:@"http://api.reallybe.com/v1/user/modinfo"];
//    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
//    [requestForm addPostValue:_userscode4 forKey:@"scode"];
//    [requestForm addPostValue:oldPswData forKey:@"oldpass"];
//    [requestForm addPostValue:newPswData forKey:@"newpass"];
//    
//    NSLog(@"oldPsw.text is %@",oldPsw.text);
//    NSLog(@"psw.text is %@",psw.text);
//    
//     requestForm.delegate =self;
//    [requestForm startAsynchronous];
    
//get
    NSString *postURL = [NSString stringWithFormat:@"http://api.reallybe.com/v1/user/modpass?scode=%@&oldpass=%@&newpass=%@",_userscode4,oldPswData,newPswData];
  //   NSString *postURL = [NSString stringWithFormat:@"http://api.reallybe.com/v1/user/modpass?scode=%@&oldpass=%@&newpass=%@",_userscode4,oldPsw.text,psw.text];
    NSLog(@"postURL is %@",postURL);
    NSLog(@"oldPsw.text is %@",oldPsw.text);
    NSLog(@"psw.text is %@",psw.text);
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    request.delegate =self;
    [request startAsynchronous];
    
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
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"[request responseData] is %@",[request responseData]);
    NSString *str=[[NSMutableString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"str is %@",str);
    NSLog(@"dic is %@ , msg is %@",dic,[dic objectForKey:@"msg"]);
    
    NSString *  ret = [dic objectForKey:@"ret"];
    if (ret) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码修改成功"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        
        [alert show];
       return;
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提交修改密码失败"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        
        [alert show];
        return;
    }
}

-(void)dismessKeyboard
{
    [self.view endEditing:YES];
}

@end
