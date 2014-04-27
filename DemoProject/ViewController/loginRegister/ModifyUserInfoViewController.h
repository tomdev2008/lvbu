//
//  CreateUserViewController.h
//  DemoProject
//
//  Created by Proint on 14-4-8.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "BaseViewController.h"
#import "User.h"

@interface ModifyUserInfoViewController : BaseViewController
<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIGestureRecognizerDelegate,
UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSString*   _isOrig;//是否竖排和正排
}


@property(retain, nonatomic) UIScrollView *backgroundView;                  //背景
@property(retain, nonatomic) UIView *customNavigationBar;                   //导航栏背景
@property(retain, nonatomic) UIButton *cancelButton;                        //取消按钮
@property(retain, nonatomic) UILabel *titleLabel;                           //标题栏

@property(retain, nonatomic)UIButton *avatarButton;             //头像
@property(retain, nonatomic)UIButton *maleButton;               //男
@property(retain, nonatomic)UIButton *femaleButton;             //女

@property(retain, nonatomic)UITextField *birthdayTextField;     //生日输入框
@property(retain, nonatomic)UITextField *heightTextField;       //身高输入框
@property(retain, nonatomic)UITextField *weightTextField;       //身高输入框

@property(retain, nonatomic)UIButton *doneButton;
@property(retain, nonatomic)UIButton *startButton;


@property(nonatomic, retain)UIPickerView *heightPicker;
@property(nonatomic, retain)UIPickerView *weightPicker;
@property(nonatomic, retain)UIDatePicker *birthdayPicker;


@property(strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer; //tap


@property(strong, nonatomic) UIImage    *headImage;                //用户头像
@property(strong, nonatomic) NSDate     *birthday;
@property(assign, nonatomic) NSInteger  sex;
@property(assign, nonatomic) NSInteger  height;
@property(assign, nonatomic) NSInteger  weight;



@property(assign)CGFloat moveDelta;


@end
