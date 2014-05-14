//
//  MessageTableViewCell.m
//  DemoProject
//
//  Created by zzc on 14-5-12.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "MessageTableViewCell.h"


static const CGFloat kLabelPadding          = 5.0f;
static const CGFloat kTimeStampLabelHeight  = 15.0f;
static const CGFloat kAvatarPaddingX        = 8.0f;
static const CGFloat kAvatarPaddingY        = 15.0f;
static const CGFloat kBubbleMessageViewPadding = 8;




@interface MessageTableViewCell () {
    
}

/**
 *  1、是否显示Time Line的label
 *
 *  @param message 需要配置的目标消息Model
 */
- (void)configureTimestamp:(BOOL)displayTimestamp atMessage:(id<MessageModelDelegate>)message;

/**
 *  2、配置头像
 *
 *  @param message 需要配置的目标消息Model
 */
- (void)configAvatarWithMessage:(id<MessageModelDelegate>)message;

/**
 *  3、配置需要显示什么消息内容，比如语音、文字、视频、图片
 *
 *  @param message 需要配置的目标消息Model
 */
- (void)configureMessageBubbleViewWithMessage:(id<MessageModelDelegate>)message;

/**
 *  头像按钮，点击事件
 *
 *  @param sender 头像按钮对象
 */
- (void)avatarButtonClicked:(UIButton *)sender;

/**
 *  统一一个方法隐藏MenuController，多处需要调用
 */
- (void)hideMenuController;

/**
 *  点击Cell的手势处理方法，用于隐藏MenuController的
 *
 *  @param tapGestureRecognizer 点击手势对象
 */
- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer;

/**
 *  长按Cell的手势处理方法，用于显示MenuController的
 *
 *  @param longPressGestureRecognizer 长按手势对象
 */
- (void)longPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer;

/**
 *  单击手势处理方法，用于点击多媒体消息触发方法，比如点击语音需要播放的回调、点击图片需要查看大图的回调
 *
 *  @param tapGestureRecognizer 点击手势对象
 */
- (void)sigleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer;

/**
 *  双击手势处理方法，用于双击文本消息，进行放大文本的回调
 *
 *  @param tapGestureRecognizer 双击手势对象
 */
- (void)doubleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer;

@end



@implementation MessageTableViewCell


//点击头像
- (void)avatarButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectedAvatarAtIndexPath:)]) {
        [self.delegate didSelectedAvatarAtIndexPath:self.indexPath];
    }
}

#pragma mark - UIMenuController Method

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copyed:) || action == @selector(transpond:) || action == @selector(favorites:) || action == @selector(more:));
}

#pragma mark - MenuItem Actions

//复制
- (void)copyed:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.messageBubbleView.textMsgView.text];
    [self resignFirstResponder];
    NSLog(@"Cell was copy");
}

//转发
- (void)transpond:(id)sender {
    NSLog(@"Cell was transpond");
}

//收藏
- (void)favorites:(id)sender {
    NSLog(@"Cell was favorites");
}

//更多
- (void)more:(id)sender {
    NSLog(@"Cell was more");
}

#pragma mark - Setters

- (void)configureCellWithMessage:(id <MessageModelDelegate>)message
               displaysTimestamp:(BOOL)displayTimestamp {
   
    // 1、是否显示Time Line的label
    [self configureTimestamp:displayTimestamp atMessage:message];
    
    // 2、配置头像
    [self configAvatarWithMessage:message];
    
    // 3、配置需要显示什么消息内容，比如语音、文字、视频、图片
    [self configureMessageBubbleViewWithMessage:message];
}

//配置时间戳
- (void)configureTimestamp:(BOOL)displayTimestamp atMessage:(id <MessageModelDelegate>)message {
    self.displayTimestamp = displayTimestamp;
    self.timestampLabel.hidden = !self.displayTimestamp;
    if (displayTimestamp) {
        self.timestampLabel.text = [NSDateFormatter localizedStringFromDate:message.timestamp
                                                                  dateStyle:NSDateFormatterMediumStyle
                                                                  timeStyle:NSDateFormatterShortStyle];
    }
}

//配置时间
- (void)configAvatarWithMessage:(id <MessageModelDelegate>)message {
    if (message.avatar) {
        [self.avatarButton setImage:[MessageAvatarFactory avatarImageNamed:message.avatar messageAvatarType:MessageAvatarType_Circle] forState:UIControlStateNormal];
    } else {
        [self.avatarButton setImage:[MessageAvatarFactory avatarImageNamed:[UIImage imageNamed:@"meIcon"] messageAvatarType:MessageAvatarType_Circle] forState:UIControlStateNormal];
    }
}

//配置消息气泡bubbleView
- (void)configureMessageBubbleViewWithMessage:(id <MessageModelDelegate>)message {
    BubbleMessageMediaType currentMediaType = message.messageMediaType;
    
    //移除bubbleImageView的所有手势
    for (UIGestureRecognizer *gesTureRecognizer in self.messageBubbleView.bubbleImageView.gestureRecognizers) {
        [self.messageBubbleView.bubbleImageView removeGestureRecognizer:gesTureRecognizer];
    }
    
    //移除photoMsgView的所有手势
    for (UIGestureRecognizer *gesTureRecognizer in self.messageBubbleView.photoMsgView.gestureRecognizers) {
        [self.messageBubbleView.photoMsgView removeGestureRecognizer:gesTureRecognizer];
    }
    
    switch (currentMediaType) {
        case BubbleMessageMediaType_Photo:
        case BubbleMessageMediaType_Video:
        case BubbleMessageMediaType_LocalPosition: {
            
            //照片，视频，位置信息三类消息， photoMsgView添加单击tap手势
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
            [self.messageBubbleView.photoMsgView addGestureRecognizer:tapGestureRecognizer];
            break;
        }
        case BubbleMessageMediaType_Text:
        case BubbleMessageMediaType_Voice:
        case BubbleMessageMediaType_Face: {
            
            //文本，语音，表情三类消息： 文本消息添加双击手势，语音和表情添加单击手势。，添加到bubbleImageView上。
            UITapGestureRecognizer *tapGestureRecognizer;
            if (currentMediaType == BubbleMessageMediaType_Text) {
                tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizerHandle:)];
            } else {
                tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
            }
            tapGestureRecognizer.numberOfTapsRequired = (currentMediaType == BubbleMessageMediaType_Text ? 2 : 1);
            [self.messageBubbleView.bubbleImageView addGestureRecognizer:tapGestureRecognizer];
            break;
        }
        default:
            break;
    }
    
    //配置bubbleView
    [self.messageBubbleView configureCellWithMessage:message];
}


- (void)hideMenuController {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
}

#pragma mark - Cell Gestures

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self hideMenuController];
}

- (void)longPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (longPressGestureRecognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
        return;
    
    //复制，更多，转发，收藏
    UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"copy", @"IMMessageKitString", @"复制文本消息")
                                                  action:@selector(copyed:)];
    UIMenuItem *more = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"more", @"IMMessageKitString", @"更多")
                                                  action:@selector(more:)];
    UIMenuItem *transpond = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"transpond", @"IMMessageKitString", @"转发")
                                                       action:@selector(transpond:)];
    UIMenuItem *favorites = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"favorites", @"IMMessageKitString", @"收藏")
                                                       action:@selector(favorites:)];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:[NSArray arrayWithObjects:copy, transpond, favorites, more, nil]];
    

    CGRect targetRect = [self convertRect:[self.messageBubbleView bubbleFrame]
                                 fromView:self.messageBubbleView];
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}


#pragma mark - 点击多媒体消息 Gestures

- (void)sigleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self hideMenuController];
        if ([self.delegate respondsToSelector:@selector(multiMediaMessageDidSelectedOnMessage:atIndexPath:onMessageTableViewCell:)]) {
            [self.delegate multiMediaMessageDidSelectedOnMessage:self.messageBubbleView.message atIndexPath:self.indexPath onMessageTableViewCell:self];
        }
    }
}

- (void)doubleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(didDoubleSelectedOnTextMessage:atIndexPath:)]) {
            [self.delegate didDoubleSelectedOnTextMessage:self.messageBubbleView.message atIndexPath:self.indexPath];
        }
    }
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    
    //移除willHideMenu通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

//菜单将要弹出时
- (void)handleMenuWillShowNotification:(NSNotification *)notification {
    
    //移除willShowMenu通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    //监听willHideMenu通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

#pragma mark - Getters

- (BubbleMessageType)bubbleMessageType {
    
    //返回消息媒体类型
    return self.messageBubbleView.message.bubbleMessageType;
}

+ (CGFloat)calculateCellHeightWithMessage:(id <MessageModelDelegate>)message
                        displaysTimestamp:(BOOL)displayTimestamp {
    
    //计算cell高度
    CGFloat timestampHeight = displayTimestamp ? (kTimeStampLabelHeight + kLabelPadding * 2) : kLabelPadding;
    CGFloat avatarHeight = kAvatarImageSize;
    
    CGFloat subviewHeights = timestampHeight + kBubbleMessageViewPadding * 2;
    
    CGFloat bubbleHeight = [MessageBubbleView calculateCellHeightWithMessage:message];
    
    return subviewHeights + MAX(avatarHeight, bubbleHeight);
}

#pragma mark - Life cycle

- (void)setup {
    
    //初始化cell
    self.backgroundColor    = [UIColor clearColor];
    self.selectionStyle     = UITableViewCellSelectionStyleNone;
    self.accessoryType      = UITableViewCellAccessoryNone;
    self.accessoryView      = nil;
    
    self.imageView.image    = nil;
    self.imageView.hidden   = YES;
    self.textLabel.text     = nil;
    self.textLabel.hidden   = YES;
    self.detailTextLabel.text   = nil;
    self.detailTextLabel.hidden = YES;
    
    //添加长按手势
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerHandle:)];
    [recognizer setMinimumPressDuration:0.4f];
    [self addGestureRecognizer:recognizer];
    
    
    //添加点击手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHandle:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (instancetype)initWithMessage:(id <MessageModelDelegate>)message
              displaysTimestamp:(BOOL)displayTimestamp
                reuseIdentifier:(NSString *)cellIdentifier {
    
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if (self) {
        
        // 如果初始化成功，那就根据Message类型进行初始化控件，比如配置头像，配置发送和接收的样式
        // 1、是否显示Time Line的label
        if (!_timestampLabel) {
            UILabel *timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kLabelPadding, 140, kTimeStampLabelHeight)];
            timestampLabel.backgroundColor  = [UIColor colorWithWhite:0.000 alpha:0.380];
            timestampLabel.textAlignment    = NSTextAlignmentCenter;
            timestampLabel.textColor        = [UIColor whiteColor];
            timestampLabel.font     = [UIFont systemFontOfSize:12.0f];
            timestampLabel.center   = CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) / 2.0, timestampLabel.center.y);
            // 这个需要换个方案考虑，比如图片，或者绘制
            //            timestampLabel.layer.cornerRadius = 3.0f;
            //            timestampLabel.layer.masksToBounds = YES;
            
            [self.contentView addSubview:timestampLabel];
            [self.contentView bringSubviewToFront:timestampLabel];
            _timestampLabel = timestampLabel;
        }
        
        // 2、配置头像
        // avatar
        CGRect avatarButtonFrame;
        switch (message.bubbleMessageType) {
            case BubbleMessageType_Receiving:
                avatarButtonFrame = CGRectMake(kAvatarPaddingX, kAvatarPaddingY + (self.displayTimestamp ? kTimeStampLabelHeight : 0), kAvatarImageSize, kAvatarImageSize);
                break;
            case BubbleMessageType_Sending:
                avatarButtonFrame = CGRectMake(CGRectGetWidth(self.bounds) - kAvatarImageSize - kAvatarPaddingX, kAvatarPaddingY + (self.displayTimestamp ? kTimeStampLabelHeight : 0), kAvatarImageSize, kAvatarImageSize);
                break;
            default:
                break;
        }
        
        UIButton *avatarButton = [[UIButton alloc] initWithFrame:avatarButtonFrame];
        [avatarButton setImage:[MessageAvatarFactory avatarImageNamed:[UIImage imageNamed:@"meIcon"] messageAvatarType:MessageAvatarType_Circle] forState:UIControlStateNormal];
        [avatarButton addTarget:self action:@selector(avatarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:avatarButton];
        self.avatarButton = avatarButton;
        
        // 3、配置需要显示什么消息内容，比如语音、文字、视频、图片
        if (!_messageBubbleView) {
            CGFloat bubbleX = 0.0f;
            
            CGFloat offsetX = 0.0f;
            
            if (message.bubbleMessageType == BubbleMessageType_Receiving)
                bubbleX = kAvatarImageSize + kAvatarPaddingX + kAvatarPaddingX;
            else
                offsetX = kAvatarImageSize + kAvatarPaddingX + kAvatarPaddingX;
            
            CGRect frame = CGRectMake(bubbleX,
                                      kBubbleMessageViewPadding + (self.displayTimestamp ? (kTimeStampLabelHeight + kLabelPadding) : kLabelPadding),
                                      self.contentView.frame.size.width - bubbleX - offsetX,
                                      self.contentView.frame.size.height - (kBubbleMessageViewPadding + (self.displayTimestamp ? (kTimeStampLabelHeight + kLabelPadding) : kLabelPadding)));
            
            // bubble container
            MessageBubbleView *messageBubbleView = [[MessageBubbleView alloc] initWithFrame:frame message:message];
            messageBubbleView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                                  | UIViewAutoresizingFlexibleHeight
                                                  | UIViewAutoresizingFlexibleBottomMargin);
            [self.contentView addSubview:messageBubbleView];
            [self.contentView sendSubviewToBack:messageBubbleView];
            self.messageBubbleView = messageBubbleView;
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [self setup];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat layoutOriginY = kAvatarPaddingY + (self.displayTimestamp ? kTimeStampLabelHeight : 0);
    CGRect avatarButtonFrame = self.avatarButton.frame;
    avatarButtonFrame.origin.y = layoutOriginY;
    avatarButtonFrame.origin.x = ([self bubbleMessageType] == BubbleMessageType_Receiving) ? kAvatarPaddingX : ((CGRectGetWidth(self.bounds) - kAvatarPaddingX - kAvatarImageSize));
    
    layoutOriginY = kBubbleMessageViewPadding + (self.displayTimestamp ? kTimeStampLabelHeight : 0);
    CGRect bubbleMessageViewFrame = self.messageBubbleView.frame;
    bubbleMessageViewFrame.origin.y = layoutOriginY;
    
    CGFloat bubbleX = 0.0f;
    if ([self bubbleMessageType] == BubbleMessageType_Receiving)
        bubbleX = kAvatarImageSize + kAvatarPaddingX + kAvatarPaddingX;
    bubbleMessageViewFrame.origin.x = bubbleX;
    
    self.avatarButton.frame = avatarButtonFrame;
    self.messageBubbleView.frame = bubbleMessageViewFrame;
}

- (void)dealloc {
    _avatarButton = nil;
    _timestampLabel = nil;
    _messageBubbleView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableViewCell

- (void)prepareForReuse {
    // 这里做清除工作
    [super prepareForReuse];
    self.messageBubbleView.animationVoiceImageView.image = nil;
    self.messageBubbleView.textMsgView.text = nil;
    self.messageBubbleView.photoMsgView.messagePhoto = nil;
    self.timestampLabel.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}







@end
