//
//  PartnerViewController.m
//  DemoProject
//
//  Created by Proint on 14-4-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "PartnerViewController.h"
#import "SearchViewController.h"

@interface PartnerViewController ()


@property(nonatomic, retain)PullTableView *partTableView;
@property(nonatomic, retain)PullTableView *nearbyTableView;




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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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

- (void)onPartner:(id)sender
{

}

- (void)onNearby:(id)sender
{

}

- (void)onAdd:(id)sender
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
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
