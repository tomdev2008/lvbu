//
//  ChainCell.m
//  LVBU
//
//  Created by _xLonG on 14-4-17.
//  Copyright (c) 2014年 PK. All rights reserved.
//

#import "ChainCell.h"

@implementation ChainCell
{
    UILabel * _titleLabel;
    UILabel * _modelLabel;
    UILabel * _brandLabel;
    UILabel * _dataLabel;
    UILabel * _leftLabel;
    UILabel * _rightLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 100, 20)];
        _titleLabel.text=@"手环信息";
        _titleLabel.font=[UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_titleLabel];
        
        NSArray * arr1 = @[@"型号:",@"品牌认证:",@"上次数据同步时间:"];
        NSArray * arr2  =@[@"KU15462123",@"REALLYBE",@"2014-04-07  16:25"];
        
        
        
        
        for (int i=0; i<3; i++) {
            _leftLabel =[[UILabel alloc]init];
            _leftLabel.text=arr1[i];
            CGSize size = [self calculatSize:_leftLabel.text withMaxWidth:320];
            _leftLabel.frame = CGRectMake(20, 50+22*i, size.width, 20);
            _leftLabel.adjustsFontSizeToFitWidth=YES;
            _leftLabel.font =[UIFont systemFontOfSize:14.0];
            _leftLabel.textColor=[UIColor grayColor];
            [self.contentView addSubview:_leftLabel];
            
            _rightLabel =[[UILabel alloc]init];
            _rightLabel.text=arr2[i];
            CGSize size1 = [self calculatSize:_rightLabel.text withMaxWidth:320];
            _rightLabel.frame = CGRectMake(15+size.width, 50+22*i, size1.width, 20);
            _rightLabel.adjustsFontSizeToFitWidth=YES;
            _rightLabel.font =[UIFont systemFontOfSize:14.0];
            _rightLabel.textColor=[UIColor grayColor];
            [self.contentView addSubview:_rightLabel];
            
            
        }
        
    }
    return self;
}
- (CGSize)calculatSize:(NSString *)str withMaxWidth:(CGFloat)width
{
    // 判断系统版本号
    CGFloat f = [UIDevice currentDevice].systemVersion.floatValue;
    CGSize size;
    if (f >= 7.0) {
        // 计算 7.0计算方法
        UIFont * font = [UIFont systemFontOfSize:17];
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        size = [str boundingRectWithSize:CGSizeMake(width, 2000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        //            NSLog(@"size is %f %f",size.width,size.height);
        
    }else{
      
        size = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(width, 2000)];
    }
    return size;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
