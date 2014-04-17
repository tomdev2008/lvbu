//
//  MsgContentCodec.h
//  doudizhu
//
//  Created by GinoDeng on 9/10/13.
//  Copyright (c) 2013 joy-cloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgContentCodec : NSObject

+(NSDictionary *)decodeMsgContent:(NSData*)data;
+(NSData *)encodeMsgContent:(NSDictionary *)data;

@end
