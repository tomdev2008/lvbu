//
//  MessageBubbleFactory.h
//  DemoProject
//
//  Created by zzc on 14-5-7.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>

//消息类型:发送消息，接收消息
typedef NS_ENUM(NSInteger, BubbleMessageType) {
    BubbleMessageType_Sending = 0,
    BubbleMessageType_Receiving,
};

//消息样式:仿微信
typedef NS_ENUM(NSInteger, BubbleImageViewStyle) {
    BubbleImageViewStyleWeChat = 0,
};

//消息媒体类型:文本，照片，视频，语音，表情，位置
typedef NS_ENUM(NSInteger, BubbleMessageMediaType) {
    BubbleMessageMediaType_Text = 0,
    BubbleMessageMediaType_Photo,
    BubbleMessageMediaType_Video,
    BubbleMessageMediaType_Voice,
    BubbleMessageMediaType_Face,
    BubbleMessageMediaType_LocalPosition,
};


//消息菜单类型
typedef NS_ENUM(NSInteger, BubbleMessageMenuSelectType) {
    BubbleMessageTextCopy = 0,            //复制
    BubbleMessageTextTranspond,           //转发
    BubbleMessageTextFavorites,           //收藏
    BubbleMessageTextMore,                //更多
    
    BubbleMessagePhotoCopy,                 //复制
    BubbleMessagePhotoTranspond,            //转发
    BubbleMessagePhotoFavorites,            //收藏
    BubbleMessagePhotoMore,                 //更多
    
    BubbleMessageVideoTranspond,            //转发
    BubbleMessageVideoFavorites,            //收藏
    BubbleMessageVideoMore,                 //更多
    
    BubbleMessageVoicePlay,                 //播放
    BubbleMessageVoiceFavorites,            //转发
    BubbleMessageVoiceTurnToText,           //转为文字
    BubbleMessageVoiceMore,                 //更多
};



@interface BubbleMessageFactory : NSObject

+ (UIImage *)bubbleImageViewForType:(BubbleMessageType)type
                              style:(BubbleImageViewStyle)style
                          meidaType:(BubbleMessageMediaType)mediaType;


@end
