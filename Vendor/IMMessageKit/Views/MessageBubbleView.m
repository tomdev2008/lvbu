//
//  MessageBubbleView.m
//  DemoProject
//
//  Created by zzc on 14-5-12.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "MessageBubbleView.h"

#define kMarginTop          8.0f
#define kMarginBottom       4.0f
#define kPaddingTop         4.0f
#define kPaddingBottom      8.0f
#define kBubblePaddingRight 35.0f
#define kVoiceMargin        20.0f


@implementation MessageBubbleView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CGSize)textSizeForText:(NSString *)txt {
    CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * 0.55;
    CGFloat maxHeight = MAX([SAMTextView numberOfLinesForMessage:txt],
                            kMessageBubbleDisplayMaxLine) * [MessageInputView textViewLineHeight];
    maxHeight += kAvatarImageSize;
    
    CGSize stringSize;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_0) {
        CGRect stringRect = [txt boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{ NSFontAttributeName : [[MessageBubbleView appearance] font] }
                                              context:nil];
        
        stringSize = CGRectIntegral(stringRect).size;
    }
    else {
        stringSize = [txt sizeWithFont:[[MessageBubbleView appearance] font]
                     constrainedToSize:CGSizeMake(maxWidth, maxHeight)];
    }
    
    return CGSizeMake(roundf(stringSize.width), roundf(stringSize.height));
}

+ (CGSize)neededSizeForText:(NSString *)text {
    CGSize textSize = [MessageBubbleView textSizeForText:text];
    
	return CGSizeMake(textSize.width + kBubblePaddingRight,
                      textSize.height + kPaddingTop + kPaddingBottom);
}

+ (CGSize)neededSizeForPhoto:(UIImage *)photo {
    // 这里需要缩放后的size
    CGSize photoSize = CGSizeMake(100, 100);
    return photoSize;
}

+ (CGSize)neededSizeForVoicePath:(NSString *)voicePath {
    // 这里的100只是暂时固定，到时候会根据一个函数来计算
    CGSize voiceSize = CGSizeMake(100, [MessageInputView textViewLineHeight]);
    return voiceSize;
}

+ (CGFloat)calculateCellHeightWithMessage:(id <MessageModelDelegate>)message {
    CGSize size = [MessageBubbleView getBubbleFrameWithMessage:message];
    return size.height + kMarginTop + kMarginBottom;
}

+ (CGSize)getBubbleFrameWithMessage:(id <MessageModelDelegate>)message {
    CGSize bubbleSize;
    switch (message.messageMediaType) {
        case BubbleMessageMediaType_Text: {
            bubbleSize = [MessageBubbleView neededSizeForText:message.text];
            break;
        }
        case BubbleMessageMediaType_Photo: {
            bubbleSize = [MessageBubbleView neededSizeForPhoto:message.photo];
            break;
        }
        case BubbleMessageMediaType_Video: {
            bubbleSize = [MessageBubbleView neededSizeForPhoto:message.videoConverPhoto];
            break;
        }
        case BubbleMessageMediaType_Voice: {
            // 这里的宽度是不定的，高度是固定的，根据需要根据语音长短来定制啦
            bubbleSize = CGSizeMake(100, [MessageInputView textViewLineHeight]);
            break;
        }
        case BubbleMessageMediaType_Face:
            // 是否固定大小呢？
            bubbleSize = CGSizeMake(100, 100);
            break;
        case BubbleMessageMediaType_LocalPosition:
            // 固定大小，必须的
            bubbleSize = CGSizeMake(100, 100);
            break;
        default:
            break;
    }
    return bubbleSize;
}

#pragma mark - UIAppearance Getters

- (UIFont *)font {
    if (_font == nil) {
        _font = [[[self class] appearance] font];
    }
    
    if (_font != nil) {
        return _font;
    }
    
    return [UIFont systemFontOfSize:16.0f];
}

#pragma mark - Getters

- (CGRect)bubbleFrame {
    CGSize bubbleSize = [MessageBubbleView getBubbleFrameWithMessage:self.message];
    
    return CGRectIntegral(CGRectMake((self.message.bubbleMessageType == BubbleMessageType_Sending ? CGRectGetWidth(self.bounds) - bubbleSize.width : 0.0f),
                                     kMarginTop,
                                     bubbleSize.width,
                                     bubbleSize.height + kMarginBottom));
}

#pragma mark - Life cycle

- (void)configureCellWithMessage:(id <MessageModelDelegate>)message {
    _message = message;
    
    [self configureBubbleImageView:message];
    
    [self configureMessageDisplayMediaWithMessage:message];
}

- (void)configureBubbleImageView:(id <MessageModelDelegate>)message {
    BubbleMessageMediaType currentType = message.messageMediaType;
    
    switch (currentType) {
        case BubbleMessageMediaType_Text:
        case BubbleMessageMediaType_Voice:
        case BubbleMessageMediaType_Face: {
            _bubbleImageView.image = [BubbleMessageFactory bubbleImageViewForType:message.bubbleMessageType style:BubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            // 只要是文本、语音、第三方表情，背景的气泡都不能隐藏
            _bubbleImageView.hidden = NO;
            
            // 只要是文本、语音、第三方表情，都需要把显示尖嘴图片的控件隐藏了
            _photoMsgView.hidden = YES;
            
            
            if (currentType == BubbleMessageMediaType_Text) {
                // 如果是文本消息，那文本消息的控件需要显示
                _textMsgView.hidden = NO;
                // 那语言的gif动画imageView就需要隐藏了
                _animationVoiceImageView.hidden = YES;
            } else {
                // 那如果不文本消息，必须把文本消息的控件隐藏了啊
                _textMsgView.hidden = YES;
                
                // 对语音消息的进行特殊处理，第三方表情可以直接利用背景气泡的ImageView控件
                if (currentType == BubbleMessageMediaType_Voice) {
                    [_animationVoiceImageView removeFromSuperview];
                    _animationVoiceImageView = nil;
                    
                    UIImageView *animationVoiceImageView = [MessageVoiceFactory messageVoiceAnimationImageViewWithBubbleMessageType:message.bubbleMessageType];
                    [self addSubview:animationVoiceImageView];
                    _animationVoiceImageView = animationVoiceImageView;
                    _animationVoiceImageView.hidden = NO;
                } else {
                    _animationVoiceImageView.hidden = YES;
                }
            }
            break;
        }
        case BubbleMessageMediaType_Photo:
        case BubbleMessageMediaType_Video:
        case BubbleMessageMediaType_LocalPosition: {
            // 只要是图片和视频消息，必须把尖嘴显示控件显示出来
            _photoMsgView.hidden = NO;
            
            // 那其他的控件都必须隐藏
            _textMsgView.hidden = YES;
            _bubbleImageView.hidden = YES;
            _animationVoiceImageView.hidden = YES;
            break;
        }
        default:
            break;
    }
}

- (void)configureMessageDisplayMediaWithMessage:(id <MessageModelDelegate>)message {
    switch (message.messageMediaType) {
        case BubbleMessageMediaType_Text:
            _textMsgView.text = message.text;
            break;
        case BubbleMessageMediaType_Photo:
            [_photoMsgView configureMessagePhoto:message.photo onBubbleMessageType:self.message.bubbleMessageType];
            break;
        case BubbleMessageMediaType_Video:
            _photoMsgView.messagePhoto = message.videoConverPhoto;
            break;
        case BubbleMessageMediaType_Voice:
            break;
        case BubbleMessageMediaType_Face:
            // 直接设置GIF
            _bubbleImageView.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:message.emotionPath]];
            break;
        case BubbleMessageMediaType_LocalPosition:
            [_photoMsgView configureMessagePhoto:message.localPositionPhoto onBubbleMessageType:self.message.bubbleMessageType];
            break;
        default:
            break;
    }
    
    [self setNeedsLayout];
}

- (instancetype)initWithFrame:(CGRect)frame
                      message:(id <MessageModelDelegate>)message {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _message = message;
        
        // 1、初始化气泡的背景
        if (!_bubbleImageView) {
            //bubble image
            UIImageView *bubbleImageView = [[UIImageView alloc] init];
            bubbleImageView.frame = self.bounds;
            bubbleImageView.userInteractionEnabled = YES;
            [self addSubview:bubbleImageView];
            _bubbleImageView = bubbleImageView;
        }
        
        // 2、初始化显示文本消息的TextView
        if (!_textMsgView) {
            TextMessageView *textMessageView = [[TextMessageView alloc] initWithFrame:CGRectZero];
            textMessageView.font = [UIFont systemFontOfSize:16.0f];
            textMessageView.textColor = [UIColor blackColor];
            textMessageView.editable = NO;
            if ([textMessageView respondsToSelector:@selector(setSelectable:)])
                textMessageView.selectable = NO;
            textMessageView.userInteractionEnabled = YES;
            textMessageView.showsHorizontalScrollIndicator = NO;
            textMessageView.showsVerticalScrollIndicator = NO;
            textMessageView.scrollEnabled = NO;
            textMessageView.backgroundColor = [UIColor clearColor];
            textMessageView.contentInset = UIEdgeInsetsZero;
            textMessageView.scrollIndicatorInsets = UIEdgeInsetsZero;
            textMessageView.contentOffset = CGPointZero;
            textMessageView.dataDetectorTypes = UIDataDetectorTypeAll;
            [self addSubview:textMessageView];
            _textMsgView = textMessageView;
            
            if ([_textMsgView respondsToSelector:@selector(textContainerInset)]) {
                _textMsgView.textContainerInset = UIEdgeInsetsMake(8.0f, 4.0f, 2.0f, 4.0f);
            }
        }
        
        // 3、初始化显示图片的控件
        if (!_photoMsgView) {
            PhotoMessageView *photoMessageView = [[PhotoMessageView alloc] initWithFrame:CGRectZero];
            [self addSubview:photoMessageView];
            _photoMsgView = photoMessageView;
        }
    }
    return self;
}

- (void)dealloc {
    _textMsgView = nil;
    _photoMsgView = nil;
    _animationVoiceImageView = nil;
    _font = nil;
    _message = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    BubbleMessageMediaType currentType = self.message.messageMediaType;
    CGRect bubbleFrame = [self bubbleFrame];
    
    switch (currentType) {
        case BubbleMessageMediaType_Text:
        case BubbleMessageMediaType_Voice:
        case BubbleMessageMediaType_Face: {
            self.bubbleImageView.frame = bubbleFrame;
            
            CGFloat textX = self.bubbleImageView.frame.origin.x;
            
            if (self.message.bubbleMessageType == BubbleMessageType_Receiving) {
                textX += (self.bubbleImageView.image.capInsets.left / 2.0f);
            }
            
            CGRect textFrame = CGRectMake(textX,
                                          bubbleFrame.origin.y,
                                          bubbleFrame.size.width - (self.bubbleImageView.image.capInsets.right / 2.0f),
                                          bubbleFrame.size.height - kMarginTop);
            
            self.textMsgView.frame = CGRectIntegral(textFrame);
            
            CGRect animationVoiceImageViewFrame = self.animationVoiceImageView.frame;
            animationVoiceImageViewFrame.origin = CGPointMake((self.message.bubbleMessageType == BubbleMessageType_Receiving ? (bubbleFrame.origin.x + kVoiceMargin) : (bubbleFrame.origin.x + CGRectGetWidth(bubbleFrame) - kVoiceMargin - CGRectGetWidth(animationVoiceImageViewFrame))), 17);
            self.animationVoiceImageView.frame = animationVoiceImageViewFrame;
            break;
        }
        case BubbleMessageMediaType_Photo:
        case BubbleMessageMediaType_Video:
        case BubbleMessageMediaType_LocalPosition: {
            CGRect photoImageViewFrame = CGRectMake(bubbleFrame.origin.x - 2, 0, bubbleFrame.size.width, bubbleFrame.size.height);
            self.photoMsgView.frame = photoImageViewFrame;
            break;
        }
        default:
            break;
    }
}


@end
