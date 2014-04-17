//
//  BaseTableViewCell.m
//  DemoProject
//
//  Created by zzc on 14-1-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BaseTableViewCell.h"


typedef enum {
    ROWTYPE_SINGLE = 0,                 //单行
    ROWTYPE_FIRST,                      //第一行
    ROWTYPE_MIDDLE,                     //中间行
    ROWTYPE_LAST,                       //最后一行
} UITableCellRowType;

@implementation BaseTableViewCell


@synthesize rowType,isSelected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        isSelected = NO;

        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 15, 230, 18)];
        self.titleLabel .backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(50, 15, 230, 18);
}

- (void)setCustomTitle:(NSString *)title
{
    self.titleLabel.text = title;
}


-(void)setCellStatus:(BOOL)highlighted{
    
    if(self.selectionStyle == UITableViewCellSelectionStyleNone)
        return;
    
    for(int i=0;i<[[self subviews] count];i++){
        UIView* v = [[self subviews] objectAtIndex:i];
        
        //label
        if([v isKindOfClass:[UILabel class]]){
            if (highlighted) {
               ((UILabel*)v).textColor = [UIColor whiteColor];
            } else {
                ((UILabel*)v).textColor = [UIColor blackColor];
            }
        }
        
//        //button
//        if([v isKindOfClass:[UIButton class]])
//            ((UIButton*)v).selected = highlighted;
//        
//        //imageview
//        if([v isKindOfClass:[UIImageView class]])
//            ((UIImageView*)v).highlighted = highlighted;
        
        v = nil;
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

-(void)setRowType:(int)n{
    rowType = n;
    
    UIImage *backgroundImage = nil;
    UIImage *selectedBackgroundImage = nil;
    switch (rowType) {
        case ROWTYPE_SINGLE:
        {
            backgroundImage = [UIImage imageNamed:@"Basecell_bg_single_n.png"];
            selectedBackgroundImage = [UIImage imageNamed:@"Basecell_bg_single_c.png"];
            break;
        }
        case ROWTYPE_FIRST:
        {
            backgroundImage = [UIImage imageNamed:@"Basecell_bg_first_n.png"];
            selectedBackgroundImage = [UIImage imageNamed:@"Basecell_bg_first_c.png"];
            break;
        }
        case ROWTYPE_MIDDLE:
        {
            backgroundImage = [UIImage imageNamed:@"Basecell_bg_mid_n.png"];
            selectedBackgroundImage = [UIImage imageNamed:@"Basecell_bg_mid_c.png"];
            break;
        }
        case ROWTYPE_LAST:
        {
            backgroundImage = [UIImage imageNamed:@"Basecell_bg_last_n.png"];
            selectedBackgroundImage = [UIImage imageNamed:@"Basecell_bg_last_c.png"];
            break;
        }
        default:
            break;
    }
    
    self.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedBackgroundImage];
}


- (int) getRowType:(int)rowIndex rowCount:(int)rowCount{
    
    if (rowCount == 1) {
        return ROWTYPE_SINGLE;
    } else if (rowIndex == 0) {
        return ROWTYPE_FIRST;
    } else if (rowIndex == rowCount - 1) {
        return ROWTYPE_LAST;
    } else {
        return ROWTYPE_MIDDLE;
    }
}

@end
