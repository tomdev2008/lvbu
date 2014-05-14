//
//  MessageInputView.h
//  DemoProject
//
//  Created by zzc on 14-5-12.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMTextView.h"

typedef NS_ENUM(NSInteger, MessageInputViewStyle) {
    
    // 分两种,一种是iOS6样式的，一种是iOS7样式的
    MessageInputViewStyle_Quasiphysical,
    MessageInputViewStyle_Flat
};





@protocol XHMessageInputViewDelegate <NSObject>

@required

/**
 *  输入框刚好开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(SAMTextView *)msgInputTextView;

/**
 *  输入框将要开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(SAMTextView *)msgInputTextView;

@optional


/**
 *  切换发送语音消息
 *
 *
 */
- (void)didChangeSendVoiceMessage:(BOOL)changed;

/**
 *  发送文本消息，包括系统的表情
 *
 *  @param text 目标文本消息
 */
- (void)didSendMessageWithText:(NSString *)text;

/**
 *  点击+号按钮Action
 */
- (void)didSelectedMultipleMediaAction;


/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoice;
/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoice;

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoice;


/**
 *  发送第三方表情
 *
 *  @param facePath 目标表情的本地路径
 */
- (void)didSendFaceMessage:(BOOL)sendFace;

@end


@interface MessageInputView :UIImageView<UITextViewDelegate>



@property (nonatomic, weak) id <XHMessageInputViewDelegate> delegate;
@property (nonatomic, copy) NSString *inputedText;              //输入的文本内容
@property (nonatomic, strong) SAMTextView *inputTextView;       //用于输入文本消息的输入框

//输入工具条的样式, 默认为MessageInputViewStyleFlat
@property (nonatomic, assign)MessageInputViewStyle messageInputViewStyle;
@property (nonatomic, assign) BOOL allowsSendVoice;             //是否允许发送语音 默认为YES
@property (nonatomic, assign) BOOL allowsSendMultiMedia;        //是否允许发送多媒体 默认为YES
@property (nonatomic, assign) BOOL allowsSendFace;              //是否支持发送表情 默认为YES

@property (nonatomic, strong) UIButton *voiceChangeButton;      //切换文本和语音的按钮
@property (nonatomic, strong) UIButton *multiMediaSendButton;   //+号按钮
@property (nonatomic, strong) UIButton *faceSendButton;         //第三方表情按钮
@property (nonatomic, strong) UIButton *holdDownButton;         //语音录制按钮

#pragma mark - Message input view

//动态改变高度
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight;

//获取输入框内容字体行高
+ (CGFloat)textViewLineHeight;

//获取最大行数
+ (CGFloat)maxLines;

//获取根据最大行数和每行高度计算出来的最大显示高度
+ (CGFloat)maxHeight;


@end
