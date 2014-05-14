//
//  SearchViewController.h
//  DemoProject
//
//  Created by Proint on 14-4-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchViewController : BaseViewController
<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>


@property(nonatomic, strong)UIImageView *customNavigationBar;
@property(nonatomic, strong)UIButton    *backButton;

@property(nonatomic, strong)UIView      *backgroundView;
@property(nonatomic, strong)UITextField *inputTextfield;
@property(nonatomic, strong)UIButton    *searchButton;
@property(nonatomic, strong)UITableView *resultTableView;
@property(nonatomic, strong)UITapGestureRecognizer *tapGestureRecognizer;


@end
