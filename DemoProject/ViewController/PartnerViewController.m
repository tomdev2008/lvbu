//
//  PartnerViewController.m
//  DemoProject
//
//  Created by Proint on 14-4-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "PartnerViewController.h"
#import "SearchViewController.h"

#import "TestHttpRequest.h"

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
    
//    UIImageView *fullBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamedNoCache:@"MainView_background.png"]];
//    fullBackgroundImageView.frame = [[UIScreen mainScreen] bounds];
//    [self.view addSubview:fullBackgroundImageView];
    
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
                                                selector:@selector(onBack:)
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
	self.bodyScrollView.scrollEnabled   = YES;
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
    self.partTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    self.partTableView.pullBackgroundColor = [UIColor yellowColor];
    self.partTableView.pullTextColor = [UIColor blackColor];

    
    tableFrame.origin.x += 320;
    self.nearbyTableView = [[PullTableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.nearbyTableView.dataSource = self;
    self.nearbyTableView.delegate = self;
    self.nearbyTableView.pullDelegate = self;
    self.nearbyTableView.pullArrowImage = [UIImage imageNamed:@"blueArrow"];
    self.nearbyTableView.pullBackgroundColor = [UIColor redColor];
    self.nearbyTableView.pullTextColor = [UIColor blackColor];
    

    [self.bodyScrollView addSubview:self.partTableView];
    [self.bodyScrollView addSubview:self.nearbyTableView];
    

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
            self.partnerArr = [result valueForKey:@"fans"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.partTableView reloadData];
            });
            
        } else {
            
        }
        
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
        [self reportNetworkError:err];
    }];
    
    
    
    //获取附近的人
    HttpRequest *nearbyHttpReq = [[HttpRequest alloc] init];
    nearbyHttpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_NEARBY];
    nearbyHttpReq.bodyParams = bodyParams;
    [nearbyHttpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        
        NSLog(@"result = %@", result);
        NSInteger ret = [[result valueForKey:@"ret"] integerValue];
        if (ret == 0) {
            
            //成功获取附近的人
            self.nearbyArr = [result valueForKey:@"users"];
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


- (void)onBack:(id)sender
{
    self.bodyScrollView.scrollEnabled =NO;
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
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


- (void)onInvite:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 1000;
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
        NSLog(@"testEye.msg = %@", [result valueForKey:@"msg"]);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}



- (void)onInviteNearby:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag / 100;
    
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
        NSLog(@"testEye.msg = %@", [result valueForKey:@"msg"]);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
}



- (void)onAddNearby:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag / 100;
    NSDictionary *user = [self.nearbyArr objectAtIndex:index];
    
    NSLog(@"invite [%@]~~~", [user valueForKey:@"u_nick_name"]);
    NSInteger uid = [[user valueForKey:@"u_id"] integerValue];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    [bodyParams setValue:[NSNumber numberWithInt:uid] forKey:@"uid"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_EYE];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        
        NSLog(@"result = %@", result);
        NSLog(@"testEye.msg = %@", [result valueForKey:@"msg"]);

        
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
}


#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.contentOffsetX = self.bodyScrollView.contentOffset.x;
    self.contentOffsetY = self.bodyScrollView.contentOffset.y;
    NSLog(@"self.contentOffsetX  = %f", self.contentOffsetX);
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    self.oldContentOffsetX = self.bodyScrollView.contentOffset.x;
    self.oldContentOffsetY = self.bodyScrollView.contentOffset.y;
    if (self.contentOffsetX == 0 && self.oldContentOffsetX == 0 && scrollView == self.bodyScrollView) {
        [self showLeftView];
    }
    NSLog(@"self.contentOffsetX = %f; self.oldContentOffsetX  = %f", self.contentOffsetX, self.oldContentOffsetX);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)showLeftView
{
    self.bodyScrollView.scrollEnabled =NO;
    [self.viewDeckController toggleLeftViewAnimated:YES];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
}


#pragma mark IIViewDeckControllerDelegate

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    self.bodyScrollView.scrollEnabled =YES;
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
}




#pragma mark - Refresh and load more methods

- (void) refreshTable:(PullTableView *)pullTableView
{
    /*
     
     Code to actually refresh goes here.
     
     */
    pullTableView.pullLastRefreshDate = [NSDate date];
    pullTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable:(PullTableView *)pullTableView
{
    /*
     
     Code to actually load more data goes here.
     
     */
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
        
        //跑友
        PartnerCell *cell = [tableView dequeueReusableCellWithIdentifier:partCellIdentifier];
        if(!cell) {
            cell = [CellFactory createPartnerCell];
        }
        
        NSDictionary *fan = [self.partnerArr objectAtIndex:indexPath.row];
        
        //设置头像
        [cell.avatarImgView setImageWithURL:[fan valueForKey:@"u_head_photo"]
                           placeholderImage:[UIImage imageNamed:@""]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                         [cell.avatarImgView setImage:image];
                                      });
                                  }];
        
        //设置昵称
        cell.nameLabel.text = [fan valueForKey:@"u_nick_name"];
        cell.inviteButton.tag = 1000+indexPath.row;
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
        
        //设置头像
        [cell.avatarImgView setImageWithURL:[user valueForKey:@"u_head_photo"]
                           placeholderImage:[UIImage imageNamed:@""]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [cell.avatarImgView setImage:image];
                                      });
                                  }];
        
        //设置昵称
        cell.nameLabel.text = [user valueForKey:@"u_nick_name"];
        cell.inviteButton.tag = 10+100 * indexPath.row;
        [cell.inviteButton addTarget:self
                              action:@selector(onInviteNearby:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        cell.addButton.tag = 20+100 * indexPath.row;
        [cell.addButton addTarget:self
                              action:@selector(onAddNearby:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        resultCell = cell;
    }

    return resultCell;
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
