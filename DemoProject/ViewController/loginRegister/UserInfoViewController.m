//
//  UserInfoViewController.m
//  DemoProject
//
//  Created by Proint on 14-4-8.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "UserInfoViewController.h"
#import "AppCore.h"

@interface UserInfoViewController ()

@property(nonatomic, retain)NSDateFormatter *dateFormatter;

- (void)onBack;
- (void)onEditAvatar;
- (void)onMale;
- (void)onFemale;
- (void)onBirthdayPickerChanged:(id)sender;
- (void)saveHeadImg:(UIImage *)image toPath:(NSString *)path;
- (void)onDone;
- (void)onStart;
- (void)onTap;
- (void)hideKeyboard;
- (id)findFirstResponder;
- (NSString *)getAvatarFilePath;


@end

@implementation UserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
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
//    self.backButton = [UIFactory createButtonWithRect:CGRectMake(0, 0, 60, NavigationBarDefaultHeight)
//                                               normal:@""
//                                            highlight:@""
//                                             selector:@selector(onBack)
//                                               target:self];
//    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [self.customNavigationBar addSubview:self.backButton];
    
    
    //标题
    self.titleLabel = [UIFactory createLabelWith:CGRectMake(80, 0, 160, NavigationBarDefaultHeight)
                                            text:@"个人信息"
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
    self.avatarButton = [UIFactory createButtonWithRect:CGRectMake(120, 24, 62, 62)
                                                 normal:DefaultHeadIconFileName
                                              highlight:DefaultHeadIconFileName
                                               selector:@selector(onEditAvatar)
                                                 target:self];
    [self.backgroundView addSubview:self.avatarButton];
    
    
    //性别
    CGRect textFieldFrame = CGRectMake(40, 100, 238, 30);
    UIImageView *sexBGImgView = [[UIImageView alloc] initWithFrame:textFieldFrame];
    [sexBGImgView setBackgroundColor:[UIColor redColor]];
    [sexBGImgView setImage:[UIImage imageNamedNoCache:@""]];
 
    
    self.maleButton = [UIFactory createButtonWithRect:CGRectMake(110, 100, 28, 28)
                                                  title:@"男"
                                              titleFont:[UIFont systemFontOfSize:18]
                                             titleColor:[UIColor blueColor]
                                                 normal:@"Regitster_male_n.png"
                                              highlight:nil
                                               selected:@"Regitster_male_c.png"
                                               selector:@selector(onMale)
                                                 target:self];

    
    self.femaleButton = [UIFactory createButtonWithRect:CGRectMake(176, 100, 28, 28)
                                                  title:@"女"
                                              titleFont:[UIFont systemFontOfSize:18]
                                             titleColor:[UIColor blueColor]
                                                 normal:@"Regitster_male_n.png"
                                              highlight:nil
                                               selected:@"Regitster_male_c.png"
                                               selector:@selector(onFemale)
                                                 target:self];
    

    
    //生日
    textFieldFrame.origin.y += 52;
    UIImageView *birthdayBGImgView = [[UIImageView alloc] initWithFrame:textFieldFrame];
    [birthdayBGImgView setBackgroundColor:[UIColor redColor]];
    [birthdayBGImgView setImage:[UIImage imageNamedNoCache:@""]];
    
    self.birthdayTextField = [UIFactory createTextFieldWithRect:textFieldFrame
                                               keyboardType:UIKeyboardTypeDefault
                                                     secure:NO
                                                placeholder:@"1990-08-08"
                                                       font:[UIFont systemFontOfSize:18]
                                                      color:[UIColor blueColor]
                                                   delegate:self];
    [self.birthdayTextField setBackgroundColor:[UIColor clearColor]];
    [self.birthdayTextField setTextAlignment:NSTextAlignmentCenter];
    [self.birthdayTextField setBorderStyle:UITextBorderStyleNone];
    
    
    NSDate *defaultDate = [NSDate dateWithYear:1990
                                         Month:8
                                           Day:8
                                          Hour:12
                                        Minute:0
                                        Second:0];

    self.birthdayPicker = [[UIDatePicker alloc] init];
    [self.birthdayPicker addTarget:self
                            action:@selector(onBirthdayPickerChanged:)
                  forControlEvents:UIControlEventValueChanged];
    
    self.birthdayPicker.datePickerMode = UIDatePickerModeDate;
    [self.birthdayPicker setDate:defaultDate];
    [self.birthdayTextField setInputView:self.birthdayPicker];
    

    
    //身高
    textFieldFrame.origin.y += 52;
    UIImageView *heightBGImgView = [[UIImageView alloc] initWithFrame:textFieldFrame];
    [heightBGImgView setBackgroundColor:[UIColor redColor]];
    [heightBGImgView setImage:[UIImage imageNamedNoCache:@""]];
    
    self.heightTextField = [UIFactory createTextFieldWithRect:textFieldFrame
                                              keyboardType:UIKeyboardTypeDefault
                                                    secure:NO
                                               placeholder:nil
                                                      font:[UIFont systemFontOfSize:18]
                                                     color:[UIColor blueColor]
                                                  delegate:self];
    [self.heightTextField setBackgroundColor:[UIColor clearColor]];
    [self.heightTextField setTextAlignment:NSTextAlignmentCenter];
//    [self.heightTextField setBorderStyle:UITextBorderStyleNone];
    
    self.heightPicker = [[UIPickerView alloc] init];
    self.heightPicker.delegate = self;
    self.heightPicker.dataSource = self;
    [self.heightTextField setInputView:self.heightPicker];
    
    
    
    
    
    //体重
    textFieldFrame.origin.y += 52;
    UIImageView *weightBGImgView = [[UIImageView alloc] initWithFrame:textFieldFrame];
    [weightBGImgView setBackgroundColor:[UIColor redColor]];
    [weightBGImgView setImage:[UIImage imageNamedNoCache:@""]];
    
    
    self.weightTextField = [UIFactory createTextFieldWithRect:textFieldFrame
                                                 keyboardType:UIKeyboardTypeDefault
                                                       secure:NO
                                                  placeholder:nil
                                                         font:[UIFont systemFontOfSize:18]
                                                        color:[UIColor blueColor]
                                                     delegate:self];
    [self.weightTextField setBackgroundColor:[UIColor clearColor]];
    [self.weightTextField setTextAlignment:NSTextAlignmentCenter];
    //    [self.heightTextField setBorderStyle:UITextBorderStyleNone];
    
    self.weightPicker = [[UIPickerView alloc] init];
    self.weightPicker.delegate = self;
    self.weightPicker.dataSource = self;
    [self.weightTextField setInputView:self.weightPicker];

    
    textFieldFrame.origin.y += 40;
    UIImageView *tipImgView = [[UIImageView alloc] initWithFrame:textFieldFrame];
    [tipImgView setBackgroundColor:[UIColor redColor]];
    [tipImgView setImage:[UIImage imageNamedNoCache:@""]];
    
    //完成
    self.doneButton = [UIFactory createButtonWithRect:CGRectMake((320 - 246)/2, CGRectGetHeight(backViewFrame) - 127, 246, 40)
                                                title:@"完成"
                                            titleFont:[UIFont systemFontOfSize:18]
                                           titleColor:[UIColor whiteColor]
                                               normal:@""
                                            highlight:@""
                                             selected:nil
                                             selector:@selector(onDone)
                                               target:self];
    [self.doneButton setBackgroundColor:[UIColor blueColor]];
    
    //开始体验
    self.startButton = [UIFactory createButtonWithRect:CGRectMake((320 - 246)/2, CGRectGetHeight(backViewFrame) - 75, 246, 38)
                                                title:@"开始体验"
                                            titleFont:[UIFont systemFontOfSize:18]
                                           titleColor:[UIColor whiteColor]
                                               normal:@""
                                            highlight:@""
                                             selected:nil
                                             selector:@selector(onStart)
                                               target:self];
    [self.startButton setBackgroundColor:[UIColor blueColor]];
    
    
    
    //去掉叉叉按钮
    [self.birthdayTextField setClearButtonMode:UITextFieldViewModeNever];
    [self.heightTextField setClearButtonMode:UITextFieldViewModeNever];
    [self.weightTextField setClearButtonMode:UITextFieldViewModeNever];
    
    [self.backgroundView addSubview:birthdayBGImgView];
    [self.backgroundView addSubview:sexBGImgView];
    [self.backgroundView addSubview:heightBGImgView];
    [self.backgroundView addSubview:weightBGImgView];
    [self.backgroundView addSubview:tipImgView];
    
    [self.backgroundView addSubview:self.femaleButton];
    [self.backgroundView addSubview:self.maleButton];
    [self.backgroundView addSubview:self.birthdayTextField];
    [self.backgroundView addSubview:self.heightTextField];
    [self.backgroundView addSubview:self.weightTextField];
    
    [self.backgroundView addSubview:self.doneButton];
    [self.backgroundView addSubview:self.startButton];
    
    
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



- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)onEditAvatar
{
    
    //头像
    [self hideKeyboard];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"拍照"
                                                   otherButtonTitles:@"从相册中选择", nil];
    
    [actionSheet showInView:self.view];
}



- (void)onMale
{
    self.femaleButton.selected = NO;
    self.maleButton.selected = YES;
}

- (void)onFemale
{
    self.femaleButton.selected = YES;
    self.maleButton.selected = NO;
}


- (void)onBirthdayPickerChanged:(id)sender
{
    NSString *date = [self.dateFormatter stringFromDate:[self.birthdayPicker date]];
    [self.birthdayTextField setText:date];
}

- (void)saveHeadImg:(UIImage *)image toPath:(NSString *)path
{
    //保存图片文件到沙盒
    NSData *stroreImageData = UIImageJPEGRepresentation(image, 1.0);
    [stroreImageData writeToFile:path atomically:YES];
}


- (NSString *)getAvatarFilePath
{
    NSString *avatarFileName = [NSString stringWithFormat:@"userAvatar.png"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:avatarFileName];
}



- (void)onDone
{
    //性别,生日，身高，体重
    BOOL ismale = (self.maleButton.selected) ? YES: NO;
    NSString *birthday = [self.birthdayTextField.text trim];
    NSString *height = [self.heightTextField.text trim];
    NSString *weight = [self.weightTextField.text trim];

    //头像
    if (self.headImage) {
        [self saveHeadImg:self.headImage toPath:[self getAvatarFilePath]];
    }
    
    
    
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


- (void)onStart
{
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)onTap
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [self.birthdayTextField resignFirstResponder];
    [self.heightTextField resignFirstResponder];
    [self.weightTextField resignFirstResponder];
}


- (id)findFirstResponder
{
    id firstResponder = nil;
    if ([self.birthdayTextField isFirstResponder]) {
        firstResponder = self.birthdayTextField;
    } else if ([self.heightTextField isFirstResponder]) {
        firstResponder = self.heightTextField;
    } else if ([self.weightTextField isFirstResponder]) {
        firstResponder = self.weightTextField;
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
    if (pickerView == self.heightPicker) {
        row = 120;
    } else if (pickerView == self.weightPicker) {
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
    NSString *item = @"0";
    if (pickerView == self.heightPicker) {
        item = [NSString stringWithFormat:@"%d CM", row];
    } else if (pickerView == self.weightPicker) {
        item = [NSString stringWithFormat:@"%d KG", row];
    }
    return item;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSLog(@"row = %d", row);
    if (pickerView == self.heightPicker) {
        [self.heightTextField setText:[NSString stringWithFormat:@"%d CM", row]];
    } else if (pickerView == self.weightPicker) {
        [self.weightTextField setText:[NSString stringWithFormat:@"%d KG", row]];
    }
}


#pragma mark - UITextField Notification

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    id firstResponder = [self findFirstResponder];
    if (firstResponder == self.heightTextField ||
        firstResponder == self.weightTextField) {
       
        if (self.moveDelta == 0) {
            
            self.moveDelta = 100;
            [self.backgroundView setContentOffset:CGPointMake(0, self.moveDelta) animated:YES];
        }
    }
}

- (void)keyboardWillHiddenNotification:(NSNotification *)notification
{
    
    if (self.moveDelta > 0) {
        
        [self.backgroundView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.moveDelta = 0.0f;
    }
}


#pragma

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
