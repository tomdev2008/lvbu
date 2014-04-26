//
//  detailMsgViewController.m
//  LVBU
//
//  Created by _xLonG on 14-4-15.
//  Copyright (c) 2014年 PK. All rights reserved.
//

#import "detailMsgViewController.h"
//#import "SportMainVC.h"
#import "AppConfig.h"
#import "AppCore.h"
typedef enum{
  //定义男女
     MAN = 0,
    WOMAN = 1
    
}SexStatues;
@interface detailMsgViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView * bottomView;
    UIView * conBottomView;//生日，身高，体重的底视图
    UIView * headimgView;
    UILabel * nameLabe;
    UILabel * sexLabel;
    UIButton * sexBtn;
    UIView * detailVClineView;
    
    UILabel *  conditionsLabel;
    UILabel * conditionsRightLabel;
    UIView * conditionLineView;
    UIImageView * displayImg;
    
    UILabel * birthRightLabel;
    UILabel * heightRightLabel;
    UILabel * weightRightLabel;
    
    UILabel * bottomEndLabel;
    
    UIButton * completeBtn;
    BOOL flag;
    NSString * flag1;
    UIView * hiddenChoiceView;
    NSTimer * timer;
    
    NSArray * conditionsArr2;
    NSArray * conditionsArr;
    BOOL sexFalg;
    UIImageView * imgView1;
}
@end

@implementation detailMsgViewController{
   UITableView * tableViewToChoice;
    UIPickerView * picker;
    UIDatePicker *oneDatePicker;
    NSMutableArray * choiceArr;
    NSMutableArray * arr1;
    NSMutableArray * arr2;
}

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
    bottomView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenHeight, self.view.bounds.size.height)];
    [self.view addSubview:bottomView];
    
    headimgView =[[UIView alloc]initWithFrame:CGRectMake(50, 80, 50, 50)];
    headimgView.backgroundColor =[UIColor grayColor];
    [bottomView addSubview:headimgView];
    
    nameLabe =[[UILabel alloc]initWithFrame:CGRectMake(120, 80, 100, 50)];
    nameLabe.text=@"昵称";
    [bottomView addSubview:nameLabe];
    
    
    
    [self AboutChoiceSex];
    [self AboutconditionsLabel];
    [self AboutHiddenView];
    
    [self AboutBottomEndLabel];
    [self AboutCompleteBtn];
     [self.view bringSubviewToFront:imgView1];
}
-(void)AboutChoiceSex
{
    sexLabel =[[UILabel alloc]initWithFrame:CGRectMake(50, 150, 50, 40)];
    sexLabel.text = @"性别";
    sexLabel.font =[UIFont systemFontOfSize:14.0];
    [bottomView addSubview:sexLabel];
    
    NSArray * sexArr =@[@"男",@"女"];
    for (int i=0; i<2; i++) {
        sexBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        sexBtn.tag = 200+i;
        sexBtn.backgroundColor =[UIColor grayColor];
        sexBtn.alpha=0.5;
        
        sexFalg = YES;
        if (sexFalg == YES && sexBtn.tag == 200) {
           // sexBtn.backgroundColor =[UIColor grayColor];
            sexBtn.alpha=1.0;
            flag1 = @"0";
        }else{
            flag1 =@"1";
        }
        
        
        sexBtn.frame = CGRectMake(100+75*i, 160, 70, 20);
        [sexBtn setTitle:sexArr[i] forState:UIControlStateNormal];
        [sexBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sexBtn addTarget:self action:@selector(choiceSexBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:sexBtn];
    }
    detailVClineView =[[UIView alloc]initWithFrame:CGRectMake(50, 190, 220, 2)];
    detailVClineView.backgroundColor=[UIColor grayColor];
    [bottomView addSubview:detailVClineView];
    
}
-(void)AboutconditionsLabel
{
    NSArray * detailMsgArr = @[@"生日",@"身高",@"体重"];
    conditionsArr = @[@"1988-12-05",@"180CM",@"70KG"];
     conditionsArr2 = @[@"1990-08-08",@"165CM",@"50KG"];
    for (int i=0; i<3; i++) {
        conBottomView =[[UIView alloc]initWithFrame:CGRectMake(50, 205+60*i, 220, 42)];
        conBottomView.tag= 105+i;
        [bottomView addSubview:conBottomView];
        
     //   conditionsLabel =[[UILabel alloc]initWithFrame:CGRectMake(50, 210+60*i, 50, 40)];
        conditionsLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
        conditionsLabel.text = detailMsgArr[i];
        conditionsLabel.font=[UIFont systemFontOfSize:14.0];
        [conBottomView addSubview:conditionsLabel];
        
        //conditionsRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 210+60*i, 100, 40)];
        conditionsRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 40)];
        conditionsRightLabel.tag = 300+i;
        conditionsRightLabel.text = conditionsArr[i];
        conditionsRightLabel.textAlignment =NSTextAlignmentCenter;
        conditionsRightLabel.adjustsFontSizeToFitWidth =YES;
        [conBottomView addSubview:conditionsRightLabel];
        
        displayImg =[[UIImageView alloc]initWithFrame:CGRectMake(150, 20, 25, 15)];
        displayImg.image =[UIImage imageNamed:@"Bulge@2x.png"];
        displayImg.userInteractionEnabled = YES;
        displayImg.tag = 350+i;
        UITapGestureRecognizer * imgTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ChoiceConditionsTap:)];
        [displayImg addGestureRecognizer:imgTap];
        [conBottomView addSubview:displayImg];
        
        conditionLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 220, 1)];
        conditionLineView.backgroundColor =[UIColor grayColor];
        [conBottomView addSubview:conditionLineView];
        
    }

}
-(void)AboutBottomEndLabel
{
    bottomEndLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 360, 200, 40)];
    bottomEndLabel.text = @"完善个人信息，你会有更多好友哦！";
    bottomEndLabel.font =[UIFont systemFontOfSize:12.0];
    [bottomView addSubview:bottomEndLabel];

}
-(void)AboutCompleteBtn
{
    
    NSArray * completeArr =@[@"完成",@"立即体验，下次填写"];
    for (int i=0; i<2; i++) {
        completeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        completeBtn.backgroundColor =[UIColor grayColor];
        completeBtn.layer.borderColor =[UIColor grayColor].CGColor;
        completeBtn.layer.borderWidth = 2.0;
        completeBtn.frame = CGRectMake(70, 400+35*i, 180, 30);
        completeBtn.tag = 400+i;
        [completeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [completeBtn setTitle:completeArr[i] forState:UIControlStateNormal];
        completeBtn.font=[UIFont systemFontOfSize:12.0];
        [completeBtn addTarget:self action:@selector(completeClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:completeBtn];
        
    }

}
-(void)AboutHiddenView
{
    picker =[[UIPickerView alloc]initWithFrame:CGRectMake(50, 200, 220, 0)];
    picker.showsSelectionIndicator =YES;
    picker.delegate =self;
    picker.dataSource =self;
    picker.hidden=YES;
    [self.view addSubview:picker];
    arr1 =[NSMutableArray array];
    arr2 =[NSMutableArray array];
  //  tempArray =[NSMutableArray array];
    
    for (int i=100; i<250; i++) {
        NSString * str =[NSString stringWithFormat:@"%dCM",i];
        [arr1 addObject:str];
    }
    

    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismessTableView:)];
    [bottomView addGestureRecognizer:tap];

}
#pragma mark --UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arr1.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * str = [NSString stringWithFormat:@"%@",[arr1 objectAtIndex:row]];
    UILabel * label1 =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    label1.text = str;
    label1.textColor =[UIColor redColor];
    return label1.text;
    return str;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel * label1 =(UILabel *)[self.view viewWithTag:301];
    label1.text = [NSString stringWithFormat:@"%@",[arr1 objectAtIndex:row]];
    
}

-(void)choiceSexBtn:(UIButton *)button
{
    UIButton * btn1 =(UIButton *)[self.view viewWithTag:200];
    UIButton * btn2 =(UIButton *)[self.view viewWithTag:201];
    UITextField * f1 =(UITextField *)[self.view viewWithTag:300];
    UITextField * f2 =(UITextField *)[self.view viewWithTag:301];
    UITextField * f3 =(UITextField *)[self.view viewWithTag:302];
    if (button.tag == 201 && sexFalg ==YES) {
        button.alpha=1.0;
        btn1.alpha = 0.5;
     
         f1.text = conditionsArr2[0];
         f2.text = conditionsArr2[1];
         f3.text = conditionsArr2[2];
    }else{
        btn1.alpha = 1.0;
        btn2.alpha = 0.5;
        f1.text = conditionsArr[0];
        f2.text = conditionsArr[1];
        f3.text = conditionsArr[2];
    }
    sexFalg = !sexFalg;
}
-(void)ChoiceConditionsTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"不被隐藏");
    if (flag == NO) {
        [UIView animateWithDuration:0.2 animations:^{
        tap.view.transform = CGAffineTransformMakeRotation(180*M_PI/180);
            //隐藏的视图
            picker.hidden=NO;
            picker.frame = CGRectMake(0, 255, 320, 216);
            UIView * v1 =(UIView *)[self.view viewWithTag:106];
            UIView * v2 =(UIView *)[self.view viewWithTag:107];
            v1.frame = CGRectMake(50, 470, 200, 50);
            v2.frame = CGRectMake(50, 520, 200, 50);
            bottomEndLabel.frame =CGRectMake(50, 570, 200, 40);
            UIButton * btn1 = (UIButton *)[self.view viewWithTag:400];
            UIButton * btn2 = (UIButton *)[self.view viewWithTag:401];
            btn1.hidden=YES;
            btn2.hidden=YES;        }];
    }else {
        NSLog(@"被隐藏");
        [UIView animateWithDuration:0.2 animations:^{
        tap.view.transform = CGAffineTransformIdentity;
      
            picker.hidden = YES;
            
            UIView * v1 =(UIView *)[self.view viewWithTag:106];
            UIView * v2 =(UIView *)[self.view viewWithTag:107];
            v1.frame = CGRectMake(50, 265, 200, 50);
            v2.frame = CGRectMake(50, 325, 200, 50);
            bottomEndLabel.frame =CGRectMake(50, 360, 200, 40);
            UIButton * btn1 = (UIButton *)[self.view viewWithTag:400];
            UIButton * btn2 = (UIButton *)[self.view viewWithTag:401];
            btn1.hidden=NO;
            btn2.hidden=NO;

        }];
    }
    
    flag = !flag;
}
-(void)dismessTableView:(UITapGestureRecognizer *)tap
{
    hiddenChoiceView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        UIImageView * arrowImg1 =(UIImageView *)[self.view viewWithTag:350];
        UIImageView * arrowImg2 =(UIImageView *)[self.view viewWithTag:351];
        UIImageView * arrowImg3 =(UIImageView *)[self.view viewWithTag:352];
     arrowImg1.transform = CGAffineTransformIdentity;
       arrowImg2.transform = CGAffineTransformIdentity;
        arrowImg3.transform = CGAffineTransformIdentity;
        
        
        
    }];
    UIButton * btn =(UIButton *)[self.view viewWithTag:400];
    btn.hidden = NO;
    completeBtn.hidden = NO;

}
-(void)completeClick:(UIButton *)btn
{
    if (btn.tag == 400) {

        UserMsg * user =[[UserMsg alloc]init];
        user.userid = _userID;
        user.userscode = _userscode;
       //  UILabel * sexLabel =(UILabel *)[self.view viewWithTag:300];
        UILabel * birLabel =(UILabel *)[self.view viewWithTag:300];
        UILabel * heightLabel =(UILabel *)[self.view viewWithTag:301];
        UILabel * weightLabel =(UILabel *)[self.view viewWithTag:302];
      
        NSString * birthStr = birLabel.text;
        NSString * heightStr = heightLabel.text;
        NSString * weightStr = weightLabel.text;

    
//post
        NSString * urlString = [NSString stringWithFormat:@"http://api.reallybe.com/v1/user/modinfo"];
        ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
        [requestForm addPostValue:_userscode forKey:@"scode"];
        //[requestForm addPostValue:(n)flag1 forKey:@"sex"];
//可能有bug
        [requestForm addPostValue:@"0" forKey:@"sex"];
        [requestForm addPostValue:birthStr forKey:@"birth"];
        [requestForm addPostValue:heightStr forKey:@"height"];
        [requestForm addPostValue:weightStr forKey:@"weight"];
        requestForm.delegate =self;
        [requestForm startAsynchronous];
   
    }
}
#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
   //  NSDictionary * dic = [[request responseString] JSONValue];
     NSLog(@"dic is %@ ,%@",dic,[dic objectForKey:@"msg"]);
    NSString * ret =[dic objectForKey:@"msg"];
    
    if (ret) {
        SportMainVC * ctl =[[SportMainVC alloc]init];
        [self.navigationController pushViewController:ctl animated:YES];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
