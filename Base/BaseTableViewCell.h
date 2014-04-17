//
//  BaseTableViewCell.h
//  DemoProject
//
//  Created by zzc on 14-1-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseTableViewCell : UITableViewCell


@property(nonatomic, assign) int rowType;                   //行类型
@property(nonatomic, assign) BOOL isSelected;               //是否选中
@property(nonatomic, retain) UILabel *titleLabel;           //标题


- (int) getRowType:(int)rowIndex rowCount:(int)rowCount;

- (void)setCustomTitle:(NSString *)title;

@end
