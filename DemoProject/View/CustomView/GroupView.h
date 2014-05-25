//
//  GroupView.h
//  DemoProject
//
//  Created by zzc on 14-5-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewFactory.h"
#import "AppCore.h"

@interface GroupView : UIView

@property(nonatomic, weak)MKMapView *backMapView;   //用于转发触摸事件
@property(nonatomic, strong)GroupSportDataView *mySportDataView;
@property(nonatomic, strong)JSMessageTableView *msgTableView;

@end
