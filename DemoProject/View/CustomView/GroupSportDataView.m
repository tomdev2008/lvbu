//
//  GroupSportDataView.m
//  DemoProject
//
//  Created by zzc on 14-5-14.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "GroupSportDataView.h"
#import "AppCore.h"

@implementation GroupSportDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{

    self.curShowDataType = GroupDataType_km;
    self.kmValue    = 0;
    self.calValue   = 0;
    self.speedValue = 0;
    self.paceValue  = @"00:00";
    
    
    [self setBackgroundColor:RGBCOLOR(240, 240, 240)];
    
    //KM
    [self.kmTitleLabel setTextColor:[UIColor colorWithHex:@"#808080"]];
    [self.kmValueLabel setTextColor:[UIColor colorWithHex:@"#08519d"]];
    
    //卡路里
    [self.calValueLabel setTextColor:[UIColor colorWithHex:@"#808080"]];

    //速度
    [self.speedValueLabel setTextColor:[UIColor colorWithHex:@"#808080"]];
    
    //配速
    [self.paceValueLabel setTextColor:[UIColor colorWithHex:@"#808080"]];
    
    
    //分割线
    [self.lineView1 setBackgroundColor:[UIColor blackColor]];
    [self.lineView2 setBackgroundColor:[UIColor blackColor]];
    [self.lineView3 setBackgroundColor:[UIColor blackColor]];
    
}



- (void)updateViewByKm:(CGFloat)kmVal
                   Cal:(NSInteger)calVal
                 Speed:(CGFloat)speedVal
                  Pace:(NSString *)paceVal
{
    self.kmValue    = kmVal;
    self.calValue   = calVal;
    self.speedValue = speedVal;
    self.paceValue  = [paceVal copy];
    
    
    switch (self.curShowDataType) {
        case GroupDataType_km:
        {
            [self onShowKM:nil];
            break;
        }
        case GroupDataType_cal:
        {
            [self onShowCal:nil];
            break;
        }
        case GroupDataType_speed:
        {
            [self onShowSpeed:nil];
            break;
        }
        case GroupDataType_pace:
        {
            [self onShowPace:nil];
            break;
        }
            
        default:
            break;
    }
    
}



- (IBAction)onShowKM:(id)sender
{
    self.curShowDataType = GroupDataType_km;
    
    //正常
    [self.kmImageView setImage:[UIImage imageNamed:@"SportData_distance_m"]];
    [self.kmTitleLabel setText:@"公里"];
    [self.kmValueLabel setText:[NSString stringWithFormat:@"%.2f", self.kmValue]];

    [self.calImageView setImage:[UIImage imageNamed:@"SportData_cal_m"]];
    [self.calValueLabel setText:[NSString stringWithFormat:@"%d", self.calValue]];
    
    
    [self.speedImageView setImage:[UIImage imageNamed:@"SportData_speed_m"]];
    [self.speedValueLabel setText:[NSString stringWithFormat:@"%.2f", self.speedValue]];
    
    [self.paceImageView setImage:[UIImage imageNamed:@"SportData_pace_m"]];
    [self.paceValueLabel setText:self.paceValue];
}

- (IBAction)onShowCal:(id)sender
{
    self.curShowDataType = GroupDataType_cal;
    
    //KM与卡路里互换
    [self.kmImageView setImage:[UIImage imageNamed:@"SportData_cal_m"]];
    [self.kmTitleLabel setText:@"卡路里"];
    [self.kmValueLabel setText:[NSString stringWithFormat:@"%d", self.calValue]];
    
    [self.calImageView setImage:[UIImage imageNamed:@"SportData_distance_m"]];
    [self.calValueLabel setText:[NSString stringWithFormat:@"%.2f", self.kmValue]];
    
    
    [self.speedImageView setImage:[UIImage imageNamed:@"SportData_speed_m"]];
    [self.speedValueLabel setText:[NSString stringWithFormat:@"%.2f", self.speedValue]];
    
    [self.paceImageView setImage:[UIImage imageNamed:@"SportData_pace_m"]];
    [self.paceValueLabel setText:self.paceValue];
}

- (IBAction)onShowSpeed:(id)sender
{
    self.curShowDataType = GroupDataType_speed;
    
    //KM与速度互换
    [self.kmImageView setImage:[UIImage imageNamed:@"SportData_speed_m"]];
    [self.kmTitleLabel setText:@"速度"];
    [self.kmValueLabel setText:[NSString stringWithFormat:@"%.2f", self.speedValue]];
    
    
    [self.calImageView setImage:[UIImage imageNamed:@"SportData_cal_m"]];
    [self.calValueLabel setText:[NSString stringWithFormat:@"%d", self.calValue]];
    
    
    [self.speedImageView setImage:[UIImage imageNamed:@"SportData_distance_m"]];
    [self.speedValueLabel setText:[NSString stringWithFormat:@"%.2f", self.kmValue]];
    
    [self.paceImageView setImage:[UIImage imageNamed:@"SportData_pace_m"]];
    [self.paceValueLabel setText:self.paceValue];
}

- (IBAction)onShowPace:(id)sender
{
    self.curShowDataType = GroupDataType_pace;
    
    //KM与配速互换
    [self.kmImageView setImage:[UIImage imageNamed:@"SportData_pace_m"]];
    [self.kmTitleLabel setText:@"配速"];
    [self.kmValueLabel setText:self.paceValue];
    
    [self.calImageView setImage:[UIImage imageNamed:@"SportData_cal_m"]];
    [self.calValueLabel setText:[NSString stringWithFormat:@"%d", self.calValue]];
    
    [self.speedImageView setImage:[UIImage imageNamed:@"SportData_speed_m"]];
    [self.speedValueLabel setText:[NSString stringWithFormat:@"%.2f", self.speedValue]];
    
    [self.paceImageView setImage:[UIImage imageNamed:@"SportData_distance_m"]];
    [self.paceValueLabel setText:[NSString stringWithFormat:@"%.2f", self.kmValue]];
}

@end
