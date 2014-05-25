//
//  SelfSportDataView.m
//  DemoProject
//
//  Created by zzc on 14-5-14.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "SelfSportDataView.h"
#import "AppCore.h"

@implementation SelfSportDataView

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

    
    self.curShowDataType = DataType_km;
    self.kmValue    = 0;
    self.calValue   = 0;
    self.stepValue  = 0;
    self.timeValue  = @"00:00";
    self.speedValue = 0;
    self.paceValue  = @"00:00";
    
    [self setBackgroundColor:RGBCOLOR(240, 240, 240)];
    
    //设置文本颜色
    [self.kmTitleLabel setTextColor:[UIColor colorWithHex:@"#808080"]];
    [self.kmValueLabel setTextColor:[UIColor colorWithHex:@"#08519d"]];
    [self.calValueLabel     setTextColor:[UIColor colorWithHex:@"#808080"]];
    [self.timeValueLabel    setTextColor:[UIColor colorWithHex:@"#808080"]];
    [self.stepValueLabel    setTextColor:[UIColor colorWithHex:@"#808080"]];
    [self.speedValueLabel   setTextColor:[UIColor colorWithHex:@"#808080"]];
    [self.paceValueLabel    setTextColor:[UIColor colorWithHex:@"#808080"]];
    
    //设置分割线颜色
    [self.lineView1 setBackgroundColor:RGBCOLOR(192, 192, 192)];
    [self.lineView2 setBackgroundColor:RGBCOLOR(192, 192, 192)];
    [self.lineView3 setBackgroundColor:RGBCOLOR(192, 192, 192)];
    [self.lineView4 setBackgroundColor:RGBCOLOR(182, 182, 182)];
    [self.lineView5 setBackgroundColor:RGBCOLOR(215, 215, 215)];
}



- (void)updateViewByKm:(CGFloat)kmVal
                   Cal:(NSInteger)calVal
                  Time:(NSString *)timVal
                  Step:(NSInteger)stepVal
                 Speed:(CGFloat)speedVal
                  Pace:(NSString *)paceVal
{
    self.kmValue    = kmVal;
    self.calValue   = calVal;
    self.timeValue  = [timVal copy];
    self.stepValue  = stepVal;
    self.speedValue = speedVal;
    self.paceValue  = [paceVal copy];
    
    switch (self.curShowDataType) {
        case DataType_km:
        {
            [self onShowKm:nil];
            break;
        }
        case DataType_cal:
        {
            [self onShowCal:nil];
            break;
        }
        case DataType_time:
        {
            [self onShowTime:nil];
            break;
        }
        case DataType_step:
        {
            [self onShowStep:nil];
            break;
        }
            
        default:
            break;
    }
    
}


- (IBAction)onShowKm:(id)sender
{
    self.curShowDataType = DataType_km;
    
    [self.kmImageView setImage:[UIImage imageNamed:@"SportData_distance_m"]];
    [self.kmTitleLabel setText:@"公里"];
    [self.kmValueLabel setText:[NSString stringWithFormat:@"%.2f", self.kmValue]];
    
    
    [self.calImageView setImage:[UIImage imageNamed:@"SportData_cal_m"]];
    [self.calValueLabel setText:[NSString stringWithFormat:@"%d", self.calValue]];
    

    [self.timeImageView setImage:[UIImage imageNamed:@"SportData_time_m"]];
    [self.timeValueLabel setText:self.timeValue];
    
    
    [self.stepImageView setImage:[UIImage imageNamed:@"SportData_step_m"]];
    [self.stepValueLabel setText:[NSString stringWithFormat:@"%d", self.stepValue]];
    
    
    [self.speedImageView setImage:[UIImage imageNamed:@"SportData_speed_m"]];
    [self.speedValueLabel setText:[NSString stringWithFormat:@"%.2f", self.speedValue]];
    
    [self.paceImageView setImage:[UIImage imageNamed:@"SportData_pace_m"]];
    [self.paceValueLabel setText:self.paceValue];
}

- (IBAction)onShowCal:(id)sender
{
    
    [self onShowKm:nil];

    self.curShowDataType = DataType_cal;
    
    //KM和卡路里互换
    [self.kmImageView setImage:[UIImage imageNamed:@"SportData_cal_m"]];
    [self.kmTitleLabel setText:@"卡路里"];
    [self.kmValueLabel setText:[NSString stringWithFormat:@"%d", self.calValue]];
    
    [self.calImageView setImage:[UIImage imageNamed:@"SportData_distance_m"]];
    [self.calValueLabel setText:[NSString stringWithFormat:@"%.2f", self.kmValue]];

}



- (IBAction)onShowTime:(id)sender
{
    [self onShowKm:nil];
    self.curShowDataType = DataType_time;
    
    //KM和时间互换
    [self.kmImageView setImage:[UIImage imageNamed:@"SportData_time_m"]];
    [self.kmTitleLabel setText:@"时间"];
    [self.kmValueLabel setText:self.timeValue];

    [self.timeImageView setImage:[UIImage imageNamed:@"SportData_distance_m"]];
    [self.timeValueLabel setText:[NSString stringWithFormat:@"%.2f", self.kmValue]];

}

- (IBAction)onShowStep:(id)sender
{
    [self onShowKm:nil];
    self.curShowDataType = DataType_step;
 
    //KM和步数互换
    [self.kmImageView setImage:[UIImage imageNamed:@"SportData_step_m"]];
    [self.kmTitleLabel setText:@"步数"];
    [self.kmValueLabel setText:[NSString stringWithFormat:@"%d", self.stepValue]];

    [self.stepImageView setImage:[UIImage imageNamed:@"SportData_distance_m"]];
    [self.stepValueLabel setText:[NSString stringWithFormat:@"%.2f", self.kmValue]];
}

@end
