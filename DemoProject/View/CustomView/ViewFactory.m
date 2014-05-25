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
    SporterView *view = nil;
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"SporterView"
                                                      owner:self
                                                    options:nil];
    if ([nibArray count] > 0) {
        view = [nibArray objectAtIndex:0];
    }
    return view;
}



+ (SelfSportDataView *)createSelfSportDataView
{
    SelfSportDataView *view = nil;
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"SelfSportDataView"
                                                      owner:self
                                                    options:nil];
    if ([nibArray count] > 0) {
        view = [nibArray objectAtIndex:0];
    }
    return view;
}

+ (SelfSportOperationView *)createSelfSportOperationView
{

    SelfSportOperationView *view = nil;
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"SelfSportOperationView"
                                                      owner:self
                                                    options:nil];
    if ([nibArray count] > 0) {
        view = [nibArray objectAtIndex:0];
    }
    return view;
}

+ (ParterSportDataView *)createParterSportDataView
{

    ParterSportDataView *view = nil;
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"ParterSportDataView"
                                                      owner:self
                                                    options:nil];
    if ([nibArray count] > 0) {
        view = [nibArray objectAtIndex:0];
    }
    return view;
}


+ (SporterCountView *)createSporterCountView
{

    SporterCountView *view = nil;
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"SporterCountView"
                                                      owner:self
                                                    options:nil];
    if ([nibArray count] > 0) {
        view = [nibArray objectAtIndex:0];
    }
    return view;
}

+ (SporterInfoView *)createSporterInfoView
{
    SporterInfoView *view = nil;
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"SporterInfoView"
                                                      owner:self
                                                    options:nil];
    if ([nibArray count] > 0) {
        view = [nibArray objectAtIndex:0];
    }
    return view;
}

+ (GroupSportDataView *)createGroupSportDataView
{

    GroupSportDataView *view = nil;
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"GroupSportDataView"
                                                      owner:self
                                                    options:nil];
    if ([nibArray count] > 0) {
        view = [nibArray objectAtIndex:0];
    }
    return view;
}


@end
