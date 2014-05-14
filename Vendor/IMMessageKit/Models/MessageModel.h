//
//  MessageModel.h
//  DemoProject
//
//  Created by zzc on 14-5-7.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

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



@interface MessageModel : NSObject<MessageModelDelegate, NSCoding, NSCopying>

//文本
@property (nonatomic, copy) NSString *text;

//图片
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, copy) NSString *thumbnailUrl;         //缩略图
@property (nonatomic, copy) NSString *originPhotoUrl;       //原始图

//视频
@property (nonatomic, strong) UIImage *videoConverPhoto;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, copy) NSString *videoUrl;

//声音
@property (nonatomic, copy) NSString *voicePath;
@property (nonatomic, copy) NSString *voiceUrl;

@property (nonatomic, copy) NSString *emotionPath;

@property (nonatomic, strong) UIImage *localPositionPhoto;

@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *sender;

@property (nonatomic, strong) NSDate *timestamp;

@property (nonatomic, assign) BOOL isSended;

@property (nonatomic, assign) BubbleMessageMediaType messageMediaType;
@property (nonatomic, assign) BubbleMessageType bubbleMessageType;


/**
 *  初始化文本消息
 *
 *  @param text   发送的目标文本
 *  @param sender 发送者的名称
 *  @param date   发送的时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithText:(NSString *)text
                      sender:(NSString *)sender
                   timestamp:(NSDate *)timestamp;

/**
 *  初始化图片类型的消息
 *
 *  @param photo          目标图片
 *  @param thumbnailUrl   目标图片在服务器的缩略图地址
 *  @param originPhotoUrl 目标图片在服务器的原图地址
 *  @param sender         发送者
 *  @param date           发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithPhoto:(UIImage *)photo
                 thumbnailUrl:(NSString *)thumbnailUrl
               originPhotoUrl:(NSString *)originPhotoUrl
                       sender:(NSString *)sender
                    timestamp:(NSDate *)timestamp;

/**
 *  初始化视频类型的消息
 *
 *  @param videoConverPhoto 目标视频的封面图
 *  @param videoPath        目标视频的本地路径，如果是下载过，或者是从本地发送的时候，会存在
 *  @param videoUrl         目标视频在服务器上的地址
 *  @param sender           发送者
 *  @param date             发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVideoConverPhoto:(UIImage *)videoConverPhoto
                               videoPath:(NSString *)videoPath
                                videoUrl:(NSString *)videoUrl
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp;

/**
 *  初始化语音类型的消息
 *
 *  @param voicePath 目标语音的本地路径
 *  @param voiceUrl  目标语音在服务器的地址
 *  @param sender    发送者
 *  @param date      发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceUrl:(NSString *)voiceUrl
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp;



/**
 *  初始化表情类型的消息
 *  @return 返回Message model 对象
 */
- (instancetype)initWithEmotionPath:(NSString *)emotionPath
                             sender:(NSString *)sender
                          timestamp:(NSDate *)timestamp;


/**
 *  初始化位置类型的消息
 *  @return 返回Message model 对象
 */
- (instancetype)initWithLocalPositionPhoto:(UIImage *)localPositionPhoto
                                    sender:(NSString *)sender
                                 timestamp:(NSDate *)timestamp;


@end
