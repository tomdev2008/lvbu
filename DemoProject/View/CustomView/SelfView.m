//
//  selfView.m
//  DemoProject
//
//  Created by zzc on 14-5-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "SelfView.h"
#import "AppCore.h"

@implementation SelfView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        @property(nonatomic, strong)SelfSportDataView *selfDataView;
//        @property(nonatomic, strong)SporterCountView *countView;
//        @property(nonatomic, strong)SporterInfoView *sporterView;
//        @property(nonatomic, strong)SelfSportOperationView *operationView;
       
        
        CGRect bounds = CGRectZero;
        CGRect viewFrame = CGRectZero;
        
        self.sportDataView = [ViewFactory createSelfSportDataView];
        bounds      = [self.sportDataView bounds];

        viewFrame   = CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.sportDataView.frame = viewFrame;
        [self addSubview:self.sportDataView];
        NSLog(@"sportDataView.frame = %@", NSStringFromCGRect(self.sportDataView.frame));
        
        
        self.countView = [ViewFactory createSporterCountView];
        bounds      = [self.countView bounds];
        viewFrame   = CGRectMake(0, CGRectGetHeight(frame) - 200, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.countView.frame = viewFrame;
        [self addSubview:self.countView];
        NSLog(@"countView.frame = %@", NSStringFromCGRect(self.countView.frame));
        
        //运动人数上面的线条
        CGRect lineFrame1 = viewFrame;
        lineFrame1.size.height = 1;
        self.lineView1 = [[UIView alloc] initWithFrame:lineFrame1];
        [self.lineView1 setBackgroundColor:RGBCOLOR(192, 192, 192)];
        [self addSubview:self.lineView1];
        

        
        
        self.sporterView = [ViewFactory createSporterInfoView];
        bounds      = [self.sporterView bounds];
        viewFrame   = CGRectMake(0, CGRectGetHeight(frame) - 140, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.sporterView.frame = viewFrame;
        [self addSubview:self.sporterView];
        NSLog(@"sporterView.frame = %@", NSStringFromCGRect(self.sporterView.frame));
        
        
        [self.sporterView.addButton addTarget:self
                                       action:@selector(onAdd)
                             forControlEvents:UIControlEventTouchUpInside];
        
        [self.sporterView.inviteButton addTarget:self
                                          action:@selector(onInvite)
                                forControlEvents:UIControlEventTouchUpInside];
        
        
        //运动人数下面的线条
        CGRect lineFrame2 = CGRectMake(15, CGRectGetHeight(frame) - 140, 290, 1);
        self.lineView2 = [[UIView alloc] initWithFrame:lineFrame2];
        [self.lineView2 setBackgroundColor:RGBCOLOR(190, 190, 190)];
        [self addSubview:self.lineView2];
    
        
        self.operationView = [ViewFactory createSelfSportOperationView];
        bounds      = [self.operationView bounds];
        viewFrame   = CGRectMake(0, CGRectGetHeight(frame) - 65, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.operationView.frame = viewFrame;
        [self addSubview:self.operationView];
        NSLog(@"operationView.frame = %@", NSStringFromCGRect(self.operationView.frame));
        
        
        [self.operationView.pauseButton addTarget:self
                                           action:@selector(onPause)
                                 forControlEvents:UIControlEventTouchUpInside];
        
        [self.operationView.stopButton addTarget:self
                                          action:@selector(onStop)
                                forControlEvents:UIControlEventTouchUpInside];
        

    }
    return self;
}

- (void)layoutSubviews
{
    
}




- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.isHidden) {
       return [super hitTest:point withEvent:event];
    }
    
    CGPoint pointAt = [self.sportDataView convertPoint:point fromView:self];
    if (!(self.sportDataView.hidden) && [self.sportDataView pointInside:pointAt withEvent:event]) {
        
        return [self.sportDataView hitTest:point withEvent:event];
    }
    
    pointAt = [self.countView convertPoint:point fromView:self];
    if (!(self.countView.hidden) && [self.countView pointInside:pointAt withEvent:event]) {
        
        return [super hitTest:point withEvent:event];
    }
    
    pointAt = [self.sporterView convertPoint:point fromView:self];
    if (!(self.sporterView.hidden) && [self.sporterView pointInside:pointAt withEvent:event]) {
        
        return [super hitTest:point withEvent:event];
    }
    
    pointAt = [self.operationView convertPoint:point fromView:self];
    if (!(self.operationView.hidden) && [self.operationView pointInside:pointAt withEvent:event]) {
        
        return [super hitTest:point withEvent:event];
    }
    
    return [self.backMapView hitTest:point withEvent:event];
}


- (void)onAdd
{
    NSLog(@"onAdd");
    if ([self.delegate respondsToSelector:@selector(onAdd:)]) {
        [self.delegate onAdd:1001];
    }
}

- (void)onInvite
{
    NSLog(@"onInvite");
    if ([self.delegate respondsToSelector:@selector(onInvite:)]) {
        [self.delegate onInvite:1001];
    }
}

- (void)onPause
{
    NSLog(@"pause sport");
    if ([self.delegate respondsToSelector:@selector(pauseSport)]) {
        [self.delegate pauseSport];
        
    }
}


- (void)onStop
{
    NSLog(@"stop sport");
    if ([self.delegate respondsToSelector:@selector(stopSport)]) {
        [self.delegate stopSport];
        
    }
}


@end
