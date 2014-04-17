//
//  CreateUserViewController.m
//  DemoProject
//
//  Created by Proint on 14-4-8.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "CreateUserViewController.h"
#import "AppCore.h"
#import "User.h"


@interface CreateUserViewController ()

@property(nonatomic, assign)BOOL isFirstLanch;

- (void)onBack;
- (void)onEditAvatar;
- (void)onFemale;
- (void)onMale;
- (void)onNext;

- (void)onTap;
- (void)hideKeyboard;

@end

@implementation CreateUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
        self.curUser = nil;
        
        //判断是否第一次启动
        NSString *value = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_IsFirstLaunch];
        if (value == nil  || ![value isEqualToString:@"NO"]) {
            
            self.isFirstLanch = YES;
        } else {
            self.isFirstLanch = NO;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
    [self.navigationController setNavigationBarHidden:YES];
    
    //背景色
    [self.view setBackgroundColor:GlobalNavBarBgColor];
    
    AdaptiverServer *adapt = [AdaptiverServer sharedInstance];

    
    //导航栏
    CGRect navBarFrame = [[AdaptiverServer sharedInstance] getCustomNavigationBarFrame];
    self.customNavigationBar = [[UIView alloc] initWithFrame:navBarFrame];
    [self.customNavigationBar setBackgroundColor:GlobalNavBarBgColor];
    [self.customNavigationBar setUserInteractionEnabled:YES];
    [self.view addSubview:self.customNavigationBar];
    
    
    //返回按钮
    self.backButton = [UIFactory createButtonWithRect:CGRectMake(0, 0, 60, NavigationBarDefaultHeight)
                                               normal:@""
                                            highlight:@""
                                             selector:@selector(onBack)
                                               target:self];
    [self.backButton setTitle:[UIFactory localized:@"Global_back"] forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:self.backButton];
    
    
    //标题
    self.titleLabel = [UIFactory createLabelWith:CGRectMake(80, 0, 160, NavigationBarDefaultHeight)
                                            text:[UIFactory localized:@"CreateUser_title_create"]
                                            font:[UIFont systemFontOfSize:18]
                                       textColor:[UIColor colorWithHex:@"0xffffff"]
                                 backgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.customNavigationBar addSubview:self.titleLabel];
    

    //背景view
    CGRect backViewFrame = [adapt getBackgroundViewFrame];
    self.backgroundView = [[UIScrollView alloc] initWithFrame:backViewFrame];
    [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
    
    CGSize contentSize = backViewFrame.size;
    contentSize.height += 100;
    [self.backgroundView setContentSize:contentSize];
    [self.backgroundView setUserInteractionEnabled:YES];
    [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.backgroundView];
    
    
    //头像按钮
    self.avatarButton = [UIFactory createButtonWithRect:CGRectMake(100, 30, 120, 120)
                                                 normal:DefaultHeadIconFileName
                                              highlight:DefaultHeadIconFileName
                                               selector:@selector(onEditAvatar)
                                                 target:self];
    [self.backgroundView addSubview:self.avatarButton];
    
    

    
    CGFloat offset = 152.0f;
    CGFloat height = 55.0f;
    
    
    
    //昵称
    UIImageView *nickBGImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamedNoCache:@"CreateUser_name_bg.png"]];
    nickBGImgView.frame = CGRectMake(60, offset + height*0, 200, 19);

    
    self.nameTextField = [UIFactory createTextFieldWithRect:CGRectMake(110, offset - 10, 120, 30)
                                               keyboardType:UIKeyboardTypeDefault
                                                     secure:NO
                                                placeholder:[UIFactory localized:@"CreateUser_defaultName"]
                                                       font:[UIFont systemFontOfSize:18]
                                                      color:[UIColor redColor]
                                                   delegate:self];
    [self.nameTextField setBackgroundColor:[UIColor clearColor]];
    [self.nameTextField setTextAlignment:NSTextAlignmentCenter];
    [self.nameTextField setBorderStyle:UITextBorderStyleNone];
    
    
    
    UIImageView *sexBGImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamedNoCache:@"CreateUser_sex_bg.png"]];
    sexBGImgView.frame = CGRectMake(60, offset + height*1, 200, 19);
    
    
    self.femaleButton = [UIFactory createButtonWithRect:CGRectMake(140, offset + height*1 - 10, 29, 29)
                                                  title:nil
                                              titleFont:nil
                                             titleColor:nil
                                                 normal:@"CreateUser_female_n.png"
                                              highlight:nil
                                               selected:@"CreateUser_female_c.png"
                                               selector:@selector(onFemale)
                                                 target:self];

    
    self.maleButton = [UIFactory createButtonWithRect:CGRectMake(200, offset + height*1 - 10, 30, 30)
                                                  title:nil
                                              titleFont:nil
                                             titleColor:nil
                                                 normal:@"CreateUser_male_n.png"
                                              highlight:nil
                                               selected:@"CreateUser_male_c.png"
                                               selector:@selector(onMale)
                                                 target:self];
    

    
    UIImageView *ageBGImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamedNoCache:@"CreateUser_age_bg.png"]];
    ageBGImgView.frame = CGRectMake(60, offset + height*2, 200, 19);
    
    self.ageTextField = [UIFactory createTextFieldWithRect:CGRectMake(110, offset + height*2 - 10, 120, 30)
                                               keyboardType:UIKeyboardTypeDefault
                                                     secure:NO
                                                placeholder:[UIFactory localized:@"CreateUser_defaultAge"]
                                                       font:[UIFont systemFontOfSize:18]
                                                      color:[UIColor redColor]
                                                   delegate:self];
    [self.ageTextField setBackgroundColor:[UIColor clearColor]];
    [self.ageTextField setTextAlignment:NSTextAlignmentCenter];
    [self.ageTextField setBorderStyle:UITextBorderStyleNone];
    
    self.agePicker = [[UIPickerView alloc] init];
    self.agePicker.delegate = self;
    self.agePicker.dataSource = self;
    [self.ageTextField setInputView:self.agePicker];
    

    

    
    UIImageView *heightBGImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamedNoCache:@"CreateUser_height_bg.png"]];
    heightBGImgView.frame = CGRectMake(60, offset + height*3, 200, 19);
    
    
    self.heightTextField = [UIFactory createTextFieldWithRect:CGRectMake(110, offset + height*3 - 10, 120, 30)
                                              keyboardType:UIKeyboardTypeDefault
                                                    secure:NO
                                               placeholder:[UIFactory localized:@"CreateUser_defaultHeight"]
                                                      font:[UIFont systemFontOfSize:18]
                                                     color:[UIColor redColor]
                                                  delegate:self];
    [self.heightTextField setBackgroundColor:[UIColor clearColor]];
    [self.heightTextField setTextAlignment:NSTextAlignmentCenter];
    [self.heightTextField setBorderStyle:UITextBorderStyleNone];
    
    self.heightPicker = [[UIPickerView alloc] init];
    self.heightPicker.delegate = self;
    self.heightPicker.dataSource = self;
    [self.heightTextField setInputView:self.heightPicker];
    

    
    //下一步
    self.nextButton = [UIFactory createButtonWithRect:CGRectMake(80, CGRectGetHeight(backViewFrame) - 98, 160, 38)
                                                title:[UIFactory localized:@"CreateUser_next"]
                                            titleFont:[UIFont systemFontOfSize:18]
                                           titleColor:[UIColor whiteColor]
                                               normal:@"CreateUser_next_n.png"
                                            highlight:@"CreateUser_next_c.png"
                                             selected:nil
                                             selector:@selector(onNext)
                                               target:self];
    
    
    [self.backgroundView addSubview:nickBGImgView];
    [self.backgroundView addSubview:sexBGImgView];
    [self.backgroundView addSubview:ageBGImgView];
    [self.backgroundView addSubview:heightBGImgView];
    
    
    //去掉叉叉按钮
    [self.nameTextField setClearButtonMode:UITextFieldViewModeNever];
    [self.ageTextField setClearButtonMode:UITextFieldViewModeNever];
    [self.heightTextField setClearButtonMode:UITextFieldViewModeNever];


    [self.backgroundView addSubview:self.nameTextField];
    [self.backgroundView addSubview:self.femaleButton];
    [self.backgroundView addSubview:self.maleButton];
    [self.backgroundView addSubview:self.ageTextField];
    [self.backgroundView addSubview:self.heightTextField];
    [self.backgroundView addSubview:self.nextButton];
    
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(onTap)];
    self.tapGestureRecognizer.delegate = self;
    [self.tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self.backgroundView addGestureRecognizer:self.tapGestureRecognizer];
    
    
    [self registerKeyboardNotify];

}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupView];
    
}


- (void)dealloc
{
    [self removeKeyboardNotify];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private

- (void)setupView
{
    

    if (self.isFirstLanch) {
        
        //第一次启动，隐藏返回按钮, 
        [self.backButton setHidden:YES];
        [self.nextButton setTitle:[UIFactory localized:@"CreateUser_next"] forState:UIControlStateNormal];
        [self.titleLabel setText:[UIFactory localized:@"CreateUser_title_create"]];
    } else {
        
        
        [self.backButton setHidden:NO];
        [self.nextButton setTitle:[UIFactory localized:@"CreateUser_done"] forState:UIControlStateNormal];
        
        if (self.curUser != nil) {
            //编辑用户
            [self.titleLabel setText:[UIFactory localized:@"CreateUser_title_edit"]];
        } else {
            //创建新用户
            [self.titleLabel setText:[UIFactory localized:@"CreateUser_title_create"]];
        }

    }
    
    
    //设置初始值
    if (self.curUser != nil) {
        
        //修改用户
        //填充数据
        if (self.curUser.avatarFileName != nil  && [self.curUser.avatarFileName length] > 0) {
            [self.avatarButton setImage:[[UIImage alloc] initWithContentsOfFile:self.curUser.avatarFileName] forState:UIControlStateNormal];
        }
   
        [self.nameTextField setText:self.curUser.name];
        [self.ageTextField setText:[NSString stringWithFormat:@"%d", [self.curUser.age integerValue]]];
        [self.heightTextField setText:[NSString stringWithFormat:@"%d", [self.curUser.height integerValue]]];
        
        if ([self.curUser.isMale boolValue]) {
            //男
            [self.maleButton setSelected:YES];
            [self.femaleButton setSelected:NO];
        } else {
            
            //女
            [self.maleButton setSelected:NO];
            [self.femaleButton setSelected:YES];
        }
    
    } else {
        
        //创建新用户
        //设置默认值
        [self.nameTextField setText:@"zhouzhiqun"];
        [self.ageTextField setText:@"25"];
        [self.heightTextField setText:@"170"];
        
        //默认为女性
        [self.maleButton setSelected:NO];
        [self.femaleButton setSelected:YES];
    }
}


- (void)onBack
{
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)onEditAvatar
{
    
    [self hideKeyboard];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:[UIFactory localized:@"Modify_select"]
                                                            delegate:self
                                                   cancelButtonTitle:[UIFactory localized:@"Modify_cancel"]
                                              destructiveButtonTitle:[UIFactory localized:@"Modify_takePicture"]
                                                   otherButtonTitles:[UIFactory localized:@"Modify_selectFromPhotoAlbum"], nil];
    
    [actionSheet showInView:self.view];
}

- (void)onFemale
{
    self.femaleButton.selected = YES;
    self.maleButton.selected = NO;
}

- (void)onMale
{
    self.femaleButton.selected = NO;
    self.maleButton.selected = YES;
}



- (void)saveHeadImg:(UIImage *)image toPath:(NSString *)path
{
    //保存图片文件到沙盒
    NSData *stroreImageData = UIImageJPEGRepresentation(image, 1.0);
    [stroreImageData writeToFile:path atomically:YES];
}


- (NSString *)getHeadIconFilePathByUserId:(NSNumber *)userid
{
    NSString *headIconFileName = [NSString stringWithFormat:@"%d_headicon.png", [userid integerValue]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:headIconFileName];
}



- (void)onNext
{
    

    if (self.curUser != nil) {
        //编辑用户
        //姓名
        self.curUser.name = [self.nameTextField.text trim];
        
        //年龄
        self.curUser.age = [NSNumber numberWithInt:[self.ageTextField.text integerValue]];
        
        //性别
        BOOL ismale = (self.maleButton.selected) ? YES: NO;
        self.curUser.isMale = [NSNumber numberWithBool:ismale];
        
        //身高
        self.curUser.height = [NSNumber numberWithFloat:[[self.heightTextField.text trim] floatValue]];
        
        
        if (self.headImage != nil &&  self.curUser.avatarFileName == nil) {
            //保存头像
            self.curUser.avatarFileName = [self getHeadIconFilePathByUserId:self.curUser.userid];
        }
        

        //持久存储
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
        
        if (self.headImage != nil) {
            //保存头像
            [self saveHeadImg:self.headImage toPath:self.curUser.avatarFileName];
        }
        
        //保存当前用户
        [self saveCurrentUser:self.curUser];
        
        
    } else {
        //新建用户
        User *tempUser  = [User createEntity];
        
        //用户ID
        //tempUser.userid = [NSmu]
        
        //姓名
        tempUser.name = [self.nameTextField.text trim];
        
        //年龄
        tempUser.age = [NSNumber numberWithInt:[self.ageTextField.text integerValue]];
        
        //性别
        BOOL ismale = (self.maleButton.selected) ? YES: NO;
        tempUser.isMale = [NSNumber numberWithBool:ismale];
        
        //身高
        tempUser.height = [NSNumber numberWithFloat:[[self.heightTextField.text trim] floatValue]];
        
        if (self.headImage) {
            tempUser.avatarFileName = [self getHeadIconFilePathByUserId:tempUser.userid];
        } else {
            //使用默认头像
            tempUser.avatarFileName = nil;
        }
 
        //持久存储
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];

        
        //保存头像
        if (self.headImage) {

            [self saveHeadImg:self.headImage toPath:tempUser.avatarFileName];
        }
        
        [self saveCurrentUser:tempUser];
    }
    

    
    //判断是否第一次启动，如果第一次启动，则跳转到设备管理界面
    if (self.isFirstLanch) {

    } else {
        [self onBack];
    }
}


- (void)onTap
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [self.nameTextField resignFirstResponder];
    [self.ageTextField resignFirstResponder];
    [self.heightTextField resignFirstResponder];
}


- (id)findFirstResponder
{
    id firstResponder = nil;
    if ([self.nameTextField isFirstResponder]) {
        firstResponder = self.nameTextField;
    } else if ([self.ageTextField isFirstResponder]) {
        firstResponder = self.ageTextField;
    } else if ([self.heightTextField isFirstResponder]) {
        firstResponder = self.heightTextField;
    }
    return firstResponder;
}

#pragma mark - ActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:      //照一张
        {
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc] init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            [self presentViewController:imgPicker animated:YES completion:^{
            }];
            break;
        }
        case 1:     //从相册中取一张
        {
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc] init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imgPicker setMediaTypes:[NSArray arrayWithObjects: @"public.image", nil]];        //picker中只显示图片
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:NO];
            [self presentViewController:imgPicker animated:YES completion:^{
            }];
            break;
        }
        default:
            break;
    }
    
    
}


#pragma mark -图片选择完成


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    //当图片不为空时显示图片
    if (image != nil) {
        
        self.headImage = [self scaleToSize:CGSizeMake(80, 80) forImage:image];
        [self.avatarButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    //关闭相册界面
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}




-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"取消拍照");
    }];
}



#pragma mark -UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = [touch view];
    if ([view isKindOfClass:[UIButton class]]) {
        return NO;
    } else {
        return YES;
    }
}


#pragma mark - UIPickerView
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger row = 0;
    if (pickerView == self.agePicker) {
        row = 120;
    } else if (pickerView == self.heightPicker) {
        row = 200;
    }
    return row;
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSLog(@"row = %d", row);
    if (pickerView == self.agePicker) {
        [self.ageTextField setText:[NSString stringWithFormat:@"%d", row]];
    } else if (pickerView == self.heightPicker) {
        [self.heightTextField setText:[NSString stringWithFormat:@"%d", row]];
    }
}


#pragma mark - UITextField Notification

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    id firstResponder = [self findFirstResponder];
    if (firstResponder == self.ageTextField ||
        firstResponder == self.heightTextField) {
       
        if (self.moveDelta == 0) {
            self.moveDelta = 100;
            
//            [UIView animateWithDuration:0.3
//                             animations:^{
//                                 CGRect frame = self.backgroundView.frame;
//                                 frame.origin.y -= self.moveDelta;
//                                 self.backgroundView.frame = frame;
//                             } completion:^(BOOL finished) {
//                                 
//                             }];
            
            
            [self.backgroundView setContentOffset:CGPointMake(0, self.moveDelta) animated:YES];
        }
    }
}

- (void)keyboardWillHiddenNotification:(NSNotification *)notification
{
    
    if (self.moveDelta > 0) {
//        [UIView animateWithDuration:0.3
//                         animations:^{
//                             CGRect frame = self.backgroundView.frame;
//                             frame.origin.y += self.moveDelta;
//                             self.backgroundView.frame = frame;
//                         } completion:^(BOOL finished) {
//                             
//                         }];
        
        [self.backgroundView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.moveDelta = 0.0f;
    }
}






/**************************
 返回值:修正后的UIImage，
 参数  :CGSize图片大小  UIImage
 说明  :对图片进行等比例缩放
 ****************************/
-(UIImage*)scaleToSize:(CGSize)size forImage:(UIImage*)image
{
    
    //  UIImage *img=[self fixOrientation:image];
    CGSize tempSize ;
    CGFloat width = CGImageGetWidth(image.CGImage);
    CGFloat height = CGImageGetHeight(image.CGImage);
    
    switch (image.imageOrientation) {
        case UIImageOrientationUp:
            NSLog(@"Up");
            _isOrig = @"HENG";
            
            break;
        case UIImageOrientationDown:
            NSLog(@"Down");
            _isOrig =@"HENG";
            break;
        case UIImageOrientationLeft:
            NSLog(@"Left");
            _isOrig =@"SHU";
            break;
        case UIImageOrientationRight:
            NSLog(@"Right");
            _isOrig =@"SHU";
            break;
            
        default:
            _isOrig =@"SHU";
            NSLog(@"other");
            break;
    }
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (tempSize.width - width)/2;
    int yPos = (tempSize.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //[image drawInRect:CGRectMake(xPos, yPos, 64 , 64)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    // return scaledImage;
    return [self fixOrientation:scaledImage];     //// 取向修正后的图片
}



/****************************************
 返回值:取向修正后的UIImage，
 参数  :UIImage
 说明  :如果图片是左右横向或是向下的  则旋转为向上
 *****************************************/
-(UIImage*)fixOrientation:(UIImage*)image{
    
    // 旋转90度（3.14/2），此处为弧度制  UIImageOrientationLeftMirrored
    CGAffineTransform transform = CGAffineTransformIdentity;
    /* if (image.imageOrientation==UIImageOrientationUp) {
     return image;
     }*/
    switch (image.imageOrientation) {
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            NSLog(@"dujwUp");
            
            
            // transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            //  transform = CGAffineTransformRotate(transform,  M_PI_2);
            // transform = CGAffineTransformRotate(transform, 0);
            break;
        case UIImageOrientationDown:
        case  UIImageOrientationDownMirrored:
            NSLog(@"dujwDown");
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            NSLog(@"dujwLeft");
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            
            
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            NSLog(@"dujwRight");
            
            break;
            
        default:
            NSLog(@"other");
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    //    =========
    //    // Now we draw the underlying CGImage into a new context, applying the transform
    //    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            NSLog(@"===4====");
            
            // CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
            
        default:
            NSLog(@"===5====");
            
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            
            break;
    }
    //
    //    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    //    imageView.image=img;
    
    
    
    return img;
    
}



@end
