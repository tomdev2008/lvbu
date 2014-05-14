//
//  HttpRequest.m
//  DemoProject
//
//  Created by zzc on 13-12-27.
//  Copyright (c) 2013年 zzc. All rights reserved.
//

#import "HttpRequest.h"

#define REQUEST_TIME_OUT  30

@implementation HttpRequest


#pragma mark - JSON

- (void)sendJSONRequestWithSuccess:(void (^)(NSDictionary *result))success
                           Failure:(void (^)(NSError *err))failure
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]
                                                           cachePolicy:NSURLCacheStorageNotAllowed
                                                       timeoutInterval:REQUEST_TIME_OUT];
    
    if (self.headParams) {
        for (NSString *key in self.headParams) {
            [request setValue:[self.headParams valueForKey:key] forHTTPHeaderField:key];
        }
    }
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        NSLog(@"response json:%@",JSON);
                                                        NSDictionary *dic = (NSDictionary *)JSON;
                                                        if (dic != nil && success ) {
                                                            success(dic);
                                                        } else {
                                                            
                                                            //返回应答异常
                                                            if (failure) {
                                                                failure(nil);
                                                            }
                                                        }
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"response json err:%@",JSON);
                                                        //请求失败
                                                        if (failure) {
                                                            failure(error);
                                                        }
                                                    }];
    
    [operation start];

    
}


- (void)sendGetJSONRequestWithSuccess:(void (^)(NSDictionary *result))success
                              Failure:(void (^)(NSError *err))failure
{
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:self.url]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    [client getPath:self.url
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSDictionary *dic = (NSDictionary *)responseObject;
                 if (dic != nil && success) {
                     success(dic);
                 } else {
                     
                     //异常
                     if (failure) {
                         failure(nil);
                     }
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 //异常
                 if (failure) {
                     failure(error);
                 }
             }];
}

- (void)sendPostJSONRequestWithSuccess:(void (^)(NSDictionary *result))success
                           Failure:(void (^)(NSError *err))failure
{
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:self.url]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    if (self.headParams) {
        for (NSString *key in self.headParams) {
            [client setDefaultHeader:key value:[self.headParams valueForKey:key]];
        }
    }
 
    [client postPath:self.url
          parameters:self.bodyParams
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSDictionary *dic = (NSDictionary *)responseObject;
                 if (dic != nil && success) {
                     success(dic);
                 } else {
                     
                     //异常
                     if (failure) {
                         failure(nil);
                     }
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 //异常
                 if (failure) {
                     failure(error);
                 }
             }];

}

#pragma mark - XML

- (void)sendXMLRequestWithSuccess:(void (^)(CXMLElement *rootElement))success
                          Failure:(void (^)(NSError *err))failure
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                       timeoutInterval:REQUEST_TIME_OUT];
    
    if (self.headParams) {
        for (NSString *key in self.headParams) {
            [request setValue:[self.headParams valueForKey:key] forHTTPHeaderField:key];
        }
    }
    
    AFXMLRequestOperation *operation =
    [AFXMLRequestOperation XMLDocumentRequestOperationWithRequest:request
                                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, CXMLDocument *document) {
                                                              
                                                              CXMLElement *element = [document rootElement];
                                                              NSLog(@"element = %@", [element description]);
                                                              if (element && success) {
                                                                  success(element);
                                                              } else {
                                                                  
                                                                  if (failure) {
                                                                      failure(nil);
                                                                  }
                                                              }
                                                              
                                                          } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, CXMLDocument *document) {
                                                              if (failure) {
                                                                  failure(error);
                                                              }
                                                          }];
    
    [operation start];
}


- (void)sendGetXMLRequestWithSuccess:(void (^)(CXMLElement *rootElement))success
                             Failure:(void (^)(NSError *err))failure
{
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:self.url]];
    [client registerHTTPOperationClass:[AFXMLRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/xml"];
    
    [client getPath:self.url
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                CXMLDocument *document = (CXMLDocument *)responseObject;
                NSLog(@"response = %@", [document description]);
                CXMLElement *rootElement = [document rootElement];
                if (rootElement != nil && success) {
                    success(rootElement);
                } else {
                    
                    //异常
                    if (failure) {
                        failure(nil);
                    }
                }
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //异常
                if (failure) {
                    failure(error);
                }
            }];
}

- (void)sendPostXMLRequestWithSuccess:(void (^)(CXMLElement *rootElement))success
                              Failure:(void (^)(NSError *err))failure
{
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:self.url]];
    [client registerHTTPOperationClass:[AFXMLRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/xml"];
    
    if (self.headParams) {
        for (NSString *key in self.headParams) {
            [client setDefaultHeader:key value:[self.headParams valueForKey:key]];
        }
    }
    
    [client postPath:self.url
          parameters:self.bodyParams
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 CXMLDocument *document = (CXMLDocument *)responseObject;
                 NSLog(@"response = %@", [document description]);
                 CXMLElement *rootElement = [document rootElement];
                 if (rootElement != nil && success) {
                     success(rootElement);
                 } else {
                     
                     //异常
                     if (failure) {
                         failure(nil);
                     }
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 //异常
                 if (failure) {
                     failure(error);
                 }
             }];
    
}

@end
