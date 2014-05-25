//
//  GroupView.m
//  DemoProject
//
//  Created by zzc on 14-5-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "GroupView.h"

@implementation GroupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.mySportDataView = [ViewFactory createGroupSportDataView];
        [self addSubview:self.mySportDataView];
        
        self.msgTableView = nil;
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
    if (self.msgTableView != nil) {
        [self.msgTableView removeFromSuperview];
        self.msgTableView.frame = CGRectMake(0, 300, 320, CGRectGetHeight(self.frame) - 300);
        [self addSubview:self.msgTableView];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    if (self.isHidden) {
      return  [super hitTest:point withEvent:event];
    }
    
    CGPoint pointAt = [self.mySportDataView convertPoint:point fromView:self];
    if (!(self.mySportDataView.hidden) && [self.mySportDataView pointInside:pointAt withEvent:event]) {
        return [self.mySportDataView hitTest:point withEvent:event];
    }
    
    pointAt = [self.msgTableView convertPoint:point fromView:self];
    if (!(self.msgTableView.hidden) && [self.msgTableView pointInside:pointAt withEvent:event]) {
        return [super hitTest:point withEvent:event];
    }
    
    return [self.backMapView hitTest:point withEvent:event];
}


@end
