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

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = [self bounds];
    
    [self.peopleButton setBackgroundColor:[UIColor whiteColor]];
    [self.sportButton setBackgroundColor:RGBCOLOR(0, 175, 172)];

}



@end
