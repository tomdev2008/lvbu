//
//  MessageAvatarFactory.h
//  DemoProject
//
//  Created by zzc on 14-5-7.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>


static CGFloat const kAvatarImageSize = 40.0f;

typedef NS_ENUM(NSInteger, MessageAvatarType) {
    MessageAvatarType_Square = 0,
    MessageAvatarType_Circle,
};

@interface MessageAvatarFactory : NSObject

+ (UIImage *)avatarImageNamed:(UIImage *)originImage
            messageAvatarType:(MessageAvatarType)type;

@end
