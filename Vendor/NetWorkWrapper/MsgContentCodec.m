//
//  MsgContentCodec.m
//  doudizhu
//
//  Created by GinoDeng on 9/10/13.
//  Copyright (c) 2013 joy-cloud. All rights reserved.
//

#import "MsgContentCodec.h"

@implementation MsgContentCodec

+(NSDictionary *)decodeMsgContent:(NSData*)data
{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil)
    {
        if ([jsonObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
            NSLog(@"Dersialized JSON Dictionary = %@", deserializedDictionary);
            return deserializedDictionary;
        }
        else if ([jsonObject isKindOfClass:[NSArray class]])
        {
            NSArray *deserializedArray = (NSArray *)jsonObject;
            NSLog(@"Dersialized JSON Array = %@", deserializedArray);
        } else
        {
            NSLog(@"An error happened while deserializing the JSON data.");
        }
    }
    
    return nil;
}

+(NSData *)encodeMsgContent:(NSDictionary *)data
{
    NSError *error = nil;
    NSLog(@"request package = %@", data);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    if (error){
        NSLog(@"dic->%@",error);
    }
    return jsonData;
}





@end
