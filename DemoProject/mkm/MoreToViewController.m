//
//  MoreToViewController.m
//  LVBU
//
//  Created by _xLonG on 14-4-24.
//  Copyright (c) 2014年 PK. All rights reserved.
//

#import "MoreToViewController.h"
#import "AppCore.h"

@interface MoreToViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _dataArr;
    
}
@end

@implementation MoreToViewController

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
    self.navigationItem.title= @"更多";
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
}
#pragma mark --UITableViewDelegate
//每组多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  2;
}
//每行多高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 140;
}
//返回每行的cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellId1 = @"cellIdChain";
    static NSString * cellId2 = @"cellIdSystem";
    if (indexPath.row == 0) {
        // 手环cell
       ChainCell  * cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (cell == nil) {
            cell = [[ChainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
        }
      //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        // 系统配置cell
        SystemCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (cell == nil) {
            cell = [[SystemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
        }
    
        return cell;
    
    }
}
//选中某行的代理函数
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
