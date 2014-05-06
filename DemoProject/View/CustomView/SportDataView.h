//
//  SportDataView.h
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>

enum SportDataViewStatus {
    DataViewStatus_NonSync = 0,
    DataViewStatus_Sync,
    };

@interface SportDataView : UIView

@property(nonatomic, assign)NSInteger viewStatus;

//背景
@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;

//标题
@property (weak, nonatomic) IBOutlet UILabel *dataViewTitleLabel;

//公里
@property (weak, nonatomic) IBOutlet UIImageView *kmIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *kmTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *kmValueLabel;


//卡路里
@property (weak, nonatomic) IBOutlet UIImageView *calIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *calTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *calValueLabel;


//分钟
@property (weak, nonatomic) IBOutlet UIImageView *minIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *minTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *minValueLabel;


//次数
@property (weak, nonatomic) IBOutlet UIImageView *timesIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *timesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesValueLabel;

//步数
@property (weak, nonatomic) IBOutlet UIImageView *stepIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *stepTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepValueLabel;

@end
