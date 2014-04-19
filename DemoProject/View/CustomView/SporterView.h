//
//  SporterView.h
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>

enum SportViewType {
    SportViewType_friend = 1,
    SportViewType_nearby,
    };

@interface SporterView : UIView

@property(nonatomic, assign)NSInteger viewType;
@property (weak, nonatomic) IBOutlet UIButton       *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView    *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel        *countLabel;
@property (weak, nonatomic) IBOutlet UILabel        *descLabel;

- (id)initWithFrame:(CGRect)frame  SportViewType:(NSInteger)type;
- (void)setPersonCount:(NSInteger)count;



@end
