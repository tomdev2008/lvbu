//
//  SearchViewController.h
//  DemoProject
//
//  Created by Proint on 14-4-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>


@property(nonatomic, strong)UIImageView *customNavigationBar;
@property(nonatomic, strong)UIButton    *backButton;

@property(nonatomic, retain)UIView      *backgroundView;
@property(nonatomic, retain)UITextField *inputTextfiled;
@property(nonatomic, retain)UIButton    *searchButton;
@property(nonatomic, retain)UITableView *resultTableView;


@end
