//
//  BleMatchViewController.m
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BleMatchViewController.h"

@interface BleMatchViewController ()

- (void)onBack:(id)sender;

@end

@implementation BleMatchViewController

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
    
    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
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
    
    self.backButton = [UIFactory createButtonWithRect:CGRectMake(4, 6, 60, 32)
                                               normal:@""
                                            highlight:@""
                                             selector:@selector(onBack:)
                                               target:self];
    [self.backButton setBackgroundColor:[UIColor redColor]];
    [self.backButton setTitle:@"侣步" forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.backButton];
    
    self.titleLabel = [UIFactory createLabelWith:CGRectMake(160 - 40, 0, 80, NavigationBarDefaultHeight)
                                            text:@"蓝牙配对"
                                            font:[UIFont systemFontOfSize:18]
                                       textColor:[UIColor redColor]
                                 backgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.customNavigationBar addSubview:self.titleLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private

- (void)onBack:(id)sender
{
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
