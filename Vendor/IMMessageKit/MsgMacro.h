//
//  MsgMacro.h
//  DemoProject
//
//  Created by zzc on 14-5-7.
//  Copyright (c) 2014年 zzc. All rights reserved.
//


#import "UIImage+Rounded.h"
#import "UIImage+AnimatedFaceGif.h"
#import "NSString+MessageInputView.h"
#import "UIScrollView+KeyBoardControl.h"

// device verson float value
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


//stretch image
#define STRETCH_IMAGE(image, top, left, bottom, right) (CURRENT_SYS_VERSION < 6.0 ? [image stretchableImageWithLeftCapWidth:left topCapHeight:top] : [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch])

#define STRETCH_IMAGE_EDGE(image, edgeInsets) (CURRENT_SYS_VERSION < 6.0 ? [image stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top] : [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch])

