//
//  ModifyPwdViewController.h
//  DemoProject
//
//  Created by zzc on 14-4-27.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BaseViewController.h"

@interface ModifyPwdViewController : BaseViewController<UIGestureRecognizerDelegate>

@property(retain, nonatomic) UIView *backgroundView;                  //背景
@property(retain, nonatomic) UIView *customNavigationBar;                   //导航栏背景
@property(retain, nonatomic) UIButton *cancelButton;                        //取消按钮
@property(retain, nonatomic) UILabel *titleLabel;                           //标题栏

@property(retain, nonatomic) UITextField *myOldPwdTextField;
@property(retain, nonatomic) UITextField *myNewPwdTextField;
@property(retain, nonatomic) UITextField *myConfirmPwdTextField;
@property(retain, nonatomic) UIButton    *doneButton;

@property(nonatomic, retain)UITapGestureRecognizer *tapGestureRecognizer;

@end
