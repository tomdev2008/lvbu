//
//  SportDataView.m
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "SportDataView.h"
#import "AppCore.h"


@implementation SportDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        
    }
    return self;
}

- (void)setCurViewStatus:(NSInteger)status
{
    _curViewStatus = status;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = [self bounds];
    if (isIP5Screen) {

        [self.backgroundButton setFrame:frame];
        [self.dataViewTitleLabel setFrame:CGRectMake(0, 0, 320, 40)];

        //公里
        CGRect iconImgFrame = CGRectMake(50, 48, 25, 25);
        CGRect titleFrame   = CGRectMake(78, 52, 80, 21);
        CGRect valueFrame   = CGRectMake(0, 74, 160, 40);
        [self.kmIconImgView setFrame:iconImgFrame];
        [self.kmTitleLabel setFrame:titleFrame];
        [self.kmValueLabel setFrame:valueFrame];
        
        //卡路里
        iconImgFrame.origin.x = 200;
        titleFrame.origin.x = 225;
        valueFrame.origin.x = 160;
        
        [self.calIconImgView setFrame:iconImgFrame];
        [self.calTitleLabel setFrame:titleFrame];
        [self.calValueLabel setFrame:valueFrame];

        
        switch (self.curViewStatus) {
            case DataViewStatus_NonSync:
            {
                //未同步数据
                //分钟
                iconImgFrame = CGRectMake(26, 145, 25, 25);
                titleFrame   = CGRectMake(50, 148, 60, 21);
                valueFrame   = CGRectMake(0, 168, 106, 42);
                [self.minIconImgView setFrame:iconImgFrame];
                [self.minTitleLabel setFrame:titleFrame];
                [self.minValueLabel setFrame:valueFrame];

                //次数
                iconImgFrame.origin.x = 122;
                titleFrame.origin.x = 145;
                valueFrame.origin.x = 107;
                [self.timesIconImgView setFrame:iconImgFrame];
                [self.timesTitleLabel setFrame:titleFrame];
                [self.timesValueLabel setFrame:valueFrame];
                
                //步数
                [self.stepIconImgView setHidden:NO];
                [self.stepTitleLabel setHidden:NO];
                [self.stepValueLabel setHidden:NO];
                iconImgFrame.origin.x = 218;
                titleFrame.origin.x = 244;
                valueFrame.origin.x = 200;
                [self.stepIconImgView setFrame:iconImgFrame];
                [self.stepTitleLabel setFrame:titleFrame];
                [self.stepValueLabel setFrame:valueFrame];
                break;
            }
            case DataViewStatus_Sync:
            {
                //同步数据
                //分钟
                iconImgFrame = CGRectMake(50, 145, 25, 25);
                titleFrame   = CGRectMake(78, 148, 80, 21);
                valueFrame   = CGRectMake(0, 168, 160, 40);
                [self.minIconImgView setFrame:iconImgFrame];
                [self.minTitleLabel setFrame:titleFrame];
                [self.minValueLabel setFrame:valueFrame];
                
                
                //次数
                iconImgFrame.origin.x = 200;
                titleFrame.origin.x = 225;
                valueFrame.origin.x = 160;
                [self.timesIconImgView setFrame:iconImgFrame];
                [self.timesTitleLabel setFrame:titleFrame];
                [self.timesValueLabel setFrame:valueFrame];
                
                //步数
                [self.stepIconImgView setHidden:YES];
                [self.stepTitleLabel setHidden:YES];
                [self.stepValueLabel setHidden:YES];
                break;
            }
            default:
                break;
        }
        
    } else {
        
    }
 

}





@end
