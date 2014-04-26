//
//  SportViewController.h
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BaseViewController.h"

@interface SportViewController : BaseViewController

@property(nonatomic, strong)UIImageView *customNavigationBar;
@property(nonatomic, strong)UIButton *backButton;

@property(nonatomic, strong)UIButton *selfButton;
@property(nonatomic, strong)UIButton *partnerButton;
@property(nonatomic, strong)UIButton *groupButton;

@property(nonatomic, strong)UIView *selfBodyView;
@property(nonatomic, strong)UIView *partnerBodyView;
@property(nonatomic, strong)UIView *groupBodyView;

@end
