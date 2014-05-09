//
//  MessageModelDelegate.h
//  DemoProject
//
//  Created by zzc on 14-5-7.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BubbleMessageFactory.h"

@protocol MessageModelDelegate <NSObject>


@required

//文字
- (NSString *)text;

//图片
- (UIImage *)photo;
- (NSString *)thumbnailUrl;
- (NSString *)originPhotoUrl;

//视频
- (UIImage *)videoConverPhoto;
- (NSString *)videoPath;
- (NSString *)videoUrl;

//声音
- (NSString *)voicePath;
- (NSString *)voiceUrl;


//位置
- (UIImage *)localPositionPhoto;

//表情
- (NSString *)emotionPath;

//头像
- (UIImage *)avatar;
- (NSString *)avatarUrl;

//消息类型
- (BubbleMessageMediaType)messageMediaType;
- (BubbleMessageType)bubbleMessageType;

@optional

- (NSString *)sender;
- (NSDate *)timestamp;

@end
