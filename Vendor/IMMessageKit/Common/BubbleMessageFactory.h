//
//  MessageBubbleFactory.h
//  DemoProject
//
//  Created by zzc on 14-5-7.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>

//消息类型
typedef NS_ENUM(NSInteger, BubbleMessageType) {
    BubbleMessageType_Sending = 0,
    BubbleMessageType_Receiving,
};


typedef NS_ENUM(NSInteger, BubbleImageViewStyle) {
    BubbleImageViewStyleWeChat = 0,
};

//消息媒体类型
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
    
    BubbleMessagePhotoCopy,
    BubbleMessagePhotoTranspond,
    BubbleMessagePhotoFavorites,
    BubbleMessagePhotoMore,
    
    BubbleMessageVideoTranspond,
    BubbleMessageVideoFavorites,
    BubbleMessageVideoMore,
    
    BubbleMessageVoicePlay,
    BubbleMessageVoiceFavorites,
    BubbleMessageVoiceTurnToText,
    BubbleMessageVoiceMore,
};



@interface BubbleMessageFactory : NSObject

+ (UIImage *)bubbleImageViewForType:(BubbleMessageType)type
                              style:(BubbleImageViewStyle)style
                          meidaType:(BubbleMessageMediaType)mediaType;


@end
