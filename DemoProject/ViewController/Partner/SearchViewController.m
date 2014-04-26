//
//  SearchViewController.m
//  DemoProject
//
//  Created by Proint on 14-4-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()


- (void)onBack:(id)sender;


@end

@implementation SearchViewController

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
    
    self.backButton = [UIFactory createButtonWithRect:CGRectMake(16, 5, 60, 34)
                                                  normal:@""
                                               highlight:@""
                                                selector:@selector(onBack:)
                                                  target:self];
    [self.backButton setBackgroundColor:[UIColor redColor]];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.backButton];
    
    
    
    CGRect backgroundFrame = [adapt getBackgroundViewFrame];
    self.backgroundView = [[UIView alloc] initWithFrame:backgroundFrame];
    [self.backgroundView setUserInteractionEnabled:YES];
    [self.view addSubview:self.backgroundView];
    
    self.inputTextfiled = [UIFactory createTextFieldWithRect:CGRectMake(60, 40, 170, 34)
                                                keyboardType:UIKeyboardTypeDefault
                                                      secure:NO
                                                 placeholder:@"search"
                                                        font:[UIFont systemFontOfSize:18]
                                                       color:[UIColor redColor]
                                                    delegate:self];
    
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

- (void)onSearch
{
    NSLog(@"searching！！！");
}

@end
