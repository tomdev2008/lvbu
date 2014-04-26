//
//  RegisterViewController.h
//  DemoProject
//
//  Created by zzc on 14-4-27.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInfoViewController.h"

@interface RegisterViewController : BaseViewController<UIGestureRecognizerDelegate>


@property(retain, nonatomic) UIView     *backgroundView;                        //背景
@property(retain, nonatomic) UIView     *customNavigationBar;                   //导航栏背景
@property(retain, nonatomic) UIButton   *backButton;                            //取消按钮
@property(retain, nonatomic) UILabel    *titleLabel;                            //标题栏


@property(nonatomic, retain)UIImageView *logoImgView;
@property(nonatomic, retain)UILabel     *appNameLabel;
@property(nonatomic, retain)UILabel     *appEnNameLabel;

@property(nonatomic, retain)UIImageView *userNameBgImgView;
@property(nonatomic, retain)UIImageView *passwordBgImgView;
@property(nonatomic, retain)UIImageView *confirmPwdBgImgView;
@property(nonatomic, retain)UITextField *userNameTextField;
@property(nonatomic, retain)UITextField *passwordTextField;
@property(nonatomic, retain)UITextField *confirmPwdTextField;
@property(nonatomic, retain)UIButton    *doneButton;

@property(nonatomic, retain)UILabel     *copyrightLabel;
@property(nonatomic, retain)UITapGestureRecognizer *tapGestureRecognizer;


@end
