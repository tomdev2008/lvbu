//
//  CellFactory.m
//  DemoProject
//
//  Created by Proint on 14-4-9.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "CellFactory.h"

@interface CellFactory()


@end


@implementation CellFactory



+ (PartnerCell *)createPartnerCell
{
    PartnerCell *cell = nil;
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"PartnerCell"
                                                      owner:self
                                                    options:nil];
    if ([nibArray count] > 0) {
        cell = [nibArray objectAtIndex:0];
    }
    return cell;
}

+ (NearbyCell *)createNearbyCell
{
    NearbyCell *cell = nil;
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"NearbyCell"
                                                      owner:self
                                                    options:nil];
    if ([nibArray count] > 0) {
        cell = [nibArray objectAtIndex:0];
    }
    return cell;
}


+ (LeftViewCell *)createLeftViewCellWithIdentifier:(NSString *)identifier
{
    LeftViewCell *cell = [[LeftViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:identifier];
    return cell;
    
}

@end
