//
//  MessageInputView.m
//  DemoProject
//
//  Created by zzc on 14-5-12.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "MessageInputView.h"
#import "NSString+MessageInputView.h"

@implementation MessageInputView


#pragma mark - Action

- (void)messageStyleButtonClicked:(UIButton *)sender {
    NSInteger index = sender.tag;
    switch (index) {
        case 0: {
            //选择文本，语音信息切换
            sender.selected = !sender.selected;
            if (sender.selected) {
                self.inputedText = self.inputTextView.text;
                self.inputTextView.text = @"";
                [self.inputTextView resignFirstResponder];
            } else {
                self.inputTextView.text = self.inputedText;
                self.inputedText = nil;
                [self.inputTextView becomeFirstResponder];
            }
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.holdDownButton.alpha = sender.selected;
            } completion:^(BOOL finished) {
                
            }];
            
            if ([self.delegate respondsToSelector:@selector(didChangeSendVoiceMessage:)]) {
                [self.delegate didChangeSendVoiceMessage:sender.selected];
            }
            
            break;
        }
        case 1: {
            
            //选择发送表情
            sender.selected = !sender.selected;
            self.voiceChangeButton.selected = !sender.selected;
            
            if (!sender.selected) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.holdDownButton.alpha = sender.selected;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
            if ([self.delegate respondsToSelector:@selector(didSendFaceMessage:)]) {
                [self.delegate didSendFaceMessage:sender.selected];
            }
            break;
        }
        case 2: {
            
            //选择其他，图片，视频，位置信息等等
            if ([self.delegate respondsToSelector:@selector(didSelectedMultipleMediaAction)]) {
                [self.delegate didSelectedMultipleMediaAction];
            }
            break;
        }
        default:
            break;
    }
}

- (void)holdDownButtonTouchDown {
    
    //开始录音
    if ([self.delegate respondsToSelector:@selector(didStartRecordingVoice)]) {
        [self.delegate didStartRecordingVoice];
    }
}

- (void)holdDownButtonTouchUpOutside {
    
    //取消录音
    if ([self.delegate respondsToSelector:@selector(didCancelRecordingVoice)]) {
        [self.delegate didCancelRecordingVoice];
    }
}

- (void)holdDownButtonTouchUpInside {
    
    //录音完成
    if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoice)]) {
        [self.delegate didFinishRecoingVoice];
    }
}

#pragma mark - layout subViews UI

- (UIButton *)createButtonWithImage:(UIImage *)image HLImage:(UIImage *)hlImage {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [MessageInputView textViewLineHeight], [MessageInputView textViewLineHeight])];
    
    if (image != nil) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }

    if (hlImage != nil) {
        [button setBackgroundImage:hlImage forState:UIControlStateHighlighted];
    }
    
    return button;
}

- (void)setupMessageInputViewBarWithStyle:(MessageInputViewStyle)style {
    
    // 配置输入工具条的样式和布局
    // 需要显示按钮的总宽度，包括间隔在内
    CGFloat allButtonWidth = 0.0;
    
    // 水平间隔
    CGFloat horizontalPadding = 8;
    
    // 垂直间隔
    CGFloat verticalPadding = 5;
    
    // 输入框
    CGFloat textViewLeftMargin = ((style == MessageInputViewStyle_Flat) ? 6.0 : 4.0);
    
    // 每个按钮统一使用的frame变量
    CGRect buttonFrame;
    
    // 按钮对象消息
    UIButton *button;
    
    // 允许发送语音
    if (self.allowsSendVoice) {
        button = [self createButtonWithImage:[UIImage imageNamed:@"voice"] HLImage:[UIImage imageNamed:@"voice_HL"]];
        [button addTarget:self action:@selector(messageStyleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 0;
        [button setImage:[UIImage imageNamed:@"keyborad"] forState:UIControlStateSelected];
        buttonFrame = button.frame;
        buttonFrame.origin = CGPointMake(horizontalPadding, verticalPadding);
        button.frame = buttonFrame;
        [self addSubview:button];
        allButtonWidth += CGRectGetMaxX(buttonFrame);
        textViewLeftMargin += CGRectGetMaxX(buttonFrame);
        
        self.voiceChangeButton = button;
    }
    
    // 允许发送多媒体消息，为什么不是先放表情按钮呢？因为布局的需要！
    if (self.allowsSendMultiMedia) {
        button = [self createButtonWithImage:[UIImage imageNamed:@"multiMedia"] HLImage:[UIImage imageNamed:@"multiMedia_HL"]];
        [button addTarget:self action:@selector(messageStyleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 2;
        buttonFrame = button.frame;
        buttonFrame.origin = CGPointMake(CGRectGetWidth(self.bounds) - horizontalPadding - CGRectGetWidth(buttonFrame), verticalPadding);
        button.frame = buttonFrame;
        [self addSubview:button];
        allButtonWidth += CGRectGetWidth(buttonFrame) + horizontalPadding * 2.5;
        
        self.multiMediaSendButton = button;
    }
    
    // 允许发送表情
    if (self.allowsSendFace) {
        button = [self createButtonWithImage:[UIImage imageNamed:@"face"] HLImage:[UIImage imageNamed:@"face_HL"]];
        [button setImage:[UIImage imageNamed:@"keyborad"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(messageStyleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1;
        buttonFrame = button.frame;
        if (self.allowsSendMultiMedia) {
            buttonFrame.origin = CGPointMake(CGRectGetMinX(self.multiMediaSendButton.frame) - CGRectGetWidth(buttonFrame) - horizontalPadding, verticalPadding);
            allButtonWidth += CGRectGetWidth(buttonFrame) + horizontalPadding * 1.5;
        } else {
            buttonFrame.origin = CGPointMake(CGRectGetWidth(self.bounds) - horizontalPadding - CGRectGetWidth(buttonFrame), verticalPadding);
            allButtonWidth += CGRectGetWidth(buttonFrame) + horizontalPadding * 2.5;
        }
        button.frame = buttonFrame;
        [self addSubview:button];
        
        self.faceSendButton = button;
    }
    
    // 输入框的高度和宽度
    CGFloat width = CGRectGetWidth(self.bounds) - allButtonWidth;
    CGFloat height = [MessageInputView textViewLineHeight];
    
    // 初始化输入框
    SAMTextView *textView = [[SAMTextView  alloc] initWithFrame:CGRectZero];
    
    // 这个是仿微信的一个细节体验
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    
    textView.placeholder = @"发送新消息";
    textView.delegate = self;
    
    [self addSubview:textView];
	_inputTextView = textView;
    
    // 配置不同iOS SDK版本的样式
    switch (style) {
        case MessageInputViewStyle_Quasiphysical: {
            _inputTextView.frame = CGRectMake(textViewLeftMargin, 3.0f, width, height);
            _inputTextView.backgroundColor = [UIColor whiteColor];
            
            self.image = [[UIImage imageNamed:@"input-bar-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0f, 3.0f, 19.0f, 3.0f)
                                                                                      resizingMode:UIImageResizingModeStretch];
            
            UIImageView *inputFieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(_inputTextView.frame.origin.x - 1.0f,
                                                                                        0.0f,
                                                                                        _inputTextView.frame.size.width + 2.0f,
                                                                                        self.frame.size.height)];
            inputFieldBack.image = [[UIImage imageNamed:@"input-field-cover"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 12.0f, 18.0f, 18.0f)];
            inputFieldBack.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            inputFieldBack.backgroundColor = [UIColor clearColor];
            [self addSubview:inputFieldBack];
            break;
        }
        case MessageInputViewStyle_Flat: {
            _inputTextView.frame = CGRectMake(textViewLeftMargin, 4.5f, width, height);
            _inputTextView.backgroundColor = [UIColor clearColor];
            _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
            _inputTextView.layer.borderWidth = 0.65f;
            _inputTextView.layer.cornerRadius = 6.0f;
            
            self.image = [[UIImage imageNamed:@"input-bar-flat"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f)
                                                                                resizingMode:UIImageResizingModeStretch];
            break;
        }
        default:
            break;
    }
    
    // 如果是可以发送语言的，那就需要一个按钮录音的按钮，事件可以在外部添加
    if (self.allowsSendVoice) {
        button = [self createButtonWithImage:[UIImage imageNamed:@"holdDownButton"] HLImage:nil];
        buttonFrame = _inputTextView.frame;
        button.frame = buttonFrame;
        button.alpha = self.voiceChangeButton.selected;
        [button addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.holdDownButton = button;
    }
}

#pragma mark - Life cycle

- (void)setup {
    // 配置自适应
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    // 由于继承UIImageView，所以需要这个属性设置
    self.userInteractionEnabled = YES;
    
    // 默认设置
    _allowsSendVoice = YES;
    _allowsSendFace = YES;
    _allowsSendMultiMedia = YES;
    
    _messageInputViewStyle = MessageInputViewStyle_Flat;
}

- (void)awakeFromNib {
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc {
    _inputTextView.delegate = nil;
    _inputTextView = nil;
    
    _voiceChangeButton = nil;
    _multiMediaSendButton = nil;
    _faceSendButton = nil;
    _holdDownButton = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // 当别的地方需要add的时候，就会调用这里
    if (newSuperview) {
        [self setupMessageInputViewBarWithStyle:self.messageInputViewStyle];
    }
}

#pragma mark - Message input view

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight {
    // 动态改变自身的高度和输入框的高度
    CGRect prevFrame = self.inputTextView.frame;
    
    NSUInteger numLines = MAX([self.inputTextView numberOfLinesOfText], [self.inputTextView.text numberOfLines]);
    
    self.inputTextView.frame = CGRectMake(prevFrame.origin.x,
                                          prevFrame.origin.y,
                                          prevFrame.size.width,
                                          prevFrame.size.height + changeInHeight);
    
    
    self.inputTextView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                       0.0f,
                                                       (numLines >= 6 ? 4.0f : 0.0f),
                                                       0.0f);
    
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    self.inputTextView.scrollEnabled = YES;
    
    if (numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.inputTextView.contentSize.height - self.inputTextView.bounds.size.height);
        [self.inputTextView setContentOffset:bottomOffset animated:YES];
        [self.inputTextView scrollRangeToVisible:NSMakeRange(self.inputTextView.text.length - 2, 1)];
    }
}

+ (CGFloat)textViewLineHeight {
    return 36.0f; // for fontSize 16.0f
}

+ (CGFloat)maxLines {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 3.0f : 8.0f;
}

+ (CGFloat)maxHeight {
    return ([MessageInputView maxLines] + 1.0f) * [MessageInputView textViewLineHeight];
}

#pragma mark - Text view delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendMessageWithText:)]) {
            [self.delegate didSendMessageWithText:textView.text];
        }
        return NO;
    }
    return YES;
}


@end
