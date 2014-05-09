//
//  MessageBubbleFactory.m
//  DemoProject
//
//  Created by zzc on 14-5-7.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BubbleMessageFactory.h"
#import "MsgMacro.h"



@implementation BubbleMessageFactory

+ (UIImage *)bubbleImageViewForType:(BubbleMessageType)type
                              style:(BubbleImageViewStyle)style
                          meidaType:(BubbleMessageMediaType)mediaType
{
    NSString *messageTypeString = nil;
    
    switch (style) {
        case BubbleImageViewStyleWeChat:
        {
            messageTypeString = @"weChatBubble";        // 类似微信的
            break;
        }
        default:
            break;
    }
    
    switch (type) {
        case BubbleMessageType_Sending:
        {
            //发送
            messageTypeString = [messageTypeString stringByAppendingString:@"_Sending"];
            break;
        }
        case BubbleMessageType_Receiving:
        {
            // 接收
            messageTypeString = [messageTypeString stringByAppendingString:@"_Receiving"];
            break;
        }
        default:
            break;
    }
    
    switch (mediaType) {
        case BubbleMessageMediaType_Text:
        case BubbleMessageMediaType_Voice:
        {
            messageTypeString = [messageTypeString stringByAppendingString:@"_Solid"];
            break;
        }
        case BubbleMessageMediaType_Photo:
        case BubbleMessageMediaType_Video:
        {
            messageTypeString = [messageTypeString stringByAppendingString:@"_Cavern"];
            break;
        }
        case BubbleMessageMediaType_Face:
        {
            break;
        }
        case BubbleMessageMediaType_LocalPosition:
        {
            break;
        }
        default:
            break;
    }
    
    
    UIImage *bublleImage = [UIImage imageNamed:messageTypeString];
    UIEdgeInsets bubbleImageEdgeInsets = [self bubbleImageEdgeInsetsWithStyle:style];
    return STRETCH_IMAGE_EDGE(bublleImage, bubbleImageEdgeInsets);
}

+ (UIEdgeInsets)bubbleImageEdgeInsetsWithStyle:(BubbleImageViewStyle)style
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    switch (style) {
        case BubbleImageViewStyleWeChat:
        {
            //类似微信
            edgeInsets = UIEdgeInsetsMake(30, 28, 85, 28);
            break;
        }
        default:
            break;
    }
    return edgeInsets;
}


@end
