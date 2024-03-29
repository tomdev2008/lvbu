//
//  PartnerViewController.m
//  DemoProject
//
//  Created by Proint on 14-4-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "PartnerViewController.h"
#import "SearchViewController.h"
#import "SportViewController.h"
#import "AppDelegate.h"


@interface PartnerViewController ()


@property(nonatomic, retain)PullTableView *partTableView;
@property(nonatomic, retain)PullTableView *nearbyTableView;
@property(nonatomic, retain)NSMutableArray *nearbyArr;
@property(nonatomic, retain)NSMutableArray *partnerArr;


@property(nonatomic, assign)float contentOffsetX;
@property(nonatomic, assign)float oldContentOffsetX;
@property(nonatomic, assign)float contentOffsetY;
@property(nonatomic, assign)float oldContentOffsetY;


- (void)onPartner:(id)sender;
- (void)onNearby:(id)sender;
- (void)onAdd:(id)sender;

@end

@implementation PartnerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.partnerArr = [[NSMutableArray alloc] initWithCapacity:0];
        self.nearbyArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.viewDeckController.delegate = self;
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
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
    
    
    
    self.menuButton = [UIFactory createButtonWithRect:CGRectMake(8, 5, 40, 35)
                                                  normal:@""
                                               highlight:@""
                                                selector:@selector(onMenu:)
                                                  target:self];
    [self.menuButton setImage:[UIImage imageNamedNoCache:@"Global_menu.png"]
                     forState:UIControlStateNormal];
    [self.menuButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.customNavigationBar addSubview:self.menuButton];

    
    self.partnerButton = [UIFactory createButtonWithRect:CGRectMake(160 - 60, 5, 60, 34)
                                               normal:@""
                                            highlight:@""
                                             selector:@selector(onPartner:)
                                               target:self];
    [self.partnerButton setBackgroundColor:[UIColor redColor]];
    [self.partnerButton setTitle:@"跑伴" forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.partnerButton];


    self.nearbyButton = [UIFactory createButtonWithRect:CGRectMake(160, 5, 60, 34)
                                               normal:@""
                                            highlight:@""
                                             selector:@selector(onNearby:)
                                               target:self];
    
    [self.nearbyButton setBackgroundColor:[UIColor redColor]];
    [self.nearbyButton setTitle:@"周边" forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.nearbyButton];
    

    self.searchButton = [UIFactory createButtonWithRect:CGRectMake(272, 5, 40, 35)
                                                 normal:@""
                                              highlight:@""
                                               selector:@selector(onAdd:)
                                                 target:self];
    
//    [self.searchButton setBackgroundColor:[UIColor redColor]];
//    [self.searchButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.searchButton setImage:[UIImage imageNamedNoCache:@"Partner_search_n.png"]
                     forState:UIControlStateNormal];
    [self.searchButton setImage:[UIImage imageNamedNoCache:@"Partner_search_c.png"]
                       forState:UIControlStateHighlighted];
    [self.searchButton setImageEdgeInsets:UIEdgeInsetsMake(6, 10, 7, 9)];
    [self.customNavigationBar addSubview:self.searchButton];
    


    //背景view
    CGRect backViewFrame = [adapt getBackgroundViewFrame];
    
    self.bodyScrollView = [[UIScrollView alloc] initWithFrame:backViewFrame];
    self.bodyScrollView.contentSize = CGSizeMake(320*2, CGRectGetHeight(backViewFrame));
    self.bodyScrollView.delegate    = self;
	[self.bodyScrollView setBackgroundColor:[UIColor clearColor]];
	[self.bodyScrollView setCanCancelContentTouches:NO];
	self.bodyScrollView.indicatorStyle  = UIScrollViewIndicatorStyleWhite;
	self.bodyScrollView.scrollEnabled   = NO;
    self.bodyScrollView.bounces         = NO;
	self.bodyScrollView.pagingEnabled   = YES;
    self.bodyScrollView.scrollsToTop    = NO;
    self.bodyScrollView.showsHorizontalScrollIndicator  = NO;
    self.bodyScrollView.showsVerticalScrollIndicator    = NO;
    [self.view addSubview:self.bodyScrollView];


    CGRect tableFrame = [self.bodyScrollView bounds];
    self.partTableView = [[PullTableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.partTableView.dataSource = self;
    self.partTableView.delegate = self;
    self.partTableView.pullDelegate = self;
    //[self.partTableView setEditing:YES];
    self.partTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    self.partTableView.pullBackgroundColor = RGBCOLOR(226, 231, 236);
    self.partTableView.pullTextColor = RGBCOLOR(86, 108, 135);

    tableFrame.origin.x += 320;
    self.nearbyTableView = [[PullTableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.nearbyTableView.dataSource = self;
    self.nearbyTableView.delegate = self;
    self.nearbyTableView.pullDelegate = self;
    //[self.nearbyTableView setEditing:YES];
    self.nearbyTableView.pullArrowImage = [UIImage imageNamed:@"blueArrow"];
    self.nearbyTableView.pullBackgroundColor = RGBCOLOR(226, 231, 236);
    self.nearbyTableView.pullTextColor = RGBCOLOR(86, 108, 135);
    

    [self.bodyScrollView addSubview:self.partTableView];
    [self.bodyScrollView addSubview:self.nearbyTableView];
    
    
    
    
    [self getFriend];
    [self getNearby];

  }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)dealloc
{
    self.partTableView = nil;
    self.nearbyTableView = nil;
}




#pragma mark - private



- (void)getFriend
{
    //获取好友列表
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE]
                  forKey:@"scode"];
    
    HttpRequest *partHttpReq = [[HttpRequest alloc] init];
    partHttpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_GETFANS];
    partHttpReq.bodyParams = bodyParams;
    [partHttpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        
        NSLog(@"result = %@", result);
        NSInteger ret = [[result valueForKey:@"ret"] integerValue];
        if (ret == 0) {
            
            //成功获取我的好友
            self.partnerArr = [NSMutableArray arrayWithArray:[result valueForKey:@"fans"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.partTableView reloadData];
            });
            
        } else {
            
        }
        
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
        [self reportNetworkError:err];
    }];
    
    
    
    
}

- (void)getNearby
{
    //获取附近的人
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE]
                  forKey:@"scode"];
    
    HttpRequest *nearbyHttpReq = [[HttpRequest alloc] init];
    nearbyHttpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_NEARBY];
    nearbyHttpReq.bodyParams = bodyParams;
    [nearbyHttpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        
        NSLog(@"result = %@", result);
        NSInteger ret = [[result valueForKey:@"ret"] integerValue];
        if (ret == 0) {
            
            //成功获取附近的人
            self.nearbyArr = [NSMutableArray arrayWithArray:[result valueForKey:@"users"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.nearbyTableView reloadData];
            });
            
        } else {
            
        }
        
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
        [self reportNetworkError:err];
    }];

}



- (void)onMenu:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (void)onPartner:(id)sender
{
    [self.bodyScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)onNearby:(id)sender
{
    [self.bodyScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
}

- (void)onAdd:(id)sender
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}


//邀跑好友
- (void)onInvite:(id)sender
{

    PartnerRelation *partRelation = [[CommonVariable shareCommonVariable] partRelation];
    if (partRelation != nil) {
        switch (partRelation.runStatus) {
            case RunningStatus_NORUN:
            {
                //没有运动
                break;
            }
            case RunningStatus_INVITEING:
            {
                //陪跑正在邀请
                break;
            }
            case RunningStatus_CANCEL:
            {
                //陪跑邀请被取消
                break;
            }
            case RunningStatus_REJECT:
            {
                //陪跑邀请被拒绝
                break;
            }
            case RunningStatus_ACCEPT:
            {
                //陪跑邀请被接受
                break;
            }
            case RunningStatus_TIMEOUT:
            {
                //陪跑等待超时
                break;
            }
            case RunningStatus_RUNING:
            {
                //陪跑运动中
                break;
            }
            case RunningStatus_FINISH:
            {
                //陪跑结束
                break;
            }
            default:
                break;
        }
        
        [PRPAlertView showWithTitle:@"你正在邀跑或者跑步中, 不能再邀跑其他人哦~"
                            message:nil
                        cancelTitle:@"确定"
                        cancelBlock:^{
                            
                            [self.navigationController pushViewController:kAppDelegate.sportVC animated:YES];
                        }
                         otherTitle:nil
                         otherBlock:nil];
    }
    
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 10000;
    NSDictionary *fan = [self.partnerArr objectAtIndex:index];
    
    NSLog(@"invite [%@]~~~", [fan valueForKey:@"u_nick_name"]);
    NSInteger uid = [[fan valueForKey:@"u_id"] integerValue];

    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    [bodyParams setValue:[NSNumber numberWithInt:uid] forKey:@"uid"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_INVITE];
    httpReq.bodyParams = bodyParams;

    
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        
        NSLog(@"result = %@", result);
        NSInteger ret = [[result valueForKey:@"ret"] integerValue];
        if (ret == 0) {

            //请求成功
            kAppDelegate.sportVC = [[SportViewController alloc] init];
            kAppDelegate.sportVC.curViewStatus = SPORTTYPE_PARTNER;
            kAppDelegate.sportVC.curParterBodyViewStatus = ViewStatus_SportView_inviting;
            [self.navigationController pushViewController:kAppDelegate.sportVC animated:YES];
            
        } else {
            
            //请求失败
            NSString *msg = [result valueForKey:@"msg"];
            if (msg != nil  && [msg isKindOfClass:[NSString class]]) {
                [PRPAlertView showWithTitle:msg
                                    message:nil
                                buttonTitle:@"确定"];
            }
        }
        
        
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}

//删除好友
- (void)onDelete:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 20000;
    NSDictionary *fan = [self.partnerArr objectAtIndex:index];
    
    NSLog(@"delete [%@]~~~", [fan valueForKey:@"u_nick_name"]);
    NSInteger uid = [[fan valueForKey:@"u_id"] integerValue];
    
    [self.partnerArr removeObjectAtIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.partTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationMiddle];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    [bodyParams setValue:[NSNumber numberWithInt:uid] forKey:@"uid"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_CANCEL_EYE];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
        NSString *msg = [result valueForKey:@"msg"];
        if (msg == nil  || [msg isKindOfClass:[NSNull class]]) {
            msg = @"删除成功";
        }
        [PRPAlertView showWithTitle:msg
                            message:nil
                        buttonTitle:@"确定"];
        
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];

}

//邀跑附近的人
- (void)onInviteNearby:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 20000;
    
    NSDictionary *user = [self.nearbyArr objectAtIndex:index];
    
    NSLog(@"invite [%@]~~~", [user valueForKey:@"u_nick_name"]);
    NSInteger uid = [[user valueForKey:@"u_id"] integerValue];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    [bodyParams setValue:[NSNumber numberWithInt:uid] forKey:@"uid"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_INVITE];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        
        
        NSLog(@"result = %@", result);
        NSInteger ret = [[result valueForKey:@"ret"] integerValue];
        if (ret == 0) {
            
            //请求成功
            SportViewController *sportVC = [[SportViewController alloc] init];
            sportVC.curViewStatus = SPORTTYPE_PARTNER;
            sportVC.curParterBodyViewStatus = ViewStatus_SportView_inviting;
            [self.navigationController pushViewController:sportVC animated:YES];
            
        } else {
            
            //请求失败
            NSString *msg = [result valueForKey:@"msg"];
            if (msg != nil  && [msg isKindOfClass:[NSString class]]) {
                [PRPAlertView showWithTitle:msg
                                    message:nil
                                buttonTitle:@"确定"];
            }
        }

        
        
        
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
}


//添加附近的人为好友
- (void)onAddNearby:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 30000;
    NSDictionary *user = [self.nearbyArr objectAtIndex:index];
    
    NSLog(@"add [%@]~~~", [user valueForKey:@"u_nick_name"]);
    NSInteger uid = [[user valueForKey:@"u_id"] integerValue];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    [bodyParams setValue:[NSNumber numberWithInt:uid] forKey:@"uid"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_EYE];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        
        NSLog(@"result = %@", result);
        NSString *msg = [result valueForKey:@"msg"];
        if (msg == nil  || [msg isKindOfClass:[NSNull class]]) {
            msg = @"添加成功";
        }
        [PRPAlertView showWithTitle:msg
                            message:nil
                        buttonTitle:@"确定"];

        NSLog(@"result = %@", result);
        NSInteger ret = [[result valueForKey:@"ret"] integerValue];
        if (ret == 0) {
            
            //添加成功
            [PRPAlertView showWithTitle:@"添加成功"
                                message:nil
                            buttonTitle:@"确定"];
            
        } else {
            
            //添加失败
            NSString *msg = [result valueForKey:@"msg"];
            if (msg != nil  && [msg isKindOfClass:[NSString class]]) {
                [PRPAlertView showWithTitle:msg
                                    message:nil
                                buttonTitle:@"确定"];
            }
        }

        
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
    
}



- (void)updatePartCell:(PartnerCell *)cell byFans:(NSDictionary *)fan
{
    //头像
    NSString *avatarurl = nil;
    id url = [fan valueForKey:@"u_head_photo"];
    
    if ((url == nil) || [url isKindOfClass:[NSNull class]]) {
        avatarurl = nil;
    } else {
        avatarurl = [fan valueForKey:@"u_head_photo"];
    }
    
    //昵称
    NSString *name = @"匿名用户";
    id nameId = [fan valueForKey:@"u_nick_name"];
    if ((nameId == nil) || [nameId isKindOfClass:[NSNull class]]) {
        name = @"";
    } else {
        name = [fan valueForKey:@"u_nick_name"];
    }
    
    //性别
    BOOL isMale = YES;
    id sex = [fan valueForKey:@"u_sex"];
    if ((sex == nil) || [sex isKindOfClass:[NSNull class]]) {
        isMale = YES;
    } else {
        isMale = [[fan valueForKey:@"u_sex"] integerValue] == 0;
    }
    
    //年龄
    NSInteger age = 20;
    id birth = [fan valueForKey:@"u_birth"];
    if ((birth == nil) || [birth isKindOfClass:[NSNull class]]) {
        age = 20;
    } else {
        NSString *birthday = [fan valueForKey:@"u_birth"];
        NSDate *today = [NSDate date];
        age = today.year - [[birthday substringToIndex:4] integerValue];
    }
    
    
    //距离
    CGFloat distance = 1;
    id dis = [fan valueForKey:@"u_distance"];
    if ((dis == nil) || [dis isKindOfClass:[NSNull class]]) {
        distance = 1;
    } else {
        distance = [[fan valueForKey:@"u_distance"] floatValue];
    }
    
    //状态
    NSInteger status = UserSportStatus_offline;
    id stat = [fan valueForKey:@"status"];
    if ((stat == nil) || [stat isKindOfClass:[NSNull class]]) {
        status = UserSportStatus_offline;
    } else {
        status = [[fan valueForKey:@"status"] integerValue];
    }
    
    
    [cell updateViewByAvatarUrl:avatarurl
                       NickName:name
                         IsMale:isMale
                            Age:age
                       Distance:distance
                         Status:status];
}


- (void)updateNearbyCell:(NearbyCell *)cell byUser:(NSDictionary *)user
{
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
    NSInteger status = UserSportStatus_nosport;
    id stat = [user valueForKey:@"status"];
    if ((stat == nil) || [stat isKindOfClass:[NSNull class]]) {
        status = UserSportStatus_nosport;
    } else {
        status = [[user valueForKey:@"status"] integerValue];
    }
    
    [cell updateViewByAvatarUrl:avatarurl
                       NickName:name
                         IsMale:isMale
                            Age:age
                       Distance:distance
                         Status:status];
    
}



//#pragma mark UIScrollViewDelegate
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    self.contentOffsetX = self.bodyScrollView.contentOffset.x;
//    self.contentOffsetY = self.bodyScrollView.contentOffset.y;
//    NSLog(@"self.contentOffsetX  = %f", self.contentOffsetX);
//}
//
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    
//    self.oldContentOffsetX = self.bodyScrollView.contentOffset.x;
//    self.oldContentOffsetY = self.bodyScrollView.contentOffset.y;
//    if (self.contentOffsetX == 0 && self.oldContentOffsetX == 0 && scrollView == self.bodyScrollView) {
//        [self showLeftView];
//    }
//    NSLog(@"self.contentOffsetX = %f; self.oldContentOffsetX  = %f", self.contentOffsetX, self.oldContentOffsetX);
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//}
//
//- (void)showLeftView
//{
//    self.bodyScrollView.scrollEnabled =NO;
//    [self.viewDeckController toggleLeftViewAnimated:YES];
//    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
//}


#pragma mark IIViewDeckControllerDelegate

- (void)viewDeckController:(IIViewDeckController*)viewDeckController willOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    //启用viewDeckController手势处理
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
}


- (void)viewDeckController:(IIViewDeckController*)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    //禁止viewDeckController手势处理
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
}




#pragma mark - Refresh and load more methods

- (void) refreshTable:(PullTableView *)pullTableView
{
    /*
     Code to actually refresh goes here.
     */
    
    if (pullTableView == self.partTableView) {
        [self getFriend];
    } else {
        [self getNearby];
    }
    pullTableView.pullLastRefreshDate = [NSDate date];
    pullTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable:(PullTableView *)pullTableView
{
    /*
     
     Code to actually load more data goes here.
     
     */
    
    if (pullTableView == self.partTableView) {
        [self getFriend];
    } else {
        [self getNearby];
    }
    
    pullTableView.pullTableIsLoadingMore = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    if (tableView == self.partTableView) {
        row = [self.partnerArr count];
    } else {
        row = [self.nearbyArr count];
    }
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
    static NSString *nearbyCellIdentifier   = @"NearbyCell";
    
    UITableViewCell *resultCell = nil;
    if (tableView == self.partTableView) {
        
        //炮友
        PartnerCell *cell = [tableView dequeueReusableCellWithIdentifier:partCellIdentifier];
        if(!cell) {
            cell = [CellFactory createPartnerCell];
        }
        
        NSDictionary *fan = [self.partnerArr objectAtIndex:indexPath.row];
        [self updatePartCell:cell byFans:fan];
        
        [cell.inviteButton setTag:10000+indexPath.row];
        [cell.inviteButton addTarget:self
                              action:@selector(onInvite:)
                    forControlEvents:UIControlEventTouchUpInside];

        resultCell = cell;
        
        
    } else {
        
        //附近的人
        NearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:nearbyCellIdentifier];
        if(!cell) {
            cell = [CellFactory createNearbyCell];
        }
        
        NSDictionary *user = [self.nearbyArr objectAtIndex:indexPath.row];
        [self updateNearbyCell:cell byUser:user];
        
        cell.inviteButton.tag = 20000+indexPath.row;
        [cell.inviteButton addTarget:self
                              action:@selector(onInviteNearby:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        cell.addButton.tag = 30000+indexPath.row;
        [cell.addButton addTarget:self
                              action:@selector(onAddNearby:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        resultCell = cell;
    }
    
    resultCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return resultCell;
}



-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView  editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath;
{
    NSInteger cellEditingStyle = UITableViewCellEditingStyleNone;
    if (tableView == self.partTableView) {
        cellEditingStyle = UITableViewCellEditingStyleDelete;
    }
    return cellEditingStyle;
}

////通过UITableViewDelegate方法可以实现删除 tableview中某一行
////滑动删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    if (tableView == self.partTableView) {
        //附近的人
        [self.partnerArr removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

//此时删除按钮为Delete，如果想显示为“删除” 中文的话，则需要实现
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = nil;
    if (tableView == self.partTableView) {
         title = @"删除";
    }
    return title;
}


- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"hello,  row = %d", indexPath.row);
    if (tableView == self.partTableView) {
        PartnerCell *partnerCell = (PartnerCell *)[tableView cellForRowAtIndexPath:indexPath];
        partnerCell.cellEditStatus = CellEditStatus_StartEdit;
    }
    
    
}


- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"world,  row = %d", indexPath.row);
    if (tableView == self.partTableView) {
        PartnerCell *partnerCell = (PartnerCell *)[tableView cellForRowAtIndexPath:indexPath];
        partnerCell.cellEditStatus = CellEditStatus_endEdit;
    }
}


#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.partTableView) {
        
    } else {
   
    }

    
}


#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    [self performSelector:@selector(refreshTable:) withObject:pullTableView afterDelay:2.0f];

}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable:) withObject:pullTableView afterDelay:2.0f];
}

@end
