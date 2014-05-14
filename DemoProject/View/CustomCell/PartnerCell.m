//
//  PartnerCell.m
//  DemoProject
//
//  Created by Proint on 14-4-17.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "PartnerCell.h"
#import "AppCore.h"

@interface PartnerCell()

@property(nonatomic, strong)UITapGestureRecognizer *tapGesture;
@property(nonatomic, strong)UISwipeGestureRecognizer *leftSwipeGesture;
@property(nonatomic, strong)UISwipeGestureRecognizer *rightSwipeGesture;

@end

@implementation PartnerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)awakeFromNib
{
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(onTap)];
    self.tapGesture.delegate = self;
    [self.tapGesture setNumberOfTapsRequired:1];
    [self.tapGesture setNumberOfTouchesRequired:1];
    
    self.leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(onLeftSwipe)];
    self.leftSwipeGesture.numberOfTouchesRequired = 1;
    self.leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    self.rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(onRightSwipe)];
    self.rightSwipeGesture.numberOfTouchesRequired = 1;
    self.rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:self.tapGesture];
    [self addGestureRecognizer:self.leftSwipeGesture];
    [self addGestureRecognizer:self.rightSwipeGesture];
    
    
    [self.inviteButton setTitleColor:RGBCOLOR(106, 161, 209) forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:RGBCOLOR(106, 161, 209) forState:UIControlStateNormal];
    [self.inviteButton setHidden:NO];
    [self.deleteButton setHidden:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)onTap
{
    [self.inviteButton setHidden:NO];
    [self.deleteButton setHidden:YES];
}

- (void)onLeftSwipe
{
    if (self.deleteButton.isHidden) {
        [self.inviteButton setHidden:YES];
        [self.deleteButton setHidden:NO];
    } else {
        [self.inviteButton setHidden:NO];
        [self.deleteButton setHidden:YES];
    }

}


- (void)onRightSwipe
{
    if (self.deleteButton.isHidden) {
        [self.inviteButton setHidden:YES];
        [self.deleteButton setHidden:NO];
    } else {
        [self.inviteButton setHidden:NO];
        [self.deleteButton setHidden:YES];
    }

}


#pragma mark - UIGesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([[touch view] isKindOfClass:[UITextField class]] ||
        [[touch view] isKindOfClass:[UIButton class]]) {
        return NO;
    } else {
        return YES;
    }
}


@end
