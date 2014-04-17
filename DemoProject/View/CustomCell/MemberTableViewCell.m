//
//  MemberTableViewCell.m
//  DemoProject
//
//  Created by Proint on 14-3-21.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "MemberTableViewCell.h"
#import "AppCore.h"

@implementation MemberTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateWithUser:(User *)user
{

    //头像
    if (user.avatarFileName != nil && [user.avatarFileName length] > 0) {
        [self.avatarImageView setImage:[[UIImage alloc] initWithContentsOfFile:user.avatarFileName]];
    } else {
        [self.avatarImageView setImage:[UIImage imageNamed:DefaultHeadIconFileName]];
    }
    
    //昵称
    [self.nameLabel setText:user.name];
    [self.selectedImageView hide];
    
}

@end
