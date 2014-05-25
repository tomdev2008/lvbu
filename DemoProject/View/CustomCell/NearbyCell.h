//
//  NearbyCell.h
//  DemoProject
//
//  Created by Proint on 14-4-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartnerCell.h"

@interface NearbyCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIImageView    *avatarImgView;             //头像
@property (weak, nonatomic) IBOutlet UILabel        *nameLabel;                 //昵称
@property (weak, nonatomic) IBOutlet UIImageView    *sexImageView;              //性别
@property (weak, nonatomic) IBOutlet UILabel        *ageLabel;                  //年龄
@property (weak, nonatomic) IBOutlet UIImageView    *positionImageView;         //位置
@property (weak, nonatomic) IBOutlet UILabel        *distanceLabel;             //距离
@property (weak, nonatomic) IBOutlet UIImageView    *statusImageView;           //状态

@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;



- (void)updateViewByAvatarUrl:(NSString *)avatarUrl
                     NickName:(NSString *)name
                       IsMale:(BOOL)isMale
                          Age:(NSInteger)age
                     Distance:(CGFloat)distance
                       Status:(NSInteger)status;




@end
