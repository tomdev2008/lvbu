//
//  ViewFactory.h
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyPoint.h"

#import "SporterView.h"
#import "SportDataView.h"


#import "SelfSportDataView.h"
#import "SelfSportOperationView.h"
#import "ParterSportDataView.h"
#import "SporterCountView.h"
#import "SporterInfoView.h"
#import "GroupSportDataView.h"

@interface ViewFactory : NSObject

+ (SportDataView *)createSportDataView;
+ (SporterView *)createSporterView;


+ (SelfSportDataView *)createSelfSportDataView;
+ (SelfSportOperationView *)createSelfSportOperationView;
+ (ParterSportDataView *)createParterSportDataView;


+ (SporterCountView *)createSporterCountView;
+ (SporterInfoView *)createSporterInfoView;
+ (GroupSportDataView *)createGroupSportDataView;


@end
