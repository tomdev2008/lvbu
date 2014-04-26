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
@property(nonatomic, assign)float newContentOffsetX;


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
        
        
        //获取泡友
        NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
        [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE]
                      forKey:@"scode"];
        
        
        HttpRequest *httpReq = [[HttpRequest alloc] init];
        httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_GETFANS];
        httpReq.bodyParams = bodyParams;
        [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
            
            NSLog(@"result = %@", result);
            NSLog(@"testGetFans.msg = %@", [result valueForKey:@"msg"]);
        } Failure:^(NSError *err) {
            NSLog(@"error = %@", [err description]);
        }];
        
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
    
    UIImageView *fullBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamedNoCache:@"MainView_background.png"]];
    fullBackgroundImageView.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:fullBackgroundImageView];
    
    AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
    
    
    //自定义导航栏
    CGRect navBarFrame = [adapt getCustomNavigationBarFrame];
    self.customNavigationBar = [UIFactory createImageViewWithRect:navBarFrame
                                                            image:nil];
    [self.customNavigationBar setUserInteractionEnabled:YES];
    [self.customNavigationBar setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:self.customNavigationBar];
    
    
    
    self.menuButton = [UIFactory createButtonWithRect:CGRectMake(4, 5, 60, 34)
                                                  normal:@""
                                               highlight:@""
                                                selector:@selector(onBack:)
                                                  target:self];
    [self.menuButton setBackgroundColor:[UIColor redColor]];
    [self.menuButton setTitle:@"菜单" forState:UIControlStateNormal];
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
    

    self.addButton = [UIFactory createButtonWithRect:CGRectMake(240, 5, 60, 34)
                                                 normal:@""
                                              highlight:@""
                                               selector:@selector(onAdd:)
                                                 target:self];
    
    [self.addButton setBackgroundColor:[UIColor redColor]];
    [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.addButton];
    


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
    self.partTableView.pullDelegate = self;
    self.partTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    self.partTableView.pullBackgroundColor = [UIColor yellowColor];
    self.partTableView.pullTextColor = [UIColor blackColor];

    
    tableFrame.origin.x += 320;
    self.nearbyTableView = [[PullTableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.nearbyTableView.dataSource = self;
    self.nearbyTableView.pullDelegate = self;
    self.nearbyTableView.pullArrowImage = [UIImage imageNamed:@"blueArrow"];
    self.nearbyTableView.pullBackgroundColor = [UIColor redColor];
    self.nearbyTableView.pullTextColor = [UIColor blackColor];
    

    [self.bodyScrollView addSubview:self.partTableView];
    [self.bodyScrollView addSubview:self.nearbyTableView];
    

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


#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.contentOffsetX = self.bodyScrollView.contentOffset.x;
    NSLog(@"self.contentOffsetX  = %f", self.contentOffsetX);
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    self.oldContentOffsetX = self.bodyScrollView.contentOffset.x;
    if (self.contentOffsetX == 0 && self.oldContentOffsetX == 0) {
        [self showLeftView];
    }
    NSLog(@"self.contentOffsetX = %f; self.oldContentOffsetX  = %f", self.contentOffsetX, self.oldContentOffsetX);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat pageWidth = self.bodyScrollView.frame.size.width;
//    int page = floor((self.bodyScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    [self.bodyScrollView setContentOffset:CGPointMake(320 * page, 0)];
//    NSLog(@"self.contentOffsetX  = %f", self.contentOffsetX);
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


#pragma mark - UITableView delegate

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
    return 5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *partCellIdentifier = @"partCell";
    static NSString *nearbyCellIdentifier = @"nearbyCell";
    
    UITableViewCell *cell = nil;
    if (tableView == self.partTableView) {
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:partCellIdentifier];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:partCellIdentifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"Row %i", indexPath.row];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:nearbyCellIdentifier];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nearbyCellIdentifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"Row %i", indexPath.row];
    }

    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.partTableView) {
        return [NSString stringWithFormat:@"parterTable Section %i  here!", section];
    } else {
        return [NSString stringWithFormat:@"nearbyTable Section %i  here!", section];
    }
    

}

//- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return [NSString stringWithFormat:@"Section %i ends here!", section];
//    
//}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    [self performSelector:@selector(refreshTable:) withObject:pullTableView afterDelay:3.0f];

}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{

    [self performSelector:@selector(loadMoreDataToTable:) withObject:pullTableView afterDelay:1.0f];
}

@end
