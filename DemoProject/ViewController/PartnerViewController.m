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
    [self.customNavigationBar setBackgroundColor:[UIColor clearColor]];
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


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
