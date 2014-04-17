//
//  SplashViewController.m
//  DemoProject
//
//  Created by zzc on 13-12-26.
//  Copyright (c) 2013年 zzc. All rights reserved.
//

#import "SplashViewController.h"
#import "AppCore.h"
#import "HttpRequest.h"


@interface SplashViewController ()

- (void)onStart;

@end

@implementation SplashViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        if (isIP5Screen) {
            self.splashImage = [UIImage imageNamed:@"Default-568h@2x.png"];
        } else {
            self.splashImage = [UIImage imageNamed:@"Default@2x.png"];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
}

- (void)loadView
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:self.splashImage];
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imgView.contentMode = UIViewContentModeScaleAspectFill; // UIViewContentModeCenter;
    self.view = imgView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];

    [self performSelector:@selector(onStart)
               withObject:nil
               afterDelay:2.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - private

- (void)onStart
{
    //动画初始化
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1.0f;          //动画时长
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = @"fade";           //过度效果
    //animation.subtype = @"formLeft";  //过渡方向
    animation.startProgress = 0.0;      //动画开始起点(在整体动画的百分比)
    animation.endProgress = 1.0;        //动画停止终点(在整体动画的百分比)
    animation.removedOnCompletion = NO;
    self.view.userInteractionEnabled = NO;
    [self.navigationController.view.layer addAnimation:animation forKey:@"animation"];
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    [self.navigationController popToRootViewControllerAnimated:NO];

}


@end
