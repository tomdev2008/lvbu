//
//  SporterCountView.h
//  DemoProject
//
//  Created by zzc on 14-5-15.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SporterCountView : UIView

//正在运动的好友
@property (weak, nonatomic) IBOutlet UILabel *friendCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *friendImageView;
@property (weak, nonatomic) IBOutlet UILabel *friendTitleLabel;

//附近正在运动的人
@property (weak, nonatomic) IBOutlet UILabel *nearbyCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nearbyImageView;
@property (weak, nonatomic) IBOutlet UILabel *nearbyTitleLabel;


- (void)updateViewbyFriendCount:(NSInteger)friendCount
                    NearbyCount:(NSInteger)nearbyCount;

@end
