//
//  ParterDetailSportDataView.h
//  DemoProject
//
//  Created by zzc on 14-5-14.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>


enum InfoViewStatus {
    InfoViewStatus_simple = 0,
    InfoViewStatus_detail,
};

@interface ParterSportDataView : UIView
{
    NSInteger _curViewStatus;
}

@property(assign, nonatomic) NSInteger curViewStatus;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

//KM
@property (weak, nonatomic) IBOutlet UIImageView *kmImageView;
@property (weak, nonatomic) IBOutlet UILabel *kmTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *kmValueLabel;

//卡路里
@property (weak, nonatomic) IBOutlet UIImageView *calImageView;
@property (weak, nonatomic) IBOutlet UILabel *calTitleLabel;
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


@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;


- (void)updateViewkmValue:(CGFloat)km
                 calValue:(NSInteger)cal
                timeValue:(NSString *)time
                stepValue:(NSInteger)step
               speedValue:(CGFloat)speed;

@end
