//
//  SporterView.h
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>

enum SporterViewStatus {
    ViewStatus_nonRequest = 0,
    ViewStatus_Requested,
};


@interface SporterView : UIView
{
    NSInteger _curViewStatus;
}

@property (assign, nonatomic) NSInteger curViewStatus;

@property (weak, nonatomic) IBOutlet UIButton *peopleButton;
@property (weak, nonatomic) IBOutlet UIButton *sportButton;

@property (weak, nonatomic) IBOutlet UILabel *friendCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *friendImgView;
@property (weak, nonatomic) IBOutlet UILabel *friendTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nearbyCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nearbyImgView;
@property (weak, nonatomic) IBOutlet UILabel *nearbyTitleLabel;



@end
