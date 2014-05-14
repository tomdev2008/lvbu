//
//  MessageTableViewCell.h
//  DemoProject
//
//  Created by zzc on 14-5-12.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBubbleView.h"

@class MessageTableViewCell;
@protocol MessageTableViewCellDelegate <NSObject>

@optional
/**
 *  点击多媒体消息的时候统一触发这个回调
 *  @param message   被操作的目标消息Model
 *  @param indexPath 该目标消息在哪个IndexPath里面
 *  @param messageTableViewCell 目标消息在该Cell上
 */
- (void)multiMediaMessageDidSelectedOnMessage:(id <MessageModelDelegate>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(MessageTableViewCell *)messageTableViewCell;

/**
 *  双击文本消息，触发这个回调
 *  @param message   被操作的目标消息Model
 *  @param indexPath 该目标消息在哪个IndexPath里面
 */
- (void)didDoubleSelectedOnTextMessage:(id <MessageModelDelegate>)message atIndexPath:(NSIndexPath *)indexPath;

/**
 *  点击消息发送者的头像回调方法
 *  @param indexPath 该目标消息在哪个IndexPath里面
 */
- (void)didSelectedAvatarAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Menu Control Selected Item
 *  @param bubbleMessageMenuSelecteType 点击item后，确定点击类型
 */
- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(BubbleMessageMenuSelectType)bubbleMessageMenuSelecteType;

@end


@interface MessageTableViewCell : UITableViewCell


@property (nonatomic, weak) id <MessageTableViewCellDelegate> delegate;

@property (nonatomic, strong) MessageBubbleView *messageBubbleView;       //自定义多媒体消息内容View
@property (nonatomic, strong) UIButton *avatarButton;                     //头像按钮
@property (nonatomic, strong) UILabel *timestampLabel;                    //时间戳Label
@property (nonatomic, strong) NSIndexPath *indexPath;                      //Cell所在的位置，用于Cell delegate回调

@property (nonatomic, assign) BOOL displayTimestamp;



/**
 *  获取消息类型
 *
 *  @return 返回消息类型，比如是发送消息，又或者是接收消息
 */
- (BubbleMessageType)bubbleMessageType;

/**
 *  初始化Cell的方法，必须先调用这个，不然不会初始化显示控件
 *
 *  @param message          需显示的目标消息Model
 *  @param displayTimestamp 预先告知是否需要显示时间轴Label
 *  @param cellIdentifier   重用Cell的标识
 *
 *  @return 返回消息Cell对象
 */
- (instancetype)initWithMessage:(id <MessageModelDelegate>)message
              displaysTimestamp:(BOOL)displayTimestamp
                reuseIdentifier:(NSString *)cellIdentifier;

/**
 *  根据消息Model配置Cell的显示内容
 *
 *  @param message          目标消息Model
 *  @param displayTimestamp 配置的时候告知是否需要显示时间轴Label
 */
- (void)configureCellWithMessage:(id <MessageModelDelegate>)message
               displaysTimestamp:(BOOL)displayTimestamp;

/**
 *  根据消息Model计算Cell的高度
 *
 *  @param message          目标消息Model
 *  @param displayTimestamp 是否显示时间轴Label
 *
 *  @return 返回Cell所需要的高度
 */
+ (CGFloat)calculateCellHeightWithMessage:(id <MessageModelDelegate>)message
                        displaysTimestamp:(BOOL)displayTimestamp;



@end
