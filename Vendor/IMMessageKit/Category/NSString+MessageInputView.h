//
//  NSString+MessageInputView.h
//  DemoProject
//
//  Created by zzc on 14-5-7.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MessageInputView)

- (NSString *)stringByTrimingWhitespace;
- (NSUInteger)numberOfLines;

@end
