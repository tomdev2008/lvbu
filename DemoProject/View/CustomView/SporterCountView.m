//
//  SporterCountView.m
//  DemoProject
//
//  Created by zzc on 14-5-15.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "SporterCountView.h"
#import "AppCore.h"

@implementation SporterCountView

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
    
    [self.friendCountLabel setTextColor:[UIColor colorWithHex:@"#404040"]];
    [self.friendTitleLabel setTextColor:[UIColor colorWithHex:@"#808080"]];
    
    [self.nearbyCountLabel setTextColor:[UIColor colorWithHex:@"#404040"]];
    [self.nearbyTitleLabel setTextColor:[UIColor colorWithHex:@"#808080"]];

    
}

- (void)updateViewbyFriendCount:(NSInteger)friendCount
                    NearbyCount:(NSInteger)nearbyCount
{
    self.friendCountLabel.text = [NSString stringWithFormat:@"%d", friendCount];
    self.nearbyCountLabel.text = [NSString stringWithFormat:@"%d", nearbyCount];
}

@end
