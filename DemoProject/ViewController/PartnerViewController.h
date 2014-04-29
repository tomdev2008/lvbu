//
//  PartnerViewController.h
//  DemoProject
//
//  Created by Proint on 14-4-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BaseViewController.h"
#import "CellFactory.h"

@interface PartnerViewController : BaseViewController
<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate, UIScrollViewDelegate, IIViewDeckControllerDelegate>

@property(nonatomic, strong)UIImageView *customNavigationBar;
@property(nonatomic, strong)UIButton    *menuButton;
@property(nonatomic, strong)UIButton    *partnerButton;
@property(nonatomic, strong)UIButton    *nearbyButton;
@property(nonatomic, strong)UIButton    *addButton;
@property(nonatomic, strong)UIScrollView *bodyScrollView;


@end
