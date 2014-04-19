//
//  SportDataView.h
//  DemoProject
//
//  Created by Proint on 14-4-19.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>

enum SportDataViewType {
    DataViewType_km = 1,
    DataViewType_cal,
    DataViewType_step,
    };

@interface SportDataView : UIView

@property(nonatomic, assign)NSInteger viewType;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


- (id)initWithFrame:(CGRect)frame  DataViewType:(NSInteger)type;
- (void)setToday:(NSInteger)today Total:(NSInteger)total;

@end
