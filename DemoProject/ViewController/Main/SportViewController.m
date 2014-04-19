//
//  SportViewController.m
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "SportViewController.h"

enum SPORTTYPE {
    SPORTTYPE_SELF = 1,
    SPORTTYPE_PARTNER,
    SPORTTYPE_GROUP,
    };

@interface SportViewController ()

- (void)onBack:(id)sender;
- (void)onRunAction:(id)sender;

@end

@implementation SportViewController

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
    
    
    self.selfButton = [UIFactory createButtonWithRect:CGRectMake(80, 6, 54, 32)
                                               normal:@""
                                            highlight:@""
                                             selector:@selector(onRunAction:)
                                               target:self];
    [self.selfButton setTag:SPORTTYPE_SELF];
    [self.selfButton setBackgroundColor:[UIColor redColor]];
    [self.selfButton setTitle:@"自己" forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.selfButton];
    
    self.partnerButton = [UIFactory createButtonWithRect:CGRectMake(134, 6, 54, 32)
                                               normal:@""
                                            highlight:@""
                                             selector:@selector(onRunAction:)
                                               target:self];
    [self.partnerButton setTag:SPORTTYPE_PARTNER];
    [self.partnerButton setBackgroundColor:[UIColor redColor]];
    [self.partnerButton setTitle:@"伴跑" forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.partnerButton];
    
    self.groupButton = [UIFactory createButtonWithRect:CGRectMake(188, 6, 54, 32)
                                               normal:@""
                                            highlight:@""
                                             selector:@selector(onRunAction:)
                                               target:self];
    [self.groupButton setTag:SPORTTYPE_GROUP];
    [self.groupButton setBackgroundColor:[UIColor redColor]];
    [self.groupButton setTitle:@"群跑" forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.groupButton];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRunAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
            
        case SPORTTYPE_SELF:
        {
            NSLog(@"RUN self");
            break;
        }
        case SPORTTYPE_PARTNER:
        {
            NSLog(@"RUN partner");
            break;
        }
        case SPORTTYPE_GROUP:
        {
            NSLog(@"RUN group");
            break;
        }

        default:
            break;
    }
}

@end
