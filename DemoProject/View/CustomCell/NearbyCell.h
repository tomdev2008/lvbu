//
//  NearbyCell.h
//  DemoProject
//
//  Created by Proint on 14-4-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbyCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;        //头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;                //昵称
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;            //距离
@property (weak, nonatomic) IBOutlet UILabel *descLabel;                //描述

//邀跑
- (IBAction)onInvate:(id)sender;
- (IBAction)onAdd:(id)sender;

@end
