//
//  SportHistoryViewController.m
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "SportHistoryViewController.h"

@interface SportHistoryViewController ()

- (void)onBack:(id)sender;


@end

@implementation SportHistoryViewController

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
    
    AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
    
    //自定义导航栏
    CGRect navBarFrame = [adapt getCustomNavigationBarFrame];
    self.customNavigationBar = [UIFactory createImageViewWithRect:navBarFrame
                                                            image:nil];
    [self.customNavigationBar setUserInteractionEnabled:YES];
    [self.customNavigationBar setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:self.customNavigationBar];
    
    self.backButton = [UIFactory createButtonWithRect:CGRectMake(4, 6, 60, 32)
                                               normal:@""
                                            highlight:@""
                                             selector:@selector(onBack:)
                                               target:self];
    [self.backButton setBackgroundColor:[UIColor redColor]];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.backButton];
    
    self.titleLabel = [UIFactory createLabelWith:CGRectMake(160 - 40, 0, 80, NavigationBarDefaultHeight)
                                            text:@"运动历史记录"
                                            font:[UIFont systemFontOfSize:18]
                                       textColor:[UIColor redColor]
                                 backgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.customNavigationBar addSubview:self.titleLabel];
    
    
    CGRect tabelFrame = [adapt getBackgroundViewFrame];
    self.historyTableView = [[UITableView alloc] initWithFrame:tabelFrame];
//    self.historyTableView.delegate = self;
//    self.historyTableView.dataSource = self;
    self.historyTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.historyTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.navigationController.viewControllers count] == 1) {
        
        //从侧边栏弹出的历史运动记录
        [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    } else {
        //从侣步弹出的历史运动记录
        [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
    }
    
}

#pragma mark - private

- (void)onBack:(id)sender
{
    
    if ([self.navigationController.viewControllers count] == 1) {
        
        //从侧边栏弹出的历史运动记录
        [self.viewDeckController toggleLeftViewAnimated:YES];
    } else {
        //从侣步弹出的历史运动记录
        [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
