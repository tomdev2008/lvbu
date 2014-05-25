//
//  CellFactory.h
//  DemoProject
//
//  Created by Proint on 14-4-9.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "PartnerCell.h"
#import "NearbyCell.h"
#import "LeftViewCell.h"


@interface CellFactory : NSObject


+ (PartnerCell *)createPartnerCell;
+ (NearbyCell *)createNearbyCell;
+ (LeftViewCell *)createLeftViewCellWithIdentifier:(NSString *)identifier;

@end
