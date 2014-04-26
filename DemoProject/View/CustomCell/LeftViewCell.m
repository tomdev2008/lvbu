//
//  LeftViewCell.m
//  DemoProject
//
//  Created by zzc on 14-4-26.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "LeftViewCell.h"
#import "UIFactory.h"

typedef enum {
    ROW_SINGLE = 0,                 //单行
    ROW_FIRST,                      //第一行
    ROW_MIDDLE,                     //中间行
    ROW_LAST,                       //最后一行
} UITableCellRowType;


@implementation LeftViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.hasClickBackgroud   = YES;
        self.isSelected          = NO;
        
        self.titleLabel = [UIFactory createLabelWith:CGRectMake(40, 10, 120, 40)
                                                text:nil
                                                font:[UIFont systemFontOfSize:20]
                                           textColor:[UIColor redColor]
                                     backgroundColor:[UIColor clearColor]];
        [self addSubview:self.titleLabel];
        
        
    }
    return self;
}



-(void)setCellStatus:(BOOL)highlighted{
    
    if(self.selectionStyle == UITableViewCellSelectionStyleNone)
        return;
    
    if (highlighted) {
        for(int i=0;i<[[self subviews] count];i++){
            UIView* v = [[self subviews] objectAtIndex:i];
            if([v isKindOfClass:[UILabel class]])
                ((UILabel*)v).textColor = [UIColor whiteColor];
            if([v isKindOfClass:[UIButton class]])
                ((UIButton*)v).selected = highlighted;
            if([v isKindOfClass:[UIImageView class]])
                ((UIImageView*)v).highlighted = highlighted;
            v = nil;
        }
    } else {
        for(int i=0;i<[[self subviews] count];i++){
            UIView* v = [[self subviews] objectAtIndex:i];
            if([v isKindOfClass:[UILabel class]])
                ((UILabel*)v).textColor = [UIColor blackColor];
            if([v isKindOfClass:[UIButton class]])
                ((UIButton*)v).selected = highlighted;
            if([v isKindOfClass:[UIImageView class]])
                ((UIImageView*)v).highlighted = highlighted;
            v = nil;
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    [self setCellStatus:highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self setCellStatus:selected];
}



- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}




-(void)setRowType:(int)n{
    _rowType = n;
    
    UIImage *backgroundImage = nil;
    UIImage *selectedBackgroundImage = nil;
    switch (_rowType) {
        case ROW_SINGLE:
        {
            backgroundImage = [UIImage imageNamed:@"set_bk_single_n.png"];
            if (self.hasClickBackgroud) {
                selectedBackgroundImage = [UIImage imageNamed:@"set_bk_single_c.png"];
            }
            break;
        }
        case ROW_FIRST:
        {
            backgroundImage = [UIImage imageNamed:@"set_bk_up_n@2x.png"];
            if(self.hasClickBackgroud)
                selectedBackgroundImage = [UIImage imageNamed:@"set_bk_up_c@2x.png"];
            break;
        }
        case ROW_MIDDLE:
        {
            backgroundImage = [UIImage imageNamed:@"set_bk_mid_n@2x.png"];
            if(self.hasClickBackgroud)
                selectedBackgroundImage = [UIImage imageNamed:@"set_bk_mid_c@2x.png"];
            break;
        }
        case ROW_LAST:
        {
            backgroundImage = [UIImage imageNamed:@"set_bk_down_n@2x.png"];
            if(self.hasClickBackgroud)
                selectedBackgroundImage = [UIImage imageNamed:@"set_bk_down_c@2x.png"];
            break;
        }
        default:
            break;
    }
    
    self.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedBackgroundImage];
}


- (void)setRowType:(int)rowIndex rowCount:(int)rowCount{
    
    NSInteger type = ROW_MIDDLE;
    if (rowCount == 1) {
        type = ROW_SINGLE;
    } else if (rowIndex == 0) {
        type = ROW_FIRST;
    } else if (rowIndex == rowCount - 1) {
        type = ROW_LAST;
    } else {
        type = ROW_MIDDLE;
    }
    
    [self setRowType:type];
}





@end
