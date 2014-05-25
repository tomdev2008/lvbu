//
//  SporterInfoView.m
//  DemoProject
//
//  Created by zzc on 14-5-15.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "SporterInfoView.h"
#import "AppCore.h"
#import "PartnerCell.h"

@implementation SporterInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{

    //设置颜色
    [self setBackgroundColor:RGBCOLOR(240, 240, 240)];
    [self.nameLabel setTextColor:[UIColor colorWithHex:@"#08519d"]];
    [self.ageLabel setTextColor:[UIColor colorWithHex:@"#ffffff"]];
    [self.distanceLabel setTextColor:[UIColor colorWithHex:@"#808080"]];
    [self.inviteButton setTitleColor:[UIColor colorWithHex:@"#08519d"]
                            forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor colorWithHex:@"#08519d"]
                         forState:UIControlStateNormal];
}




- (void)layoutSubviews
{
    
    self.avatarImgView.frame    = CGRectMake(11, 8, 56, 56);
    self.nameLabel.frame        = CGRectMake(75, 16, 144, 22);
    self.sexImageView.frame     = CGRectMake(75, 46, 32, 12);
    self.ageLabel.frame         = CGRectMake(90, 41, 15, 21);
    self.positionImageView.frame = CGRectMake(115, 45, 10, 13);
    self.distanceLabel.frame    = CGRectMake(126, 41, 42, 21);
    self.statusImageView.frame  = CGRectMake(170, 46, 24, 13);
    self.inviteButton.frame     = CGRectMake(215, 16, 43, 43);
    self.addButton.frame        = CGRectMake(264, 16, 43, 43);
    
}




- (void)updateViewByAvatarUrl:(NSString *)avatarUrl
                     NickName:(NSString *)name
                       IsMale:(BOOL)isMale
                          Age:(NSInteger)age
                     Distance:(CGFloat)distance
                       Status:(NSInteger)status
{
    
    //设置头像
    if ([avatarUrl length] > 0) {
        [self.avatarImgView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:DefaultHeadIconFileName]];
    } else {
        [self.avatarImgView setImage:[UIImage imageNamed:DefaultHeadIconFileName]];
    }
    
    [self.nameLabel setText:name];
    [self.sexImageView setImage:[UIImage imageNamed:isMale? @"Partner_cell_male.png":@"Partner_cell_female.png"]];
    [self.ageLabel setText:[NSString stringWithFormat:@"%d", age]];
    [self.distanceLabel setText:[NSString stringWithFormat:@"%.1fkm", distance]];
    
    switch (status) {
        case UserSportStatus_offline:
        {
            break;
        }
        case UserSportStatus_nosport:
        {
            [self.statusImageView setImage:[UIImage imageNamed:@"Partner_cell_run_no.png"]];
            break;
        }
        case UserSportStatus_single:
        {
            [self.statusImageView setImage:[UIImage imageNamed:@"Partner_cell_run_single.png"]];
            break;
        }
        case UserSportStatus_double:
        {
            [self.statusImageView setImage:[UIImage imageNamed:@"Partner_cell_run_double.png"]];
            break;
        }
        default:
            break;
    }
}


@end
