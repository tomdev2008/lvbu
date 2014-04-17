//
//  User.h
//  DemoProject
//
//  Created by Proint on 14-4-14.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * avatarFileName;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * isMale;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * target;
@property (nonatomic, retain) NSNumber * userid;

@end
