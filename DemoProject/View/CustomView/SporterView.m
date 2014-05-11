//
//  SporterView.m
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "SporterView.h"
#import "AppCore.h"

@implementation SporterView

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

- (void)updateViewWithParter:(NSInteger)parterCount  Nearby:(NSInteger)nearbyCount
{
    [self.friendCountLabel setText:[NSString stringWithFormat:@"%d", parterCount]];
    [self.nearbyCountLabel setText:[NSString stringWithFormat:@"%d", nearbyCount]];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = [self bounds];

    [self.sportButton setBackgroundColor:RGBCOLOR(0, 175, 172)];
    
    switch (self.curViewStatus) {
        case ViewStatus_nonRequest:
        {
            [self hidePeople];
            [self setBackgroundColor:[UIColor clearColor]];
            break;
        }
        case ViewStatus_Requested:
        {
            [self showPeople];
            [self setBackgroundColor:[UIColor whiteColor]];
            break;
        }
        default:
            break;
    }
}


- (void)hidePeople
{
    [self.peopleButton setHidden:YES];
    [self.friendTitleLabel setHidden:YES];
    [self.friendImgView setHidden:YES];
    [self.friendCountLabel setHidden:YES];
    
    [self.nearbyTitleLabel setHidden:YES];
    [self.nearbyImgView setHidden:YES];
    [self.nearbyCountLabel setHidden:YES];
}

- (void)showPeople
{
    [self.peopleButton setHidden:NO];
    [self.friendTitleLabel setHidden:NO];
    [self.friendImgView setHidden:NO];
    [self.friendCountLabel setHidden:NO];
    
    [self.nearbyTitleLabel setHidden:NO];
    [self.nearbyImgView setHidden:NO];
    [self.nearbyCountLabel setHidden:NO];
}

@end
