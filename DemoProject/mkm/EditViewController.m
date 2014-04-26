//
//  EditViewController.m
//  LVBU
//
//  Created by _xLonG on 14-4-21.
//  Copyright (c) 2014年 PK. All rights reserved.
//

#import "EditViewController.h"
#import "AppCore.h"
#import "AppConfig.h"
@interface EditViewController ()<UITextFieldDelegate,NSURLConnectionDataDelegate>
{
    UILabel * userLabel;
     NSMutableData * _recvData;
    NSURLConnection *stringConnection;
    BOOL _reqFlag;
    UILabel * _sexLabel;
   
}
@end

@implementation EditViewController

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
//    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"个人信息";
 //   NSLog(@"_IDStr is %@",_IDStr);
    _recvData = [[NSMutableData alloc] init];
//100
    _headimgView =[[UIImageView alloc]initWithFrame:CGRectMake(50, 100, 50, 50)];
    _headimgView.backgroundColor =[UIColor grayColor];
    [self.view addSubview:_headimgView];

    _nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(120, 100, 100, 50)];
    _nameLabel.text=@"昵称";
    _nameLabel.font =[UIFont systemFontOfSize:20];
    [self.view addSubview:_nameLabel];
//160
    NSArray * arr =@[@"性别",@""];
    for(int i=0;i<2;i++){
    _sexLabel =[[UILabel alloc]initWithFrame:CGRectMake(50+60*i, 160, 320, 40)];
    _sexLabel.text = arr[i];
    _sexLabel.font =[UIFont systemFontOfSize:14.0];
    [self.view addSubview:_sexLabel];
    
    }
//160+40
    
    
    NSArray * detailMsgArr = @[@"生日",@"身高",@"体重"];
    for (int i=0; i<3; i++) {
       userLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 210+50*i, 50, 40)];
       userLabel.text = detailMsgArr[i];
       userLabel.font=[UIFont systemFontOfSize:14.0];
       [self.view addSubview:userLabel];
        
        _userMsg = [[UITextField alloc] initWithFrame:CGRectMake(80, 210+50*i, 200, 37)];
        _userMsg.tag = 100+i;
      //  _f.backgroundColor = [UIColor grayColor];
        _userMsg.borderStyle = UITextBorderStyleRoundedRect;
        
      //  _f.secureTextEntry = YES;
        _userMsg.clearButtonMode = UITextFieldViewModeAlways;
        _userMsg.delegate = self;
        [self.view addSubview:_userMsg];

    }
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 350, 220, 30);
    [btn setTitle:@"编辑信息" forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor purpleColor];
        [btn addTarget:self action:@selector(myBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton * changeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(50, 390, 220, 30);
    [changeBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    changeBtn.backgroundColor=[UIColor purpleColor];
    [changeBtn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    
    
    UIButton * cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, kScreenHeight-30, 300, 30);
    [cancelBtn setTitle:@"退出" forState:UIControlStateNormal];
    cancelBtn.backgroundColor=[UIColor purpleColor];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];

    
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismessKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    
}
-(void)myBtn
{
    
    UserMsg * user =[[UserMsg alloc]init];
    user.userid = _IDStr;
    user.userscode = _userscode3;
    UITextField * birthf =(UITextField *)[self.view viewWithTag:100];
    UITextField * heightf =(UITextField *)[self.view viewWithTag:101];
    UITextField * weightf =(UITextField *)[self.view viewWithTag:102];
    NSString * birthStr = birthf.text;
    NSString * heightStr = heightf.text;
    NSString * weightStr = weightf.text;
//post
    NSString * urlString = [NSString stringWithFormat:@"http://api.reallybe.com/v1/user/modinfo"];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestForm addPostValue:_userscode3 forKey:@"scode"];
  //  [requestForm addPostValue:birthStr forKey:@"sex"];
     [requestForm addPostValue:birthStr forKey:@"birth"];
    [requestForm addPostValue:heightStr forKey:@"height"];
    [requestForm addPostValue:weightStr forKey:@"weight"];
     requestForm.delegate =self;
    [requestForm startAsynchronous];
    
    
    
    
    
    //    //get /v1/user/modinfo?sex=0|1&height=180&..............
////     NSString *postURL = [NSString stringWithFormat:@"http://api.reallybe.com/v1/user/modinfo?scode=%@&height=%@&weight=%@",_userscode3,heightStr,weightStr];
//    NSString *postURL = [NSString stringWithFormat:@"http://api.reallybe.com/v1/user/modinfo?scode=%@&sex=%@&height=%@&weight=%@",_userscode3,@"0",heightStr,weightStr];
//     NSLog(@"postURL is %@",postURL);
//
//     ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
//     request.delegate =self;
//     [request startAsynchronous];
}
#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (_reqFlag == YES) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"dic is %@ , msg is %@",dic,[dic objectForKey:@"msg"]);

    }else{
    NSDictionary * dic1 = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];

    NSLog(@"dic1 is %@ , msg1 is %@",dic1,[dic1 objectForKey:@"msg"]);
    }
        //    NSString * ret =[dic objectForKey:@"ret"];
//    if (ret) {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示：" message:@"注销成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }else{
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示：" message:@"注销失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//
    

}
-(void)dismessKeyboard
{
    [self.view endEditing:YES];
}
-(void)cancelClick
{
  //  注销http://api.reallybe.com/v1/login/logout?scode=04831c5f46df4a44bd2a7fc6e1d76f46
    //scode = 2f002f2ee4a146a897573c8a2c948146
 //get
    _reqFlag = NO;
    NSString * str = [NSString stringWithFormat:@"http://api.reallybe.com/v1/login/logout?scode=%@",_userscode3];
    NSLog(@"str is %@",str);
//   NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
//    stringConnection = [NSURLConnection connectionWithRequest:request delegate:self];
   ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:str]];
   request.delegate =self;
   [request startAsynchronous];

}
-(void)changeClick
{
    ChangePSW * ctl =[[ChangePSW alloc]init];
    ctl.userscode4 = _userscode3;
    [self.navigationController pushViewController:ctl animated:YES];
}
//系统解析暂且不用
#pragma mark  --connection
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _recvData.length = 0;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error is %@",[error userInfo]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_recvData appendData:data];
    NSLog(@"_recvData is %@",_recvData);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString * jsonStr = [[NSString alloc] initWithData:_recvData encoding:NSUTF8StringEncoding];
    NSDictionary * dic = [jsonStr JSONValue];
    
     NSLog(@"dic is %@ ,%@",dic,[dic objectForKey:@"msg"]);
    NSString * ret =[dic objectForKey:@"ret"];
    
    if (ret) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示：" message:@"注销成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
       UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示：" message:@"注销失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
       [alert show];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
