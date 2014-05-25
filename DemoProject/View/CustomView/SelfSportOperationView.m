//
//  SelfSporterView.m
//  DemoProject
//
//  Created by zzc on 14-5-14.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "SelfSportOperationView.h"
#import "AppCore.h"

@implementation SelfSportOperationView

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
    
    //设置按钮背景颜色，后面可以直接使用背景图。
    [self.pauseButton   setBackgroundColor:RGBCOLOR(0, 175, 172)];
    [self.stopButton    setBackgroundColor:RGBCOLOR(209, 39, 73)];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(onSwipe)];
    leftSwipe.numberOfTouchesRequired = 1;
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tipImageView addGestureRecognizer:leftSwipe];
    [self.tipImageView setUserInteractionEnabled:YES];
}

- (void)onSwipe
{

    CGRect pauseframe = CGRectMake(0, 0, 160, CGRectGetHeight(self.frame));
    CGRect stopframe = CGRectMake(160, 0, 160, CGRectGetHeight(self.frame));
    [UIView animateWithDuration:0.5f animations:^{

        [self.pauseButton setFrame:pauseframe];
        [self.stopButton setFrame:stopframe];
        
    } completion:^(BOOL finished) {
        [self.tipImageView setHidden:YES];
    }];
  
}

@end
