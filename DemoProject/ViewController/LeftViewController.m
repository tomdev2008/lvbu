//
//  LeftViewController.m
//  DemoProject
//
//  Created by Proint on 14-3-18.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "AppDelegate.h"
#import "CellFactory.h"
#import "LeftViewController.h"
#import "ModifyUserInfoViewController.h"
#import "SportHistoryViewController.h"

typedef enum {
    CELL_LVBU = 0,
    CELL_PARTNER,
    CELL_MESSAGE,
    CELL_HISTORY,
    CELL_BLEDEVICE,
    CELL_MORE,
    CELL_NUMCOUNT,
    
} CELL_TYPE;

static NSString *cellIdentifier = @"LeftCellIdentifier";

@interface LeftViewController ()

//table headview
@property(nonatomic, strong)UIButton *headerView;
@property(nonatomic, strong)UIImageView *avatarImgView;
@property(nonatomic, strong)UILabel *nicknameLabel;


@property(nonatomic, strong)LeftViewCell *lvbuCell;
@property(nonatomic, strong)LeftViewCell *partnerCell;
@property(nonatomic, strong)LeftViewCell *messageCell;
@property(nonatomic, strong)LeftViewCell *historyCell;
@property(nonatomic, strong)LeftViewCell *bleDeviceCell;
@property(nonatomic, strong)LeftViewCell *moreCell;

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

        self.lvbuCell       = [CellFactory createLeftViewCellWithIdentifier:cellIdentifier];
        self.partnerCell    = [CellFactory createLeftViewCellWithIdentifier:cellIdentifier];
        self.messageCell    = [CellFactory createLeftViewCellWithIdentifier:cellIdentifier];
        self.historyCell    = [CellFactory createLeftViewCellWithIdentifier:cellIdentifier];
        self.bleDeviceCell  = [CellFactory createLeftViewCellWithIdentifier:cellIdentifier];
        self.moreCell       = [CellFactory createLeftViewCellWithIdentifier:cellIdentifier];
        
        [self.lvbuCell.titleLabel       setText:@"侣步"];
        [self.partnerCell.titleLabel    setText:@"陪伴"];
        [self.messageCell.titleLabel    setText:@"消息中心"];
        [self.historyCell.titleLabel    setText:@"历史运动记录"];
        [self.bleDeviceCell.titleLabel  setText:@"蓝牙设备"];
        [self.moreCell.titleLabel       setText:@"更多"];
        
        [self.lvbuCell.iconImgView      setImage:[UIImage imageNamedNoCache:@"Menu_lvbu.png"]];
        [self.partnerCell.iconImgView   setImage:[UIImage imageNamedNoCache:@"Menu_partner.png"]];
        [self.messageCell.iconImgView   setImage:[UIImage imageNamedNoCache:@"Menu_message.png"]];
        [self.historyCell.iconImgView   setImage:[UIImage imageNamedNoCache:@"Menu_history.png"]];
        [self.bleDeviceCell.iconImgView setImage:[UIImage imageNamedNoCache:@"test1.png"]];
        [self.moreCell.iconImgView      setImage:[UIImage imageNamedNoCache:@"Menu_more.png"]];
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
    [self.view setBackgroundColor:RGBCOLOR(0, 37, 73)];
    
    
    //bodyTableView
    CGRect backViewFrame = [adapt getBackgroundViewFrameWithoutNavigationBar];
     self.bodyTableView = [[UITableView alloc] initWithFrame:backViewFrame
                                                        style:UITableViewStylePlain];
    [self.bodyTableView setBackgroundColor:RGBCOLOR(0, 48, 92)];
    
    
    
    //表头
    self.headerView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 92)];
    [self.headerView setBackgroundColor:RGBCOLOR(0, 37, 73)];
    [self.headerView addTarget:self
                        action:@selector(onModify)
              forControlEvents:UIControlEventTouchUpInside];
    
    //头像
    self.avatarImgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 60, 60)];
    [self.avatarImgView setImage:[UIImage imageNamed:DefaultHeadIconFileName]];
    [self.avatarImgView setBackgroundColor:[UIColor blueColor]];
    [self.headerView addSubview:self.avatarImgView];
    
    //昵称
    self.nicknameLabel = [UIFactory createLabelWith:CGRectMake(82, 35, 160, 30)
                                               text:nil
                                               font:[UIFont systemFontOfSize:18]
                                          textColor:[UIColor whiteColor]
                                    backgroundColor:[UIColor clearColor]];
    [self.nicknameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.headerView addSubview:self.nicknameLabel];
    
    self.bodyTableView.tableHeaderView = self.headerView;

    //表尾
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bodyTableView.tableHeaderView = self.headerView;
    self.bodyTableView.tableFooterView = footerView;
    
    self.bodyTableView.dataSource = self;
    self.bodyTableView.delegate = self;
    
    [self.bodyTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.bodyTableView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    static dispatch_once_t once;
    dispatch_once( &once, ^{

        //显示状态栏以及导航栏，重置bodyTableView的frame
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
        CGRect backViewFrame = [adapt getBackgroundViewFrameWithoutNavigationBar];
        self.bodyTableView.frame = backViewFrame;
    });
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [self.nicknameLabel setText:[userDefault valueForKey:KEY_CurrentUserName]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return CELL_NUMCOUNT;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {

        case CELL_LVBU:
        {
            cell = self.lvbuCell;
            break;
        }
        case CELL_PARTNER:
        {
            cell = self.partnerCell;
            break;
        }
        case CELL_MESSAGE:
        {
            cell = self.messageCell;
            break;
        }
        case CELL_HISTORY:
        {
            cell = self.historyCell;
            break;
        }
        case CELL_BLEDEVICE:
        {
            cell = self.bleDeviceCell;
            break;
        }
        case CELL_MORE:
        {
            cell = self.moreCell;
            break;
        }
        default:
            break;
    }
    
    return cell;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
    
        case CELL_LVBU:
        {
            [self onLvBu];
            break;
        }
        case CELL_PARTNER:
        {
            [self onPartner];
            break;
        }
        case CELL_MESSAGE:
        {
            [self onMessage];
            break;
        }
        case CELL_HISTORY:
        {
            [self onHistory];
            break;
        }
        case CELL_BLEDEVICE:
        {
            [self onBleDevice];
            break;
        }
        case CELL_MORE:
        {
            [self onMore];
            break;
        }
            
        default:
            break;
    }
}



#pragma mark - private

- (void)onModify
{
    ModifyUserInfoViewController *modifyUserInfoVC = [[ModifyUserInfoViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:modifyUserInfoVC];
    [self presentViewController:navigation
                       animated:YES
                     completion:^{
                         
                     }];
}

- (void)onLvBu
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        
        [kAppDelegate.rootNav setViewControllers:[NSArray arrayWithObjects:kAppDelegate.mainVC, nil]];
        self.viewDeckController.centerController = kAppDelegate.rootNav;
        
    }];
}

- (void)onPartner
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {

        [kAppDelegate.rootNav setViewControllers:[NSArray arrayWithObjects:kAppDelegate.parterVC, nil]];
        self.viewDeckController.centerController = kAppDelegate.rootNav;
        
    }];
}

- (void)onMessage
{
    
}

- (void)onHistory
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        
        SportHistoryViewController *historyVC = [[SportHistoryViewController alloc] init];
        [kAppDelegate.rootNav setViewControllers:[NSArray arrayWithObjects:historyVC, nil]];
        self.viewDeckController.centerController = kAppDelegate.rootNav;
        
    }];
}

- (void)onBleDevice
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        
//        SportHistoryViewController *historyVC = [[SportHistoryViewController alloc] init];
//        [kAppDelegate.rootNav setViewControllers:[NSArray arrayWithObjects:historyVC, nil]];
        self.viewDeckController.centerController = kAppDelegate.rootNav;
        
    }];
}

- (void)onMore
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {

        [kAppDelegate.rootNav setViewControllers:[NSArray arrayWithObjects:kAppDelegate.moreVC, nil]];
        self.viewDeckController.centerController = kAppDelegate.rootNav;
        
    }];
}


@end
