//
//  ViewFactory.m
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "ViewFactory.h"

@implementation ViewFactory



+ (SportDataView *)createSportDataView
{
    SportDataView *dataView = nil;
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"SportDataView"
                                                      owner:self
                                                    options:nil];
    if ([nibArray count] > 0) {
        dataView = [nibArray objectAtIndex:0];
    }
    return dataView;
}


+ (SporterView *)createSporterView
{
    SporterView *dataView = nil;
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"SporterView"
                                                      owner:self
                                                    options:nil];
    if ([nibArray count] > 0) {
        dataView = [nibArray objectAtIndex:0];
    }
    return dataView;
}

@end
