//
//  SporterView.m
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "SporterView.h"

@implementation SporterView

- (id)initWithFrame:(CGRect)frame  SportViewType:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.viewType = type;
        switch (type) {
            case SportViewType_friend:
            {
                [self.descLabel setText:@"正在运动的好友"];
                break;
            }
            case SportViewType_nearby:
            {
                [self.descLabel setText:@"附近运动的人"];
                break;
            }
            default:
                break;
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = [self bounds];
    self.selectButton.frame = frame;
 
}

- (void)setPersonCount:(NSInteger)count
{
    [self.countLabel setText:[NSString stringWithFormat:@"%d", count]];
}


@end
