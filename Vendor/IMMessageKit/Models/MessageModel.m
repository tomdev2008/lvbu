//
//  MessageModel.m
//  DemoProject
//
//  Created by zzc on 14-5-7.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel


- (instancetype)initWithText:(NSString *)text
                      sender:(NSString *)sender
                   timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.text = text;
        self.sender = sender;
        self.timestamp = timestamp;
        self.messageMediaType = BubbleMessageMediaType_Text;
    }
    return self;
}

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
                    timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.photo = photo;
        self.thumbnailUrl = thumbnailUrl;
        self.originPhotoUrl = originPhotoUrl;
        self.sender = sender;
        self.timestamp = timestamp;
        self.messageMediaType = BubbleMessageMediaType_Photo;
    }
    return self;
}

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
                               timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.videoConverPhoto = videoConverPhoto;
        self.videoPath = videoPath;
        self.videoUrl = videoUrl;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = BubbleMessageMediaType_Video;
    }
    return self;
}

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
                        timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.voicePath = voicePath;
        self.videoUrl = voiceUrl;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = BubbleMessageMediaType_Voice;
    }
    return self;
}

- (instancetype)initWithEmotionPath:(NSString *)emotionPath
                             sender:(NSString *)sender
                          timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.emotionPath = emotionPath;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = BubbleMessageMediaType_Face;
    }
    return self;
}

- (instancetype)initWithLocalPositionPhoto:(UIImage *)localPositionPhoto
                                    sender:(NSString *)sender
                                 timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.localPositionPhoto = localPositionPhoto;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = BubbleMessageMediaType_LocalPosition;
    }
    return self;
}

- (void)dealloc {
    
    //文本
    _text               = nil;
    
    //图片
    _photo              = nil;
    _thumbnailUrl       = nil;
    _originPhotoUrl     = nil;
    
    //视频
    _videoConverPhoto   = nil;
    _videoPath          = nil;
    _videoUrl           = nil;
    
    //声音
    _voicePath          = nil;
    _voiceUrl           = nil;
    
    //表情，位置信息
    _emotionPath        = nil;
    _localPositionPhoto = nil;
    
    //头像
    _avatar             = nil;
    _avatarUrl          = nil;
    
    //接受者，时间
    _sender             = nil;
    _timestamp          = nil;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _text               = [aDecoder decodeObjectForKey:@"text"];
        
        _photo              = [aDecoder decodeObjectForKey:@"photo"];
        _thumbnailUrl       = [aDecoder decodeObjectForKey:@"thumbnailUrl"];
        _originPhotoUrl     = [aDecoder decodeObjectForKey:@"originPhotoUrl"];
        
        _videoConverPhoto   = [aDecoder decodeObjectForKey:@"videoConverPhoto"];
        _videoPath          = [aDecoder decodeObjectForKey:@"videoPath"];
        _videoUrl           = [aDecoder decodeObjectForKey:@"videoUrl"];
        
        _voicePath          = [aDecoder decodeObjectForKey:@"voicePath"];
        _voiceUrl           = [aDecoder decodeObjectForKey:@"voiceUrl"];
        
        _emotionPath        = [aDecoder decodeObjectForKey:@"emotionPath"];
        
        _localPositionPhoto = [aDecoder decodeObjectForKey:@"localPositionPhoto"];
        
        _avatar             = [aDecoder decodeObjectForKey:@"avatar"];
        _avatarUrl          = [aDecoder decodeObjectForKey:@"avatarUrl"];
        
        _sender             = [aDecoder decodeObjectForKey:@"sender"];
        _timestamp          = [aDecoder decodeObjectForKey:@"timestamp"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.text forKey:@"text"];
    
    [aCoder encodeObject:self.photo forKey:@"photo"];
    [aCoder encodeObject:self.thumbnailUrl forKey:@"thumbnailUrl"];
    [aCoder encodeObject:self.originPhotoUrl forKey:@"originPhotoUrl"];
    
    [aCoder encodeObject:self.videoConverPhoto forKey:@"videoConverPhoto"];
    [aCoder encodeObject:self.videoPath forKey:@"videoPath"];
    [aCoder encodeObject:self.videoUrl forKey:@"videoUrl"];
    
    [aCoder encodeObject:self.voicePath forKey:@"voicePath"];
    [aCoder encodeObject:self.voiceUrl forKey:@"voiceUrl"];
    
    [aCoder encodeObject:self.voicePath forKey:@"voicePath"];
    [aCoder encodeObject:self.voiceUrl forKey:@"voiceUrl"];
    
    [aCoder encodeObject:self.emotionPath forKey:@"emotionPath"];
    
    [aCoder encodeObject:self.localPositionPhoto forKey:@"localPositionPhoto"];
    
    [aCoder encodeObject:self.sender forKey:@"sender"];
    [aCoder encodeObject:self.timestamp forKey:@"timestamp"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    switch (self.messageMediaType) {
        case BubbleMessageMediaType_Text:
            return [[[self class] allocWithZone:zone] initWithText:[self.text copy]
                                                            sender:[self.sender copy]
                                                         timestamp:[self.timestamp copy]];
        case BubbleMessageMediaType_Photo:
            return [[[self class] allocWithZone:zone] initWithPhoto:[self.photo copy]
                                                       thumbnailUrl:[self.thumbnailUrl copy]
                                                     originPhotoUrl:[self.originPhotoUrl copy]
                                                             sender:[self.sender copy]
                                                          timestamp:[self.timestamp copy]];
        case BubbleMessageMediaType_Video:
            return [[[self class] allocWithZone:zone] initWithVideoConverPhoto:[self.videoConverPhoto copy]
                                                                     videoPath:[self.videoPath copy]
                                                                      videoUrl:[self.videoUrl copy]
                                                                        sender:[self.sender copy]
                                                                     timestamp:[self.timestamp copy]];
        case BubbleMessageMediaType_Voice:
            return [[[self class] allocWithZone:zone] initWithVoicePath:[self.voicePath copy]
                                                               voiceUrl:[self.voiceUrl copy]
                                                                 sender:[self.sender copy]
                                                              timestamp:[self.timestamp copy]];
        case BubbleMessageMediaType_Face:
            return [[[self class] allocWithZone:zone] initWithEmotionPath:[self.emotionPath copy]
                                                                   sender:[self.sender copy]
                                                                timestamp:[self.timestamp copy]];
        case BubbleMessageMediaType_LocalPosition:
            return [[[self class] allocWithZone:zone] initWithLocalPositionPhoto:[self.localPositionPhoto copy]
                                                                          sender:[self.sender copy]
                                                                       timestamp:[self.timestamp copy]];
        default:
            return nil;
    }
}



@end

