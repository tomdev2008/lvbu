//
//  TextMessageView.m
//  DemoProject
//
//  Created by zzc on 14-5-12.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "TextMessageView.h"

@implementation TextMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return NO;
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

- (void)dealloc {
    
}

@end
