//
//  MessageAvatarFactory.m
//  DemoProject
//
//  Created by zzc on 14-5-7.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "MessageAvatarFactory.h"
#import "MsgMacro.h"

@implementation MessageAvatarFactory

+ (UIImage *)avatarImageNamed:(UIImage *)originImage
            messageAvatarType:(MessageAvatarType)type
{
    CGFloat radius = 0.0;
    switch (type) {
        case MessageAvatarType_Circle:
        {
            radius = originImage.size.width / 2.0;
            break;
        }
        case MessageAvatarType_Square:
        {
            radius = 8;
            break;
        }
        default:
            break;
    }
    
    UIImage *avatarImg = [originImage createRoundedWithRadius:radius];
    return avatarImg;

}

@end
