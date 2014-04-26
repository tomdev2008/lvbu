//
//  LoginViewController.h
//  DemoProject
//
//  Created by zzc on 14-4-26.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BaseViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController : BaseViewController<UIGestureRecognizerDelegate>

@property(nonatomic, strong)UIImageView *customNavigationBar;
@property(nonatomic, retain)UIView      *backgroundView;
@property(nonatomic, retain)UIImageView *logoImgView;
@property(nonatomic, retain)UILabel     *appNameLabel;
@property(nonatomic, retain)UILabel     *appEnNameLabel;

@property(nonatomic, retain)UIImageView *userNameBgImgView;
@property(nonatomic, retain)UIImageView *passwordBgImgView;
@property(nonatomic, retain)UITextField *userNameTextField;
@property(nonatomic, retain)UITextField *passwordTextField;
@property(nonatomic, retain)UIButton    *loginButton;
@property(nonatomic, retain)UIButton    *regitsterButton;

@property(nonatomic, retain)UILabel     *otherLoginLabel;
@property(nonatomic, retain)UIButton    *sinaButton;
@property(nonatomic, retain)UIButton    *QQbutton;
@property(nonatomic, retain)UILabel     *copyrightLabel;

@property(nonatomic, retain)UITapGestureRecognizer *tapGestureRecognizer;
@end
