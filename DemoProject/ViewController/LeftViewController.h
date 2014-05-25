//
//  LeftViewController.h
//  DemoProject
//
//  Created by Proint on 14-3-18.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BaseViewController.h"


@interface LeftViewController : BaseViewController
<UITableViewDelegate, UITableViewDataSource>

@property(retain, nonatomic)UITableView *bodyTableView;

@end


