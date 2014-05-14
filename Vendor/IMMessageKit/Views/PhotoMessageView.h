//
//  PhotoMessageView.h
//  DemoProject
//
//  Created by zzc on 14-5-12.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleMessageFactory.h"

@interface PhotoMessageView : UIView

/**
 *  发送后，需要显示的图片消息的图片，或者是视频的封面
 */
@property (nonatomic, strong) UIImage *messagePhoto;
@property (nonatomic, assign) BubbleMessageType bubbleMessageType;

/**
 *  根据目标图片配置三角形具体位置
 *
 *  @param messagePhoto      目标图片
 *  @param bubbleMessageType 目标消息类型
 */
- (void)configureMessagePhoto:(UIImage *)messagePhoto onBubbleMessageType:(BubbleMessageType)bubbleMessageType;

@end
