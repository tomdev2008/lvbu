//
//  SearchViewController.m
//  DemoProject
//
//  Created by Proint on 14-4-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "SearchViewController.h"
#import "CellFactory.h"

@interface SearchViewController ()

@property(nonatomic, strong)NSArray *resultArr;

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.resultArr = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.view setBackgroundColor:GlobalNavBarBgColor];
    
    AdaptiverServer *adapt = [AdaptiverServer sharedInstance];

    //自定义导航栏
    CGRect navBarFrame = [adapt getCustomNavigationBarFrame];
    self.customNavigationBar = [UIFactory createImageViewWithRect:navBarFrame
                                                            image:nil];
    [self.customNavigationBar setUserInteractionEnabled:YES];
    [self.customNavigationBar setBackgroundColor:GlobalNavBarBgColor];
    [self.view addSubview:self.customNavigationBar];
    
    self.backButton = [UIFactory createButtonWithRect:CGRectMake(6, 5, 60, 34)
                                                  normal:@""
                                               highlight:@""
                                                selector:@selector(onBack:)
                                                  target:self];
    [self.backButton setBackgroundColor:[UIColor clearColor]];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.backButton];
    
    
    
    CGRect backgroundFrame = [adapt getBackgroundViewFrame];
    self.backgroundView = [[UIView alloc] initWithFrame:backgroundFrame];
    [self.backgroundView setBackgroundColor:RGBCOLOR(240, 240, 240)];
    [self.backgroundView setUserInteractionEnabled:YES];
    [self.view addSubview:self.backgroundView];
    
    self.inputTextfield = [UIFactory createTextFieldWithRect:CGRectMake(20, 40, 230, 34)
                                                keyboardType:UIKeyboardTypeDefault
                                                      secure:NO
                                                 placeholder:@"请输入对方的账号或昵称"
                                                        font:[UIFont systemFontOfSize:15]
                                                       color:RGBCOLOR(63, 63, 63)
                                                    delegate:self];
    self.inputTextfield.borderStyle = UITextBorderStyleNone;
    self.inputTextfield.clearButtonMode = UITextFieldViewModeNever;
    [self.backgroundView addSubview:self.inputTextfield];
    
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 73, 300, 1)];
    [lineView setBackgroundColor:[UIColor blackColor]];
    [self.backgroundView addSubview:lineView];
    

    self.searchButton = [UIFactory createButtonWithRect:CGRectMake(260, 40, 40, 35)
                                                 normal:nil
                                              highlight:nil
                                               selector:@selector(onSearch)
                                                 target:self];
    [self.searchButton setImage:[UIImage imageNamedNoCache:@"Partner_search_c.png"]
                       forState:UIControlStateNormal];
    [self.searchButton setImage:[UIImage imageNamedNoCache:@"Partner_search_n.png"]
                       forState:UIControlStateHighlighted];
    [self.searchButton setImageEdgeInsets:UIEdgeInsetsMake(6, 10, 7, 9)];
    [self.backgroundView addSubview:self.searchButton];
    
    
    CGRect tableFrame = CGRectMake(0, 100, 320, CGRectGetHeight(backgroundFrame) - 100);
    self.resultTableView = [[UITableView alloc] initWithFrame:tableFrame
                                                        style:UITableViewStylePlain];
    self.resultTableView.dataSource = self;
    self.resultTableView.delegate = self;
    [self.resultTableView setBackgroundColor:[UIColor clearColor]];
    self.resultTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.backgroundView addSubview:self.resultTableView];

    
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(onTap)];
    self.tapGestureRecognizer.delegate = self;
    [self.tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private

- (void)onTap
{
    [self hideKeyboard];
}


- (void)hideKeyboard
{
    [self.inputTextfield resignFirstResponder];
}

- (void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSearch
{
    [self hideKeyboard];
    NSString *keystr = [self.inputTextfield.text trim];
    
    //keystr = @"new User";
    
    //search请求
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    [bodyParams setValue:keystr forKey:@"keystr"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_SEARCHUSER];
    httpReq.bodyParams = bodyParams;

    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *dic) {
        
        NSLog(@"result = %@", dic);
        NSInteger ret = [[dic valueForKey:@"ret"] integerValue];
        if (ret == 0) {
            //获取成功
            NSArray *resultArr = [dic valueForKey:@"users"];
            if (resultArr == nil || [resultArr count] == 0) {
                [PRPAlertView showWithTitle:@"没有找到"
                                    message:nil
                                buttonTitle:@"确定"];
            } else {
                self.resultArr = resultArr;
                [self.resultTableView reloadData];
            }
        }
        
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
}



- (void)onAdd:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSDictionary *user = [self.resultArr objectAtIndex:(btn.tag - 1000)];
    
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    [bodyParams setValue:[user valueForKey:@"u_id"] forKey:@"uid"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_EYE];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        
        NSInteger ret = [[result valueForKey:@"ret"] integerValue];
        if (ret == 0) {
            //成功
            [PRPAlertView showWithTitle:@"添加成功"
                                message:nil
                            buttonTitle:@"确定"];
        } else {
            //失败
            [PRPAlertView showWithTitle:@"添加失败"
                                message:[result valueForKey:@"msg"]
                            buttonTitle:@"确定"];
        }

    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
        [self reportNetworkError:err];
    }];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    row = [self.resultArr count];
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 72.0f;
    return height;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *partCellIdentifier     = @"PartnerCell";
    PartnerCell *cell = [tableView dequeueReusableCellWithIdentifier:partCellIdentifier];
    if(!cell) {
        cell = [CellFactory createPartnerCell];
    }
    NSDictionary *user = [self.resultArr objectAtIndex:indexPath.row];

    //头像
    NSString *avatarurl = nil;
    id url = [user valueForKey:@"u_head_photo"];
    
    if ((url == nil) || [url isKindOfClass:[NSNull class]]) {
        avatarurl = nil;
    } else {
        avatarurl = [user valueForKey:@"u_head_photo"];
    }
    
    //昵称
    NSString *name = @"匿名用户";
    id nameId = [user valueForKey:@"u_nick_name"];
    if ((nameId == nil) || [nameId isKindOfClass:[NSNull class]]) {
        name = @"";
    } else {
        name = [user valueForKey:@"u_nick_name"];
    }
    
    //性别
    BOOL isMale = YES;
    id sex = [user valueForKey:@"u_sex"];
    if ((sex == nil) || [sex isKindOfClass:[NSNull class]]) {
        isMale = YES;
    } else {
        isMale = [[user valueForKey:@"u_sex"] integerValue] == 0;
    }
    
    //年龄
    NSInteger age = 20;
    id birth = [user valueForKey:@"u_birth"];
    if ((birth == nil) || [birth isKindOfClass:[NSNull class]]) {
        age = 20;
    } else {
        NSString *birthday = [user valueForKey:@"u_birth"];
        NSDate *today = [NSDate date];
        age = today.year - [[birthday substringToIndex:4] integerValue];
    }
    
    
    //距离
    CGFloat distance = 1;
    id dis = [user valueForKey:@"u_distance"];
    if ((dis == nil) || [dis isKindOfClass:[NSNull class]]) {
        distance = 1;
    } else {
        distance = [[user valueForKey:@"u_distance"] floatValue];
    }
    
    //状态
    NSInteger status = UserSportStatus_offline;
    id stat = [user valueForKey:@"status"];
    if ((stat == nil) || [stat isKindOfClass:[NSNull class]]) {
        status = UserSportStatus_offline;
    } else {
        status = [[user valueForKey:@"status"] integerValue];
    }
    
    [cell updateViewByAvatarUrl:avatarurl
                       NickName:name
                         IsMale:isMale
                            Age:age
                       Distance:distance
                         Status:status];
    
    //设置邀请按钮
    cell.inviteButton.tag = 1000+indexPath.row;
    cell.inviteButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [cell.inviteButton setTitle:@"加好友" forState:UIControlStateNormal];
    [cell.inviteButton addTarget:self
                          action:@selector(onAdd:)
                forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - UIGesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([[touch view] isKindOfClass:[UITextField class]] ||
        [[touch view] isKindOfClass:[UIButton class]]) {
        return NO;
    } else {
        return YES;
    }
}


@end
