//
//  SportHistoryViewController.h
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BaseViewController.h"

@interface SportHistoryViewController : BaseViewController
<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UIImageView *customNavigationBar;
@property(nonatomic, strong)UIButton *backButton;
@property(nonatomic, strong)UILabel *titleLabel;

@property(nonatomic, strong)UITableView *historyTableView;

@end
