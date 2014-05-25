//
//  SelfSportDataView.h
//  DemoProject
//
//  Created by zzc on 14-5-14.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>

enum CurrentShowDataType {
    DataType_km = 0,
    DataType_cal,
    DataType_time,
    DataType_step,
    };

@interface SelfSportDataView : UIView


@property(assign, nonatomic)NSInteger curShowDataType;  //当前显示的数据类型
@property(assign, nonatomic)CGFloat kmValue;
@property(assign, nonatomic)NSInteger calValue;
@property(assign, nonatomic)NSInteger stepValue;
@property(assign, nonatomic)CGFloat speedValue;
@property(copy, nonatomic)NSString *timeValue;
@property(copy, nonatomic)NSString *paceValue;


//KM
@property (weak, nonatomic) IBOutlet UIImageView *kmImageView;
@property (weak, nonatomic) IBOutlet UILabel *kmTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *kmValueLabel;

//卡路里
@property (weak, nonatomic) IBOutlet UIImageView *calImageView;
@property (weak, nonatomic) IBOutlet UILabel *calValueLabel;


//时间
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeValueLabel;


//步数
@property (weak, nonatomic) IBOutlet UIImageView *stepImageView;
@property (weak, nonatomic) IBOutlet UILabel *stepValueLabel;


//速度
@property (weak, nonatomic) IBOutlet UIImageView *speedImageView;
@property (weak, nonatomic) IBOutlet UILabel *speedValueLabel;


//配速度
@property (weak, nonatomic) IBOutlet UIImageView *paceImageView;
@property (weak, nonatomic) IBOutlet UILabel *paceValueLabel;

//5条分割线
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;
@property (weak, nonatomic) IBOutlet UIView *lineView4;
@property (weak, nonatomic) IBOutlet UIView *lineView5;

//3个按钮
@property (weak, nonatomic) IBOutlet UIButton *kmButton;
@property (weak, nonatomic) IBOutlet UIButton *calButton;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIButton *stepButton;

- (IBAction)onShowKm:(id)sender;
- (IBAction)onShowCal:(id)sender;
- (IBAction)onShowStep:(id)sender;
- (IBAction)onShowTime:(id)sender;


- (void)updateViewByKm:(CGFloat)kmVal
                   Cal:(NSInteger)calVal
                  Time:(NSString *)timVal
                  Step:(NSInteger)stepVal
                 Speed:(CGFloat)speedVal
                  Pace:(NSString *)paceVal;



@end
