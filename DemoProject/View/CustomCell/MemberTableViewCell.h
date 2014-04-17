//
//  MemberTableViewCell.h
//  DemoProject
//
//  Created by Proint on 14-3-21.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MemberTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;


- (void)updateWithUser:(User *)user;

@end
