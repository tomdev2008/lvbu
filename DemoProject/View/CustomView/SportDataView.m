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



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = [self bounds];
    if (isIP5Screen) {

        [self.backgroundButton setFrame:frame];
        [self.dataViewTitleLabel setFrame:CGRectMake(0, 0, 320, 40)];
        
        /*********************************************************
        //公里
        [self.kmIconImgView setFrame:CGRectMake(, , , )];
        [self.kmTitleLabel setFrame:CGRectMake(, , , )];
        [self.kmValueLabel setFrame:CGRectMake(, , , )];
        
        //卡路里
        [self.calIconImgView setFrame:CGRectMake(, , , )];
        [self.calTitleLabel setFrame:CGRectMake(, , , )];
        [self.calValueLabel setFrame:CGRectMake(, , , )];

        
        switch (self.viewStatus) {
            case DataViewStatus_NonSync:
            {
                //未同步数据
                
                //分钟
                [self.minIconImgView setFrame:CGRectMake(, , , )];
                [self.minTitleLabel setFrame:CGRectMake(, , , )];
                [self.minValueLabel setFrame:CGRectMake(, , , )];
                
                
                //次数
                [self.timesIconImgView setFrame:CGRectMake(, , , )];
                [self.timesTitleLabel setFrame:CGRectMake(, , , )];
                [self.timesValueLabel setFrame:CGRectMake(, , , )];
                
                //步数
                [self.stepIconImgView setFrame:CGRectMake(, , , )];
                [self.stepTitleLabel setFrame:CGRectMake(, , , )];
                [self.stepValueLabel setFrame:CGRectMake(, , , )];
                break;
            }
            case DataViewStatus_Sync:
            {
                //同步数据
                
                //分钟
                [self.minIconImgView setFrame:CGRectMake(, , , )];
                [self.minTitleLabel setFrame:CGRectMake(, , , )];
                [self.minValueLabel setFrame:CGRectMake(, , , )];
                
                
                //次数
                [self.timesIconImgView setFrame:CGRectMake(, , , )];
                [self.timesTitleLabel setFrame:CGRectMake(, , , )];
                [self.timesValueLabel setFrame:CGRectMake(, , , )];
                
                //步数
                [self.stepIconImgView setFrame:CGRectMake(, , , )];
                [self.stepTitleLabel setFrame:CGRectMake(, , , )];
                [self.stepValueLabel setFrame:CGRectMake(, , , )];
                break;
            }
            default:
                break;
        }
         
           *********************************************************/
        
    } else {
        
    }
 

}





@end
