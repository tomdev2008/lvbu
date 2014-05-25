//
//  GroupSportDataView.h
//  DemoProject
//
//  Created by zzc on 14-5-14.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>


enum CurrentShowGroupDataType {
    GroupDataType_km = 0,
    GroupDataType_cal,
    GroupDataType_speed,
    GroupDataType_pace,
};


@interface GroupSportDataView : UIView


@property(assign, nonatomic)NSInteger curShowDataType;  //当前显示的数据类型
@property(assign, nonatomic)CGFloat kmValue;
@property(assign, nonatomic)NSInteger calValue;
@property(assign, nonatomic)CGFloat speedValue;
@property(copy, nonatomic)NSString *paceValue;

//KM
@property (weak, nonatomic) IBOutlet UIImageView *kmImageView;
@property (weak, nonatomic) IBOutlet UILabel *kmTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *kmValueLabel;

//卡路里
@property (weak, nonatomic) IBOutlet UIImageView *calImageView;
@property (weak, nonatomic) IBOutlet UILabel *calValueLabel;

//速度
@property (weak, nonatomic) IBOutlet UIImageView *speedImageView;
@property (weak, nonatomic) IBOutlet UILabel *speedValueLabel;

//配速
@property (weak, nonatomic) IBOutlet UIImageView *paceImageView;
@property (weak, nonatomic) IBOutlet UILabel *paceValueLabel;


@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;


@property (weak, nonatomic) IBOutlet UIButton *kmButton;
@property (weak, nonatomic) IBOutlet UIButton *calButton;
@property (weak, nonatomic) IBOutlet UIButton *speedButton;
@property (weak, nonatomic) IBOutlet UIButton *paceButton;


- (IBAction)onShowKM:(id)sender;
- (IBAction)onShowCal:(id)sender;
- (IBAction)onShowSpeed:(id)sender;
- (IBAction)onShowPace:(id)sender;

@end
