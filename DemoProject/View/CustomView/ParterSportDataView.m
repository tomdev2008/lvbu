//
//  ParterDetailSportDataView.m
//  DemoProject
//
//  Created by zzc on 14-5-14.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "ParterSportDataView.h"
#import "AppCore.h"

@implementation ParterSportDataView

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
    [self setBackgroundColor:RGBCOLOR(240, 240, 240)];
    
    //KM
    [self.kmTitleLabel setTextColor:[UIColor colorWithHex:@"#808080"]];
    [self.kmValueLabel setTextColor:[UIColor colorWithHex:@"#08519d"]];
    //卡路里
    [self.calTitleLabel setTextColor:[UIColor colorWithHex:@"#808080"]];
    [self.calValueLabel setTextColor:[UIColor colorWithHex:@"#08519d"]];
    
    [self.timeValueLabel setTextColor:[UIColor colorWithHex:@"#808080"]];
    [self.stepValueLabel setTextColor:[UIColor colorWithHex:@"#808080"]];
    [self.speedValueLabel setTextColor:[UIColor colorWithHex:@"#808080"]];
    
    //分割线
    [self.lineView1 setBackgroundColor:[UIColor blackColor]];
    [self.lineView2 setBackgroundColor:[UIColor blackColor]];
}


- (void)setCurViewStatus:(NSInteger)curViewStatus
{
    _curViewStatus = curViewStatus;
    [self setNeedsLayout];
}


- (void)updateViewkmValue:(CGFloat)km
                 calValue:(NSInteger)cal
                timeValue:(NSString *)time
                stepValue:(NSInteger)step
               speedValue:(CGFloat)speed
{
    self.kmValueLabel.text = [NSString stringWithFormat:@"%.3f", km];
    self.calValueLabel.text = [NSString stringWithFormat:@"%d", cal];
    self.timeValueLabel.text = [NSString stringWithFormat:@"%@", time];
    self.stepValueLabel.text = [NSString stringWithFormat:@"%d", step];
    self.speedValueLabel.text = [NSString stringWithFormat:@"%.2f", speed];
    
}

- (void)layoutSubviews
{
    switch (self.curViewStatus) {
        case InfoViewStatus_simple:
        {
            //简单
            [self.timeImageView setHidden:YES];
            [self.timeValueLabel setHidden:YES];
            
            [self.stepImageView setHidden:YES];
            [self.stepValueLabel setHidden:YES];
            
            [self.speedImageView setHidden:YES];
            [self.speedValueLabel setHidden:YES];
            
            [self.lineView1 setHidden:YES];
            [self.lineView2 setHidden:YES];
            
            break;
        }
        case InfoViewStatus_detail:
        {
            //详细
            [self.timeImageView setHidden:NO];
            [self.timeValueLabel setHidden:NO];
            
            [self.stepImageView setHidden:NO];
            [self.stepValueLabel setHidden:NO];
            
            [self.speedImageView setHidden:NO];
            [self.speedValueLabel setHidden:NO];
            
            [self.lineView1 setHidden:NO];
            [self.lineView2 setHidden:NO];
            
            break;
        }
        default:
            break;
    }
}


@end
