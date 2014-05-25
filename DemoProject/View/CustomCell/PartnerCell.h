//
//  PartnerCell.h
//  DemoProject
//
//  Created by Proint on 14-4-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>


enum CellEditStatus {
    CellEditStatus_StartEdit = 0,
    CellEditStatus_endEdit = 1,
    };


enum UserSportStatus {
    UserSportStatus_offline = 0,
    UserSportStatus_nosport,
    UserSportStatus_single,
    UserSportStatus_double,
    };

@interface PartnerCell : UITableViewCell

@property(assign, nonatomic)NSInteger cellEditStatus;

@property (weak, nonatomic) IBOutlet UIImageView    *avatarImgView;             //头像
@property (weak, nonatomic) IBOutlet UILabel        *nameLabel;                 //昵称
@property (weak, nonatomic) IBOutlet UIImageView    *sexImageView;              //性别
@property (weak, nonatomic) IBOutlet UILabel        *ageLabel;                  //年龄
@property (weak, nonatomic) IBOutlet UIImageView    *positionImageView;         //位置
@property (weak, nonatomic) IBOutlet UILabel        *distanceLabel;             //距离
@property (weak, nonatomic) IBOutlet UIImageView    *statusImageView;           //状态
@property (weak, nonatomic) IBOutlet UIButton       *inviteButton;              //邀请


@property (weak, nonatomic) IBOutlet UILabel *offlineLabel;



- (void)updateViewByAvatarUrl:(NSString *)avatarUrl
                     NickName:(NSString *)name
                       IsMale:(BOOL)isMale
                          Age:(NSInteger)age
                     Distance:(CGFloat)distance
                       Status:(NSInteger)status;

@end
