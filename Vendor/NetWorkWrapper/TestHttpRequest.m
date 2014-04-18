//
//  TestHttpRequest.m
//  DemoProject
//
//  Created by Proint on 14-4-18.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import "TestHttpRequest.h"

#import "AppCore.h"
#import "HttpConfig.h"
#import "HttpRequest.h"

@implementation TestHttpRequest

- (void)testRegister
{

    NSString *pwd = @"gogogo";
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"zhouzhiqun@163.com" forKey:@"email"];
    [bodyParams setValue:[pwd MD5Sum] forKey:@"password"];

    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_REGISTER];
    httpReq.bodyParams = bodyParams;
    
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
}



- (void)testModifyInfo
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"12345678123456781234567812345678" forKey:@"scode"];
    [bodyParams setValue:@"zhouzhiqun"  forKey:@"nick_name"];
    [bodyParams setValue:@"male"        forKey:@"sex"];
    [bodyParams setValue:@"173"         forKey:@"height"];
    [bodyParams setValue:@"70"          forKey:@"weight"];
    [bodyParams setValue:@"19880810"    forKey:@"birth"];
    [bodyParams setValue:@"xxx"         forKey:@"head_photo"];
    [bodyParams setValue:@"zhouzhiqun@163.com"  forKey:@"relate_email"];
    [bodyParams setValue:@"3215701008"          forKey:@"relate_qq"];
    [bodyParams setValue:@"hellokitty@sina.com" forKey:@"relate_sina_weibo"];
  
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_MODIFYINFO];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
}


- (void)testModifyPassword
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"12345678123456781234567812345678" forKey:@"scode"];
    [bodyParams setValue:@"zhou123" forKey:@"oldpass"];
    [bodyParams setValue:@"zhou321" forKey:@"newpass"];

    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_MODIFYPASSWORD];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];

}


- (void)testLogin
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"zhouzhiqun@163.com" forKey:@"email"];
    [bodyParams setValue:@"zhou123" forKey:@"password"];

    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_LOGIN];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}


- (void)testThirdPartLogin
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"1" forKey:@"type"];  //QQ
    //[bodyParams setValue:@"2" forKey:@"type"];  //新浪微博
    
    [bodyParams setValue:@"abcdefghijklmn" forKey:@"access_token"];

    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_THIRDPARTLOGIN];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}



- (void)testLogout
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"12345678123456781234567812345678" forKey:@"scode"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_LOGOUT];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}


- (void)testEye
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"12345678123456781234567812345678" forKey:@"scode"];
    [bodyParams setValue:@"100010" forKey:@"uid"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_EYE];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}



- (void)testGetFans
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"12345678123456781234567812345678" forKey:@"scode"];

    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_GETFANS];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}



- (void)testSearchUser
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"12345678123456781234567812345678" forKey:@"scode"];
    [bodyParams setValue:@"Hello" forKey:@"nick_name"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_SEARCHUSER];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}


- (void)testInvite
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"12345678123456781234567812345678" forKey:@"scode"];
    [bodyParams setValue:@"100011" forKey:@"uid"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_INVITE];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}



- (void)testCancelInvite
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"12345678123456781234567812345678" forKey:@"scode"];
    [bodyParams setValue:@"100011" forKey:@"uid"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_INVITE_CANCEL];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}



- (void)testRetInvite
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"12345678123456781234567812345678" forKey:@"scode"];
    [bodyParams setValue:@"100011" forKey:@"uid"];
    [bodyParams setValue:@"1" forKey:@"retcode"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_INVITE_RET];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}


- (void)testGpsUpdate
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"12345678123456781234567812345678" forKey:@"scode"];
    [bodyParams setValue:@"aaabbb" forKey:@"gps"];

    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_GPSUPDATE];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}



- (void)testCreateGroup
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"12345678123456781234567812345678" forKey:@"scode"];
    [bodyParams setValue:@"myfriend" forKey:@"group_name"];
    
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_GROUP_CREATE];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}



- (void)testDeleteGroup
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"12345678123456781234567812345678" forKey:@"scode"];
    [bodyParams setValue:@"myfriend" forKey:@"group_name"];
    
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_GROUP_DELETE];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}



- (void)testChangeGroup
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"12345678123456781234567812345678" forKey:@"scode"];
    [bodyParams setValue:@"100012" forKey:@"uid"];
    [bodyParams setValue:@"myfriend" forKey:@"group_name"];
    
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_GROUP_CHANGE];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}


- (void)testSendText
{
    NSString *text = @"爸爸去哪儿?";
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"12345678123456781234567812345678" forKey:@"scode"];
    [bodyParams setValue:@"100012" forKey:@"uid"];
    [bodyParams setValue:[text base64EncodedString] forKey:@"text"];
    
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_SEND_TEXT];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}




- (void)testSendVoice
{
    NSString *voiceUrl = @"http://www.hao123.com/hello.mp3";
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:@"12345678123456781234567812345678" forKey:@"scode"];
    [bodyParams setValue:@"100012" forKey:@"uid"];
    //[bodyParams setValue:@"0" forKey:@"type"];      //0：voice是声音
    [bodyParams setValue:@"1" forKey:@"type"];      //1：voice是声音文件上传后的url
    [bodyParams setValue:voiceUrl forKey:@"voice"];
    
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_SEND_VOICE];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}




@end
