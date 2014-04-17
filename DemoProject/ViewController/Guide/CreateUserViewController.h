//
//  CreateUserViewController.h
//  DemoProject
//
//  Created by Proint on 14-4-8.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BaseViewController.h"
#import "User.h"

@interface CreateUserViewController : BaseViewController
<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIGestureRecognizerDelegate,
UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSString*   _isOrig;//是否竖排和正排
}


@property(retain, nonatomic) UIScrollView *backgroundView;                  //背景
@property(retain, nonatomic) UIView *customNavigationBar;                   //导航栏背景
@property(retain, nonatomic) UIButton *backButton;                          //取消按钮
@property(retain, nonatomic) UILabel *titleLabel;                           //标题栏

@property(retain, nonatomic)UIButton *avatarButton;             //头像
@property(retain, nonatomic)UITextField *nameTextField;         //昵称输入框
@property(retain, nonatomic)UIButton *femaleButton;             //女
@property(retain, nonatomic)UIButton *maleButton;               //男
@property(retain, nonatomic)UITextField *ageTextField;          //年龄输入框
@property(retain, nonatomic)UITextField *heightTextField;       //身高输入框
@property(retain, nonatomic)UIButton *nextButton;


@property(nonatomic, retain)UIPickerView *agePicker;
@property(nonatomic, retain)UIPickerView *heightPicker;


@property(strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer; //tap

@property(strong, nonatomic) User *curUser;                     //当前用户

@property(strong, nonatomic) UIImage *headImage;                //用户头像
@property(copy, nonatomic)   NSString *headIconFileName;        //当前用户头像路径
@property(assign)CGFloat moveDelta;


@end
