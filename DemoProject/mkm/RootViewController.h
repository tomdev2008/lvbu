//
//  RootViewController.h
//  LVBU
//
//  Created by _xLonG on 14-4-15.
//  Copyright (c) 2014年 PK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportMainVC2.h"
@interface RootViewController : UIViewController

@property(nonatomic,strong)NSString * passWDStr;
@property(nonatomic,strong)NSString * userID;
@property(nonatomic,strong)NSString * userscode;
@property(nonatomic,strong)NSString * height;
@property (strong, nonatomic) SportMainVC2  * root2;
@end
