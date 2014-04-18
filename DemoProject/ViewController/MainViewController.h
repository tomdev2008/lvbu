//
//  MainViewController.h
//  DemoProject
//
//  Created by Proint on 14-3-18.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BaseViewController.h"
#import "AppCore.h"




@interface MainViewController: BaseViewController<UIScrollViewDelegate>

@property(nonatomic, strong)UIImageView *customNavigationBar;
@property(nonatomic, strong)UIButton    *leftButton;
@property(nonatomic, strong)UIButton    *graphButton;
@property(nonatomic, strong)UILabel     *titleLabel;




@end
