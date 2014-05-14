//
//  MessageBubbleView.h
//  DemoProject
//
//  Created by zzc on 14-5-12.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MsgMacro.h"
#import "MessageInputView.h"
#import "SAMTextView.h"
#import "TextMessageView.h"
#import "PhotoMessageView.h"


#import "MessageModel.h"
#import "MessageAvatarFactory.h"
#import "MessageVoiceFactory.h"

// Categorys
#import "UIImage+AnimatedFaceGif.h"


#define kMessageBubbleDisplayMaxLine 200

@interface MessageBubbleView : UIView


/**
 *  目标消息Model对象
 */
@property (nonatomic, strong, readonly)  id <MessageModelDelegate> message;



/**
 *  用于显示气泡的ImageView控件
 */
@property (nonatomic, weak, readonly) UIImageView *bubbleImageView;

/**
 *  用于显示语音的控件，并且支持播放动画
 */
@property (nonatomic, weak, readonly) UIImageView *animationVoiceImageView;

/**
 *  自定义显示文本消息控件，子类化的原因有两个，第一个是屏蔽Menu的显示。第二是传递手势到下一层，因为文本需要双击的手势
 */
@property (nonatomic, weak, readonly) TextMessageView *textMsgView;

/**
 *  用于显示仿微信发送图片的控件
 */
@property (nonatomic, weak, readonly) PhotoMessageView *photoMsgView;

/**
 *  设置文本消息的字体
 */
@property (nonatomic, strong) UIFont *font UI_APPEARANCE_SELECTOR;

/**
 *  初始化消息内容显示控件的方法
 *
 *  @param frame   目标Frame
 *  @param message 目标消息Model对象
 *
 *  @return 返回XHMessageBubbleView类型的对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                      message:(id <MessageModelDelegate>)message;

/**
 *  获取气泡相对于父试图的位置
 *
 *  @return 返回气泡的位置
 */
- (CGRect)bubbleFrame;

/**
 *  根据消息Model对象配置消息显示内容
 *
 *  @param message 目标消息Model对象
 */
- (void)configureCellWithMessage:(id <MessageModelDelegate>)message;

/**
 *  根据消息Model对象计算消息内容的高度
 *
 *  @param message 目标消息Model对象
 *
 *  @return 返回所需高度
 */
+ (CGFloat)calculateCellHeightWithMessage:(id <MessageModelDelegate>)message;

@end
