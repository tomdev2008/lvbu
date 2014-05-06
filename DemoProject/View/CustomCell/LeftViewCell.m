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
        
        
        self.iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 16, 30, 30)];
        [self.iconImgView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.iconImgView];
        
        self.titleLabel = [UIFactory createLabelWith:CGRectMake(52, 11, 120, 40)
                                                text:nil
                                                font:[UIFont systemFontOfSize:20]
                                           textColor:[UIColor whiteColor]
                                     backgroundColor:[UIColor clearColor]];
        [self addSubview:self.titleLabel];
        
        
    
        
    UIImage *backgroundImg = [UIImage imageNamedNoCache:@"Basecell_bg_first_n.png"];
    UIImage *selectedBackgroundImg = [UIImage imageNamedNoCache:@"Basecell_bg_first_c.png"];
//    self.backgroundView = [[UIImageView alloc] initWithImage:backgroundImg];
//    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedBackgroundImg];
        
    self.backgroundView = [[UIImageView alloc] initWithImage:selectedBackgroundImg];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:backgroundImg];
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


@end
