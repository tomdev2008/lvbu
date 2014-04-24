//
//  LeftViewController.m
//  DemoProject
//
//  Created by Proint on 14-4-22.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"


@interface LeftViewController ()

- (void)onMain;
- (void)onPartner;
- (void)onMore;

@end

@implementation LeftViewController

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
    
    AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
    
    UIColor *bgColor = [UIColor whiteColor];
    [self.view setBackgroundColor:bgColor];
    
    
    //背景view
    CGRect backViewFrame = [adapt getBackgroundViewFrameWithoutNavigationBar];
    self.backgroundView = [[UIView alloc] initWithFrame:backViewFrame];
    [self.view addSubview:self.backgroundView];
    
    CGRect btnFrame = CGRectMake(100, 80, 100, 60);
    self.mainButton = [UIFactory createButtonWithRect:btnFrame
                              title:@"侣步"
                          titleFont:[UIFont systemFontOfSize:18]
                         titleColor:[UIColor blueColor]
                             normal:@""
                          highlight:@""
                           selected:@""
                           selector:@selector(onMain)
                             target:self];
    [self.mainButton setBackgroundColor:[UIColor redColor]];
    [self.backgroundView addSubview:self.mainButton];
    
    btnFrame.origin.y += 100;
    self.partnerButton = [UIFactory createButtonWithRect:btnFrame
                                                   title:@"陪伴"
                                               titleFont:[UIFont systemFontOfSize:18]
                                              titleColor:[UIColor blueColor]
                                                  normal:@""
                                               highlight:@""
                                                selected:@""
                                                selector:@selector(onPartner)
                                                  target:self];
    [self.partnerButton setBackgroundColor:[UIColor redColor]];
    [self.backgroundView addSubview:self.partnerButton];
    
    btnFrame.origin.y += 100;
    self.moreButton = [UIFactory createButtonWithRect:btnFrame
                                                title:@"更多"
                                            titleFont:[UIFont systemFontOfSize:18]
                                           titleColor:[UIColor blueColor]
                                               normal:@""
                                            highlight:@""
                                             selected:@""
                                             selector:@selector(onMore)
                                               target:self];
    [self.moreButton setBackgroundColor:[UIColor redColor]];
    [self.backgroundView addSubview:self.moreButton];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private

- (void)onMain
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        
        self.viewDeckController.centerController = kAppDelegate.mainVC;
        
    }];
}

- (void)onPartner
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        
        self.viewDeckController.centerController = kAppDelegate.parterVC;
        
    }];
}

- (void)onMore
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        
        self.viewDeckController.centerController = kAppDelegate.moreVC;
        
    }];
}

@end
