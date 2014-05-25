//
//  selfView.h
//  DemoProject
//
//  Created by zzc on 14-5-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewFactory.h"

@protocol SelfSportViewDelete <NSObject>

- (void)onAdd:(NSInteger)uid;
- (void)onInvite:(NSInteger)uid;
- (void)pauseSport;
- (void)stopSport;

@end



@interface SelfView : UIView

@property(nonatomic, weak)id<SelfSportViewDelete> delegate;

@property(nonatomic, weak)MKMapView *backMapView;   //用于转发触摸事件

@property(nonatomic, strong)SelfSportDataView *sportDataView;

@property(nonatomic, strong)UIView *lineView1;
@property(nonatomic, strong)UIView *lineView2;
@property(nonatomic, strong)SporterCountView *countView;
@property(nonatomic, strong)SporterInfoView *sporterView;
@property(nonatomic, strong)SelfSportOperationView *operationView;



@end
