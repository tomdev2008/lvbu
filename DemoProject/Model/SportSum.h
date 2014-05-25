//
//  SportSum.h
//  DemoProject
//
//  Created by zzc on 14-5-24.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SportSum : NSManagedObject


@property (nonatomic, retain) NSNumber * uid;                   //用户ID
@property (nonatomic, retain) NSNumber * sport_distance;        //运动距离（米）
@property (nonatomic, retain) NSNumber * sport_steps;           //运动步数
@property (nonatomic, retain) NSNumber * sport_time;            //运动时长(秒)
@property (nonatomic, retain) NSNumber * sport_days;            //运动天数
@property (nonatomic, retain) NSNumber * sport_count;           //运动次数
@property (nonatomic, retain) NSNumber * my_distance;           //一天运动的最远距离
@property (nonatomic, retain) NSString * my_distance_day;       //日期
@property (nonatomic, retain) NSNumber * my_steps;              //一天运动最多步数
@property (nonatomic, retain) NSString * my_steps_day;          //日期
@property (nonatomic, retain) NSNumber * my_time;               //一天运动最长时间
@property (nonatomic, retain) NSString * my_time_day;           //日期
@property (nonatomic, retain) NSNumber * my_speed_pace;         //一天运动最高配速(秒每公里)
@property (nonatomic, retain) NSString * my_speed_pace_day;     //日期
@property (nonatomic, retain) NSNumber * my_speed_avg;          //一天运动最高均速(米每分钟)
@property (nonatomic, retain) NSString * my_speed_avg_day;      //日期
@property (nonatomic, retain) NSNumber * my_speed_max;          //一天运动公里最高速度
@property (nonatomic, retain) NSString * my_speed_max_day;      //日期
@property (nonatomic, retain) NSNumber * my_speed_min;          //一天运动公里最小速度
@property (nonatomic, retain) NSString * my_speed_min_day;      //日期
@property (nonatomic, retain) NSString * his_gps;               //出现的位置记录, 今天上海明天北京后天。。。

@end
