//
//  SportDataView.m
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "SportDataView.h"


@implementation SportDataView

- (id)initWithFrame:(CGRect)frame  DataViewType:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = type;
        switch (type) {
            case DataViewType_km:
            {
                [self.descLabel setText:@"公里"];
                break;
            }
            case DataViewType_cal:
            {
                [self.descLabel setText:@"卡路里"];
                break;
            }
            case DataViewType_step:
            {
                [self.descLabel setText:@"步数"];
                break;
            }
            default:
                break;
        }
        
        [self.selectButton  setBackgroundColor:[UIColor clearColor]];
        [self.todayLabel setBackgroundColor:[UIColor clearColor]];
        [self.totalLabel setBackgroundColor:[UIColor clearColor]];
        [self.descLabel setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = [self bounds];
    self.selectButton.frame = frame;
    self.todayLabel.frame   = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)/2);
    self.totalLabel.frame   = CGRectMake(0, CGRectGetHeight(frame)/2,  CGRectGetWidth(frame), CGRectGetHeight(frame)/3);
    self.descLabel.frame    = CGRectMake(0, CGRectGetHeight(frame)*5/6,  CGRectGetWidth(frame), CGRectGetHeight(frame)/6);
}



- (void)setToday:(NSInteger)today Total:(NSInteger)total
{
    [self.todayLabel setText:[NSString stringWithFormat:@"%d", today]];
    [self.totalLabel setText:[NSString stringWithFormat:@"%d", total]];
}


@end
