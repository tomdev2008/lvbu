//
//  LeftViewCell.h
//  DemoProject
//
//  Created by zzc on 14-4-26.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewCell : UITableViewCell

@property(nonatomic, retain)UIImageView *iconImgView;
@property(nonatomic, retain)UILabel *titleLabel;

@property(nonatomic, assign) int rowType;                   //行类型
@property(nonatomic, assign) BOOL isSelected;               //是否选中
@property(nonatomic, assign) BOOL hasClickBackgroud;        //cell选中时是否有选中背景图


@end
