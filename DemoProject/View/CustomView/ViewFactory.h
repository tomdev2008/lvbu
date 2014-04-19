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

@interface ViewFactory : NSObject

+ (SportDataView *)createSportDataView;
+ (SporterView *)createSporterView;

@end
