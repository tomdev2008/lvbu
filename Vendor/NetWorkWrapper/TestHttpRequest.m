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


#define UserName @"hello123@mkm.com"
#define Password @"hello123@mkm.com"

@implementation TestHttpRequest

- (void)testRegister
{


    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:UserName forKey:@"email"];
    [bodyParams setValue:Password forKey:@"password"];

    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_REGISTER];
    httpReq.bodyParams = bodyParams;
    
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"register.dic = %@", result);
        NSLog(@"register.msg = %@", [result valueForKey:@"msg"]);
        
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
}



- (void)testCheckVersion
{
    

    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = @"http://itunes.apple.com/lookup?id=535715926";
    
    [httpReq sendGetJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
}

- (void)testModifyInfo
{
    
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    
    [bodyParams setValue:@"zhouzhiqun"  forKey:@"nike_name"];
    [bodyParams setValue:@1        forKey:@"sex"];
    [bodyParams setValue:@173         forKey:@"height"];
    [bodyParams setValue:@700          forKey:@"weight"];
    [bodyParams setValue:@"19880810"    forKey:@"birth"];
    [bodyParams setValue:@"xxx.jpg"         forKey:@"head_photo"];
    
//    [bodyParams setValue:@"zhouzhiqun@163.com"  forKey:@"relate_email"];
//    [bodyParams setValue:@"315701008"          forKey:@"relate_qq"];
//    [bodyParams setValue:@"hellokitty@sina.com" forKey:@"relate_sina_weibo"];
    
    
//    [bodyParams setValue:@"zhouzhiqun"  forKey:@"u_nick_name"];
//    [bodyParams setValue:@"male"        forKey:@"u_sex"];
//    [bodyParams setValue:@"173"         forKey:@"u_height"];
//    [bodyParams setValue:@"70"          forKey:@"u_weight"];
//    [bodyParams setValue:@"19880810"    forKey:@"u_birth"];
//    [bodyParams setValue:@"xxx"         forKey:@"u_head_photo"];
//    [bodyParams setValue:@"zhouzhiqun@163.com"  forKey:@"bind_email"];
//    [bodyParams setValue:@"315701008"          forKey:@"bind_qq"];
//    [bodyParams setValue:@"hellokitty@sina.com" forKey:@"bind_sina_weibo"];
  
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_MODIFYINFO];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
        NSLog(@"ModifyInfo.msg = %@", [result valueForKey:@"msg"]);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
}



- (void)testModifyInfoByGet
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];

    
    [bodyParams setValue:@"zhouzhiqun"  forKey:@"nike_name"];
    [bodyParams setValue:@1        forKey:@"sex"];
    [bodyParams setValue:@173         forKey:@"height"];
    [bodyParams setValue:@700          forKey:@"weight"];
    [bodyParams setValue:@"19880810"    forKey:@"birth"];
    [bodyParams setValue:@"xxx.jpg"         forKey:@"head_photo"];
    
//    [bodyParams setValue:@"zhouzhiqun"  forKey:@"u_nick_name"];
//    [bodyParams setValue:@"male"        forKey:@"u_sex"];
//    [bodyParams setValue:@"173"         forKey:@"u_height"];
//    [bodyParams setValue:@"70"          forKey:@"u_weight"];
//    [bodyParams setValue:@"19880810"    forKey:@"u_birth"];
//    [bodyParams setValue:@"xxx"         forKey:@"u_head_photo"];
//    [bodyParams setValue:@"zhouzhiqun@163.com"  forKey:@"bind_email"];
//    [bodyParams setValue:@"315701008"          forKey:@"bind_qq"];
//    [bodyParams setValue:@"hellokitty@sina.com" forKey:@"bind_sina_weibo"];
    
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?", BASE_URL, URL_MODIFYINFO];

    NSArray *keys = [bodyParams allKeys];
    for (int i = 0; i < [keys count] - 1; ++i) {
        [tempUrl appendFormat:@"%@=%@&", [keys objectAtIndex:i], [bodyParams valueForKey:[keys objectAtIndex:i]] ];
    }
    [tempUrl appendFormat:@"%@=%@", [keys lastObject], [bodyParams valueForKey:[keys lastObject]] ];
    
    httpReq.url = tempUrl;
    NSLog(@"httpReq.url = %@", tempUrl);
    
//    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
//        NSLog(@"result = %@", result);
//        NSLog(@"ModifyInfo.msg = %@", [result valueForKey:@"msg"]);
//    } Failure:^(NSError *err) {
//        NSLog(@"error = %@", [err description]);
//    }];
//    
    
    [httpReq sendGetJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
        NSLog(@"ModifyInfo.msg = %@", [result valueForKey:@"msg"]);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];

}

- (void)testModifyPassword
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    [bodyParams setValue:Password forKey:@"oldpass"];
    [bodyParams setValue:@"zhou123" forKey:@"newpass"];

    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_MODIFYPASSWORD];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
        NSLog(@"testModifyPassword.msg = %@", [result valueForKey:@"msg"]);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];

}


- (void)testLogin
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    

    [bodyParams setValue:UserName forKey:@"email"];
    [bodyParams setValue:Password forKey:@"password"];

    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_LOGIN];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"login.dic = %@", result);
        NSLog(@"login.msg = %@", [result valueForKey:@"msg"]);
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setValue:[result valueForKey:@"scode"] forKey:KEY_GLOBAL_SESSIONCODE];
        
      
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
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_LOGOUT];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
        NSLog(@"testLogout.msg = %@", [result valueForKey:@"msg"]);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}


- (void)testLogoutByGet
{

    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?", BASE_URL, URL_LOGOUT];
    
    NSArray *keys = [bodyParams allKeys];
    [tempUrl appendFormat:@"%@=%@", [keys objectAtIndex:0], [bodyParams valueForKey:[keys objectAtIndex:0]] ];
    
    httpReq.url = tempUrl;
    NSLog(@"httpReq.url = %@", tempUrl);
    
    [httpReq sendGetJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
        NSLog(@"testLogoutByGet.msg = %@", [result valueForKey:@"msg"]);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];

}



- (void)testEye
{
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    [bodyParams setValue:@"79" forKey:@"uid"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_EYE];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
        NSLog(@"testEye.msg = %@", [result valueForKey:@"msg"]);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}



- (void)testEyeById:(NSInteger)uid
{
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
    [bodyParams setValue:[NSNumber numberWithInt:uid] forKey:@"uid"];
    
    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_EYE];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
        NSLog(@"testEye.msg = %@", [result valueForKey:@"msg"]);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}




- (void)testGetFans
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];

    HttpRequest *httpReq = [[HttpRequest alloc] init];
    httpReq.url = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_GETFANS];
    httpReq.bodyParams = bodyParams;
    [httpReq sendPostJSONRequestWithSuccess:^(NSDictionary *result) {
        NSLog(@"result = %@", result);
        NSLog(@"testGetFans.msg = %@", [result valueForKey:@"msg"]);
    } Failure:^(NSError *err) {
        NSLog(@"error = %@", [err description]);
    }];
    
}






- (void)testSearchUser
{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
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
    [bodyParams setValue:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_GLOBAL_SESSIONCODE] forKey:@"scode"];
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
