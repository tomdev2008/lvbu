//
//  MessageVoiceFactory.m
//  DemoProject
//
//  Created by zzc on 14-5-7.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "MessageVoiceFactory.h"

@implementation MessageVoiceFactory

+ (UIImageView *)messageVoiceAnimationImageViewWithBubbleMessageType:(BubbleMessageType)type
{
    UIImageView *voiceMsgAniamtionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    NSString *imageSepatorName;
    switch (type) {
        case BubbleMessageType_Sending:
        {
            imageSepatorName = @"Sender";
            break;
        }
        case BubbleMessageType_Receiving:
        {
            imageSepatorName = @"Receiver";
            break;
        }
        default:
            break;
    }
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i = 0; i < 4; i ++) {
        UIImage *image = [UIImage imageNamed:[imageSepatorName stringByAppendingFormat:@"VoiceNodePlaying00%d", i]];
        if (image){
            [images addObject:image];
        }
    }
    
    voiceMsgAniamtionImageView.image = [UIImage imageNamed:[imageSepatorName stringByAppendingString:@"VoiceNodePlaying"]];
    voiceMsgAniamtionImageView.animationImages = images;
    voiceMsgAniamtionImageView.animationDuration = 1.0;
    [voiceMsgAniamtionImageView stopAnimating];
    
    return voiceMsgAniamtionImageView;
}

@end
