//
//  SystemCell.m
//  LVBU
//
//  Created by _xLonG on 14-4-24.
//  Copyright (c) 2014年 PK. All rights reserved.
//

#import "SystemCell.h"

@implementation SystemCell
{
    UISwitch * _switch;
    UILabel * _msgLabel;
    UILabel * _titleLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
        _titleLabel.text=@"系统信息";
        _titleLabel.font=[UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_titleLabel];
        
        
        NSArray * arr = @[@"***********",@"---------"];
        for(int i=0;i<2;i++){
        _msgLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 40+45*i, 150, 50)];
        _msgLabel.text=arr[i];
        _msgLabel.font=[UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_msgLabel];
            
            
            _switch = [[UISwitch alloc] initWithFrame:CGRectMake(230, 40+45*i, 80, 50)];
            
            [_switch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
            [self.contentView addSubview:_switch];
        }
        
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}
- (void)switchChange:(UISwitch *)s
{
    //    NSLog(@"....%d....",s.on);
    switch (s.on) {
        case 0:
            break;
        case 1:
            break;
        default:
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
