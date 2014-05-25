//
//  PartnerView.m
//  DemoProject
//
//  Created by zzc on 14-5-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "PartnerView.h"

@implementation PartnerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        self.curViewStatus = ViewStatus_SportView_noPartner;
        
        CGRect bounds = CGRectZero;
        CGRect viewFrame = CGRectZero;

        /***********************没有跑伴*****************************************/
        self.tipLabel = [UIFactory createLabelWith:CGRectMake(30, 10, 260, 60)
                                              text:@"当前没有人陪你跑步哦~"
                                              font:[UIFont systemFontOfSize:18]
                                         textColor:[UIColor whiteColor]
                                   backgroundColor:RGBACOLOR(0, 0, 0, 0.4)];
        [self.tipLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.tipLabel];
        
        
        self.countView = [ViewFactory createSporterCountView];
        bounds      = [self.countView bounds];
        viewFrame   = CGRectMake(0, CGRectGetHeight(frame) - 210, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.countView.frame = viewFrame;
        [self addSubview:self.countView];
        
        self.sporter1InfoView = [ViewFactory createSporterInfoView];
        bounds      = [self.sporter1InfoView bounds];
        viewFrame   = CGRectMake(0, CGRectGetHeight(frame) - 150, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.sporter1InfoView.frame = viewFrame;
        [self addSubview:self.sporter1InfoView];
        
        self.sporter2InfoView = [ViewFactory createSporterInfoView];
        bounds      = [self.sporter2InfoView bounds];
        viewFrame   = CGRectMake(0, CGRectGetHeight(frame) - 75, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.sporter2InfoView.frame = viewFrame;
        [self addSubview:self.sporter2InfoView];
        
        /*************************正在邀跑***************************************/
        self.partnerCell = [CellFactory createPartnerCell];
        [self addSubview:self.partnerCell];
        

        /**************************跑步中**************************************/
        self.partnerSportDataView = [ViewFactory createParterSportDataView];
        bounds      = [self.partnerSportDataView bounds];
        viewFrame   = CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.partnerSportDataView.curViewStatus = InfoViewStatus_detail;
        self.partnerSportDataView.frame = viewFrame;
        [self addSubview:self.partnerSportDataView];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(viewFrame)-1, 320, 1)];
        [self.lineView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:self.lineView];
        
        self.mySportDataView = [ViewFactory createParterSportDataView];
        bounds      = [self.mySportDataView bounds];
        viewFrame   = CGRectMake(0, CGRectGetHeight(bounds), CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.mySportDataView.curViewStatus = InfoViewStatus_detail;
        self.mySportDataView.frame = viewFrame;
        [self addSubview:self.mySportDataView];
        
        self.msgTableView = nil;
    }
    return self;
}


- (void)hideAllView
{
     //没有跑伴
    [self.tipLabel setHidden:YES];
    [self.countView setHidden:YES];
    [self.sporter1InfoView setHidden:YES];
    [self.sporter2InfoView setHidden:YES];
    
    //正在邀跑
    [self.partnerCell setHidden:YES];
    
    //已经跑步中
    [self.partnerSportDataView setHidden:YES];
    [self.mySportDataView setHidden:YES];
    [self.lineView setHidden:YES];


}

- (void)showNoPartnerView
{
    [self hideAllView];
    [self.tipLabel setHidden:NO];
    [self.countView setHidden:NO];
    [self.sporter1InfoView setHidden:NO];
    [self.sporter2InfoView setHidden:NO];

}


- (void)showInvitingPartnerView
{
    //正在邀请
    [self hideAllView];
    [self.partnerCell setHidden:NO];
}

- (void)showSimpleDataView
{
    [self hideAllView];
    self.partnerSportDataView.curViewStatus = InfoViewStatus_simple;
    self.mySportDataView.curViewStatus = InfoViewStatus_simple;
    
    CGRect frame = CGRectMake(0, 0, 320, 54);
    [self.partnerSportDataView setHidden:NO];
    [self.partnerSportDataView setFrame:frame];
    
    CGRect lineFrame = CGRectMake(0, 53, 320, 1);
    [self.lineView setHidden:NO];
    [self.lineView setFrame:lineFrame];
    
    frame.origin.y = 54;
    [self.mySportDataView setHidden:NO];
    [self.mySportDataView setFrame:frame];

}

- (void)showDetailDataView
{
    [self hideAllView];
    self.partnerSportDataView.curViewStatus = InfoViewStatus_detail;
    self.mySportDataView.curViewStatus = InfoViewStatus_detail;
    
    CGRect frame = CGRectMake(0, 0, 320, 92);
    [self.partnerSportDataView setHidden:NO];
    [self.partnerSportDataView setFrame:frame];
    
    CGRect lineFrame = CGRectMake(0, 91, 320, 1);
    [self.lineView setHidden:NO];
    [self.lineView setFrame:lineFrame];
    
    frame.origin.y = 92;
    [self.mySportDataView setHidden:NO];
    [self.mySportDataView setFrame:frame];
}


- (void)setCurViewStatus:(NSInteger)curViewStatus
{
    _curViewStatus = curViewStatus;
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    switch (self.curViewStatus) {
        case ViewStatus_SportView_noPartner:
        {
            //没有跑伴
            [self showNoPartnerView];
            break;
        }
            
        case ViewStatus_SportView_inviting:
        {
            //正在邀请
            [self showInvitingPartnerView];
            break;
        }
        case ViewStatus_SportView_simple:
        {
            //简单运动数据
            [self showSimpleDataView];
            break;
        }
        case ViewStatus_SportView_detail:
        {
            //详细运动数据
            [self showDetailDataView];
            break;
        }
        default:
            break;
    }

}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{

    if (self.isHidden) {
       return [super hitTest:point withEvent:event];
    }
    
    CGPoint pointAt = [self.tipLabel convertPoint:point fromView:self];
    if (!(self.tipLabel.hidden) && [self.tipLabel pointInside:pointAt withEvent:event]) {
        return [self.tipLabel hitTest:point withEvent:event];
    }
    
    pointAt = [self.countView convertPoint:point fromView:self];
    if (!(self.countView.hidden) && [self.countView pointInside:pointAt withEvent:event]) {
        return [super hitTest:point withEvent:event];
    }
    
    pointAt = [self.sporter1InfoView convertPoint:point fromView:self];
    if (!(self.sporter1InfoView.hidden) && [self.sporter1InfoView pointInside:pointAt withEvent:event]) {
        
        return [super hitTest:point withEvent:event];
    }
    
    pointAt = [self.sporter2InfoView convertPoint:point fromView:self];
    if (!(self.sporter2InfoView.hidden) && [self.sporter2InfoView pointInside:pointAt withEvent:event]) {
        
        return [super hitTest:point withEvent:event];
    }
    
    pointAt = [self.partnerCell convertPoint:point fromView:self];
    if (!(self.partnerCell.hidden) && [self.partnerCell pointInside:pointAt withEvent:event]) {
        
        return [super hitTest:point withEvent:event];
    }
    
    
    pointAt = [self.partnerSportDataView convertPoint:point fromView:self];
    if (!(self.partnerSportDataView.hidden) && [self.partnerSportDataView pointInside:pointAt withEvent:event]) {
        
        return [super hitTest:point withEvent:event];
    }
    
    
    pointAt = [self.mySportDataView convertPoint:point fromView:self];
    if (!(self.mySportDataView.hidden) && [self.mySportDataView pointInside:pointAt withEvent:event]) {
        
        return [super hitTest:point withEvent:event];
    }
    
    
    pointAt = [self.msgTableView convertPoint:point fromView:self];
    if (!(self.msgTableView.hidden) && [self.msgTableView pointInside:pointAt withEvent:event]) {
        
        return [super hitTest:point withEvent:event];
    }
    
    return [self.backMapView hitTest:point withEvent:event];
}



//没有跑步
- (void)updateViewByFriendCount:(NSInteger)friendCount
                    NearByCount:(NSInteger)nearbyCount
              RecommendRunerArr:(NSArray *)runerArr
{
    
    CGRect bounds = CGRectZero;
    CGRect viewFrame = CGRectZero;
    
    [self.countView updateViewbyFriendCount:friendCount NearbyCount:nearbyCount];
    if (runerArr == nil || [runerArr count] == 0) {
        //没有推荐跑友
        bounds      = [self.countView bounds];
        viewFrame   = CGRectMake(0, CGRectGetHeight(self.frame) - 60, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.countView.frame = viewFrame;
        [self.sporter1InfoView setHidden:YES];
        [self.sporter2InfoView setHidden:YES];
        
    } else if ([runerArr count] == 1) {
        //推荐1个
        bounds      = [self.countView bounds];
        viewFrame   = CGRectMake(0, CGRectGetHeight(self.frame) - 135, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.countView.frame = viewFrame;
        
        bounds      = [self.sporter1InfoView bounds];
        viewFrame   = CGRectMake(0, CGRectGetHeight(self.frame) - 75, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.sporter1InfoView.frame = viewFrame;

        [self.sporter2InfoView setHidden:YES];
        
    } else if ([runerArr count] == 2) {
        //推荐2个
        
        bounds      = [self.countView bounds];
        viewFrame   = CGRectMake(0, CGRectGetHeight(self.frame) - 210, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.countView.frame = viewFrame;
        
        bounds      = [self.sporter1InfoView bounds];
        viewFrame   = CGRectMake(0, CGRectGetHeight(self.frame) - 150, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.sporter1InfoView.frame = viewFrame;
        
        bounds      = [self.sporter2InfoView bounds];
        viewFrame   = CGRectMake(0, CGRectGetHeight(self.frame) - 75, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
        self.sporter2InfoView.frame = viewFrame;
        
        
    }
}

//正在约跑中
- (void)updateViewByPartnerInfo
{

    
}

//已经跑步中
- (void)updateMySportData
{
    NSLog(@"更新我的运动数据");
    [self.mySportDataView updateViewkmValue:10
                                   calValue:1032
                                  timeValue:@"10.24"
                                  stepValue:113
                                 speedValue:34.4];
    
}

- (void)updatePartnerSportData
{
    NSLog(@"更新炮友的运动数据");
    [self.mySportDataView updateViewkmValue:10
                                   calValue:1032
                                  timeValue:@"10.24"
                                  stepValue:113
                                 speedValue:34.4];
}


@end
