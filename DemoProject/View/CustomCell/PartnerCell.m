//
//  PartnerCell.m
//  DemoProject
//
//  Created by Proint on 14-4-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "PartnerCell.h"
#import "AppCore.h"

@interface PartnerCell()

@property(nonatomic, strong)UITapGestureRecognizer *tapGesture;
@property(nonatomic, strong)UISwipeGestureRecognizer *leftSwipeGesture;
@property(nonatomic, strong)UISwipeGestureRecognizer *rightSwipeGesture;

@end

@implementation PartnerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)awakeFromNib
{
    
    self.cellEditStatus = CellEditStatus_endEdit;

    [self setBackgroundColor:RGBCOLOR(240, 240, 240)];
    [self.nameLabel setTextColor:[UIColor colorWithHex:@"#08519d"]];
    [self.ageLabel setTextColor:[UIColor colorWithHex:@"#ffffff"]];
    [self.distanceLabel setTextColor:[UIColor colorWithHex:@"#808080"]];
    [self.inviteButton setTitleColor:[UIColor colorWithHex:@"#08519d"]
                            forState:UIControlStateNormal];
    
    [self.offlineLabel setTextColor:[UIColor colorWithHex:@"#808080"]];
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (IOS7_OR_LATER) {

        self.avatarImgView.frame    = CGRectMake(11, 8, 56, 56);
        self.nameLabel.frame        = CGRectMake(75, 16, 144, 22);
        self.sexImageView.frame     = CGRectMake(75, 46, 32, 12);
        self.ageLabel.frame         = CGRectMake(90, 41, 15, 21);
        self.positionImageView.frame = CGRectMake(115, 45, 10, 13);
        self.distanceLabel.frame    = CGRectMake(126, 41, 42, 21);
        self.statusImageView.frame  = CGRectMake(170, 46, 24, 13);
        self.inviteButton.frame     = CGRectMake(264, 16, 43, 43);
        self.offlineLabel.frame     = CGRectMake(115, 40, 79, 21);
        
    } else {
        
        if (self.cellEditStatus == CellEditStatus_StartEdit) {
            
            self.avatarImgView.frame    = CGRectMake(11, 8, 56, 56);
            self.nameLabel.frame        = CGRectMake(75, 16, 144, 22);
            self.sexImageView.frame     = CGRectMake(75, 46, 32, 12);
            self.ageLabel.frame         = CGRectMake(90, 41, 15, 21);
            self.positionImageView.frame = CGRectMake(115, 45, 10, 13);
            self.distanceLabel.frame    = CGRectMake(126, 41, 42, 21);
            self.statusImageView.frame  = CGRectMake(170, 46, 24, 13);
            self.inviteButton.frame     = CGRectMake(264 - 60, 16, 43, 43);
            
            self.offlineLabel.frame     = CGRectMake(115, 40, 79, 21);
            
        } else {
            self.avatarImgView.frame    = CGRectMake(11, 8, 56, 56);
            self.nameLabel.frame        = CGRectMake(75 , 16, 144, 22);
            self.sexImageView.frame     = CGRectMake(75, 46, 32, 12);
            self.ageLabel.frame         = CGRectMake(90, 41, 15, 21);
            self.positionImageView.frame = CGRectMake(115, 45, 10, 13);
            self.distanceLabel.frame    = CGRectMake(126, 41, 42, 21);
            self.statusImageView.frame  = CGRectMake(170, 46, 24, 13);
            self.inviteButton.frame     = CGRectMake(264, 16, 43, 43);
            
            self.offlineLabel.frame     = CGRectMake(115, 40, 79, 21);
        }
    }
}


- (void)showNormalView
{
    [self.avatarImgView setHidden:NO];
    [self.nameLabel setHidden:NO];
    [self.sexImageView setHidden:NO];
    [self.ageLabel setHidden:NO];
    [self.positionImageView setHidden:NO];
    [self.distanceLabel setHidden:NO];
    [self.statusImageView setHidden:NO];
    [self.inviteButton setHidden:NO];
    [self.offlineLabel setHidden:YES];
}


- (void)updateViewByAvatarUrl:(NSString *)avatarUrl
                     NickName:(NSString *)name
                       IsMale:(BOOL)isMale
                          Age:(NSInteger)age
                     Distance:(CGFloat)distance
                       Status:(NSInteger)status
{
    [self showNormalView];
    
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
            [self.positionImageView setHidden:YES];
            [self.distanceLabel setHidden:YES];
            [self.statusImageView setHidden:YES];
            [self.inviteButton setHidden:YES];
            [self.offlineLabel setHidden:NO];
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
