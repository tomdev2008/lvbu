//
//  HttpRequest.h
//  DemoProject
//
//  Created by zzc on 13-12-27.
//  Copyright (c) 2013年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpConfig.h"
#import "AFNetworking.h"

@interface HttpRequest : NSObject

@property (nonatomic, copy)NSString *url;
@property (nonatomic, retain)NSMutableDictionary *headParams;
@property (nonatomic, retain)NSMutableDictionary *bodyParams;


- (void)sendJSONRequestWithSuccess:(void (^)(NSDictionary *result))success
                           Failure:(void (^)(NSError *err))failure;

- (void)sendGetJSONRequestWithSuccess:(void (^)(NSDictionary *result))success
                              Failure:(void (^)(NSError *err))failure;

- (void)sendPostJSONRequestWithSuccess:(void (^)(NSDictionary *result))success
                               Failure:(void (^)(NSError *err))failure;


- (void)sendXMLRequestWithSuccess:(void (^)(CXMLElement *rootElement))success
                          Failure:(void (^)(NSError *err))failure;

- (void)sendGetXMLRequestWithSuccess:(void (^)(CXMLElement *rootElement))success
                             Failure:(void (^)(NSError *err))failure;

- (void)sendPostXMLRequestWithSuccess:(void (^)(CXMLElement *rootElement))success
                              Failure:(void (^)(NSError *err))failure;

@end
