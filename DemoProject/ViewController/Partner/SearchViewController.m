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
    [self.backButton setBackgroundColor:[UIColor redColor]];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.backButton];
    
    
    
    CGRect backgroundFrame = [adapt getBackgroundViewFrame];
    self.backgroundView = [[UIView alloc] initWithFrame:backgroundFrame];
    [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
    [self.backgroundView setUserInteractionEnabled:YES];
    [self.view addSubview:self.backgroundView];
    
    self.inputTextfiled = [UIFactory createTextFieldWithRect:CGRectMake(60, 40, 170, 34)
                                                keyboardType:UIKeyboardTypeDefault
                                                      secure:NO
                                                 placeholder:@"search"
                                                        font:[UIFont systemFontOfSize:18]
                                                       color:[UIColor redColor]
                                                    delegate:self];
    self.inputTextfiled.borderStyle = UITextBorderStyleNone;
    [self.backgroundView addSubview:self.inputTextfiled];
    
    
    self.searchButton = [UIFactory createButtonWithRect:CGRectMake(240, 40, 60, 34)
                                                  title:@"搜索"
                                              titleFont:[UIFont systemFontOfSize:18]
                                             titleColor:[UIColor redColor]
                                                 normal:@""
                                              highlight:@""
                                               selected:@""
                                               selector:@selector(onSearch)
                                                 target:self];
    
    [self.backgroundView addSubview:self.searchButton];
    
    
    CGRect tableFrame = CGRectMake(0, 80, 320, CGRectGetHeight(backgroundFrame) - 80);
    self.resultTableView = [[UITableView alloc] initWithFrame:tableFrame
                                                        style:UITableViewStylePlain];
    self.resultTableView.dataSource = self;
    self.resultTableView.delegate = self;
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
    [self.inputTextfiled resignFirstResponder];
}

- (void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSearch
{
    [self hideKeyboard];
    NSString *keystr = [self.inputTextfiled.text trim];
    
    keystr = @"new User";
    
    //search请求
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    [bodyParams setValue:keystr forKey:@"keystr"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_SEARCHUSER];
    httpReq.bodyParams = bodyParams;
    
    __weak SearchViewController *weakSelf = self;
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
                weakSelf.resultArr = resultArr;
                [weakSelf.resultTableView reloadData];
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
    
    //设置头像
    __weak PartnerCell *weakCell = cell;
    id headUrl = [user valueForKey:@"u_head_photo"];
    if (headUrl == nil || [headUrl isKindOfClass:[NSNull class]]) {
        [cell.avatarImgView setImage:[UIImage imageNamed:@"DefaultHeadIcon.png"]];
    } else {
        [cell.avatarImgView setImageWithURL:[user valueForKey:@"u_head_photo"]
                           placeholderImage:[UIImage imageNamed:@"DefaultHeadIcon.png"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [weakCell.avatarImgView setImage:image];
                                      });
                                  }];
    }
    
    //设置昵称
    cell.nameLabel.text = [user valueForKey:@"u_nick_name"];
    cell.inviteButton.tag = 1000+indexPath.row;
    
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


@end
