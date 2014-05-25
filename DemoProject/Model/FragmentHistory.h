//
//  FragmentHistory.h
//  DemoProject
//
//  Created by zzc on 14-5-24.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


/**
 *  碎片运动记录，来源于手环
 */

@interface FragmentHistory : NSManagedObject

@property (nonatomic, retain) NSNumber * uid;               //用户ID
@property (nonatomic, retain) NSString * begin_time;        //开始时间
@property (nonatomic, retain) NSNumber * sec_length;        //时长
@property (nonatomic, retain) NSNumber * distance;          //距离
@property (nonatomic, retain) NSNumber * steps;             //步数
@property (nonatomic, retain) NSNumber * calories;          //卡路里
@property (nonatomic, retain) NSNumber * record_num;        //记录编号

@end
