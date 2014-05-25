//
//  SportViewController.m
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "SportViewController.h"
#import "ChatViewController.h"



@interface SportViewController ()

@property(nonatomic, strong)ChatViewController *partnerChatVC;
@property(nonatomic, strong)ChatViewController *groupChatVC;


- (void)onMenu:(id)sender;
- (void)onRunAction:(id)sender;

@end

@implementation SportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //初始化，默认显示自己，以及陪跑界面显示无邀跑对象
        self.curViewStatus = SPORTTYPE_SELF;
        self.curParterBodyViewStatus = ViewStatus_SportView_noPartner;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:GlobalNavBarBgColor];
    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
    [self.navigationController setNavigationBarHidden:YES];
    AdaptiverServer *adapt = [AdaptiverServer sharedInstance];
    
    
    //自定义导航栏
    CGRect navBarFrame = [adapt getCustomNavigationBarFrame];
    self.customNavigationBar = [UIFactory createImageViewWithRect:navBarFrame
                                                            image:nil];
    [self.customNavigationBar setUserInteractionEnabled:YES];
    [self.customNavigationBar setBackgroundColor:GlobalNavBarBgColor];
    [self.view addSubview:self.customNavigationBar];
    

    self.menuButton = [UIFactory createButtonWithRect:CGRectMake(8, 5, 40, 35)
                                               normal:@""
                                            highlight:@""
                                             selector:@selector(onMenu:)
                                               target:self];
    [self.menuButton setImage:[UIImage imageNamedNoCache:@"Global_menu.png"]
                     forState:UIControlStateNormal];
    [self.menuButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.customNavigationBar addSubview:self.menuButton];
    

    
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
    

    self.stopPartButton = [UIFactory createButtonWithRect:CGRectMake(282, 7, 30, 30)
                                                    title:nil
                                                titleFont:nil
                                               titleColor:nil
                                                   normal:@"Sport_finish_n.png"
                                                highlight:@"Sport_finish_c.png"
                                                selected:nil
                                                 selector:@selector(onStopPart)
                                                   target:self];
    [self.customNavigationBar addSubview:self.stopPartButton];
    
    
    self.switchGroupButton = [UIFactory createButtonWithRect:CGRectMake(246, 7, 30, 30)
                                                    title:nil
                                                titleFont:nil
                                               titleColor:nil
                                                   normal:@"Sport_refresh_n.png"
                                                highlight:@"Sport_refresh_c.png"
                                                 selected:nil
                                                 selector:@selector(onSwitchGroup)
                                                   target:self];
    [self.customNavigationBar addSubview:self.switchGroupButton];
    
    
    self.stopGroupButton = [UIFactory createButtonWithRect:CGRectMake(282, 7, 30, 30)
                                                     title:nil
                                                 titleFont:nil
                                                titleColor:nil
                                                    normal:@"Sport_finish_n.png"
                                                 highlight:@"Sport_finish_c.png"
                                                 selected:nil
                                                 selector:@selector(onStopGroup)
                                                   target:self];
    [self.customNavigationBar addSubview:self.stopGroupButton];
    
    


    CGRect backgroundFrame = [adapt getBackgroundViewFrame];
    
    //地图
    self.mainMapView = [[MKMapView alloc] initWithFrame:backgroundFrame];
    [self.mainMapView setScrollEnabled:YES];
    [self.mainMapView setDelegate:self];
    [self.mainMapView setShowsUserLocation:YES];
    [self.view addSubview:self.mainMapView];
    
    self.selfBodyView       = [[SelfView alloc] initWithFrame:backgroundFrame];
    self.partnerBodyView    = [[PartnerView alloc] initWithFrame:backgroundFrame];
    self.groupBodyView      = [[GroupView alloc] initWithFrame:backgroundFrame];
    
    
    self.selfBodyView.backMapView       = self.mainMapView;
    self.partnerBodyView.backMapView    = self.mainMapView;
    self.groupBodyView.backMapView      = self.mainMapView;
    
    
    //初始化聊天界面
//    self.partnerChatVC = [[ChatViewController alloc] init];
//    self.groupChatVC = [[ChatViewController alloc] init];
//    
//    self.partnerChatVC.view.frame = CGRectMake(0, 200, 320, 250);
//    [self.partnerBodyView addSubview:self.partnerChatVC.view];
//    
//    self.groupChatVC.view.frame = CGRectMake(0, 200, 320, 250);
//    [self.groupBodyView addSubview:self.groupChatVC.view];
    
    [self.selfBodyView setBackgroundColor:[UIColor clearColor]];
    [self.partnerBodyView setBackgroundColor:[UIColor clearColor]];
    [self.groupBodyView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.selfBodyView];
    [self.view addSubview:self.partnerBodyView];
    [self.view addSubview:self.groupBodyView];

    //当前显示自己，伴跑还是群跑
    [self showBodyView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private



- (void)showBodyView
{
    [self hideAllBodyView];
    [self hideFuncButton];

    switch (self.curViewStatus) {
        case SPORTTYPE_SELF:
        {
            //自己
            [self.selfBodyView setHidden:NO];
            break;
        }
        case SPORTTYPE_PARTNER:
        {
            //陪跑
            [self.partnerBodyView setHidden:NO];
            [self.stopPartButton setHidden:NO];
            
            
            self.partnerBodyView.curViewStatus = self.curParterBodyViewStatus;
            switch (self.curParterBodyViewStatus) {
                case ViewStatus_SportView_noPartner:
                {
                    //没有跑伴
                    break;
                }
                case ViewStatus_SportView_inviting:
                {
                    //正在邀请中
                    break;
                }
                case ViewStatus_SportView_simple:
                {
                    //简单运动数据
                    break;
                }
                case ViewStatus_SportView_detail:
                {
                    //详细运动数据
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case SPORTTYPE_GROUP:
        {
            //群跑
            [self.groupBodyView setHidden:NO];
            [self.switchGroupButton setHidden:NO];
            [self.stopGroupButton setHidden:NO];
            break;
        }
        default:
            break;
    }
}


- (void)hideAllBodyView
{
    //隐藏所有
    [self.selfBodyView setHidden:YES];
    [self.partnerBodyView setHidden:YES];
    [self.groupBodyView setHidden:YES];
}


- (void)hideFuncButton
{
    //隐藏 停止伴跑，切换群， 停止群跑 按钮
    [self.stopPartButton setHidden:YES];
    [self.switchGroupButton setHidden:YES];
    [self.stopGroupButton setHidden:YES];
}

- (void)onMenu:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];

}


- (void)onRunAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
            
        case SPORTTYPE_SELF:
        {
            NSLog(@"RUN self");
            self.curViewStatus = SPORTTYPE_SELF;
            break;
        }
        case SPORTTYPE_PARTNER:
        {
            NSLog(@"RUN partner");
            self.curViewStatus = SPORTTYPE_PARTNER;
            break;
        }
        case SPORTTYPE_GROUP:
        {
            NSLog(@"RUN group");
            self.curViewStatus = SPORTTYPE_GROUP;
            break;
        }

        default:
            break;
    }
    
    [self showBodyView];
}


- (void)onStopPart
{
    
    [PRPAlertView showWithTitle:@"是否结束伴跑？"
                        message:nil
                    cancelTitle:@"取消"
                    cancelBlock:^{
                        //nothing
                    } otherTitle:@"确定"
                     otherBlock:^{
                         NSLog(@"停止伴跑");
                     }];
    
}

- (void)onSwitchGroup
{
    
    //测试数据
//    [self.groupChatVC.msgArr addObject:@{@"uid":@"1111", @"image":@"http://www.baidu.com/img/bdlogo.gif",
//                                         @"name":@"zhouzhiqun", @"text":@"hello周志群"}];
//    [self.groupChatVC.msgArr addObject:@{@"uid":@"1111", @"image":@"http://www.baidu.com/img/bdlogo.gif",
//                                         @"name":@"zhouzhiqun", @"text":@"hello周志群"}];
//    [self.groupChatVC.msgArr addObject:@{@"uid":@"1111", @"image":@"http://www.baidu.com/img/bdlogo.gif",
//                                         @"name":@"zhouzhiqun", @"text":@"hello周志群"}];
//    
//    
//    [self.groupChatVC reloadTable];
//    [self.groupBodyView setNeedsLayout];
    
    NSLog(@"换群跑");
    [PRPAlertView showWithTitle:@"是否换群？"
                        message:nil
                    cancelTitle:@"取消"
                    cancelBlock:^{
                        //nothing
                    } otherTitle:@"确定"
                     otherBlock:^{
                         NSLog(@"换群");
                     }];
}

- (void)onStopGroup
{
    NSLog(@"停止群跑");
    [PRPAlertView showWithTitle:@"是否结束群跑？"
                        message:nil
                    cancelTitle:@"取消"
                    cancelBlock:^{
                        //nothing
                    } otherTitle:@"确定"
                     otherBlock:^{
                         NSLog(@"停止群跑");
                     }];
}




#pragma mark - MKMapViewDelegate

//MapView委托方法，当定位自身时调用
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    
    
    CLLocationCoordinate2D loc = [userLocation coordinate];
    if (loc.latitude > 0 && loc.longitude > 0 ) {
        
//        if (mapView == self.mainMapView) {
//            
//            MKUserLocation *curUserLocation = [userLocation copy];
//            self.curLocation = curUserLocation;
//            
//            //如果GPS采样超过6个，则删除第一个，并添加当前位置到数组末尾
//            if ([self.myLocationArr count] >= 6) {
//                [self.myLocationArr removeObjectAtIndex:0];
//            }
//            [self.myLocationArr addObject:curUserLocation];
//            
//        }
//        
//        //放大地图到自身的经纬度位置。
//        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, kRegionDistance, kRegionDistance);
//        [self.mainMapView setRegion:region animated:YES];
        
    }
}



@end
