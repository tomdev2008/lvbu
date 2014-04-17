//
//  CellFactory.h
//  DemoProject
//
//  Created by Proint on 14-4-9.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "MemberTableViewCell.h"
#import "PartnerCell.h"
#import "NearbyCell.h"


@interface CellFactory : NSObject

+ (MemberTableViewCell *)createMemberTableViewCell;
+ (PartnerCell *)createPartnerCell;
+ (NearbyCell *)createNearbyCell;

@end
