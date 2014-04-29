//
//  TestHttpRequest.h
//  DemoProject
//
//  Created by Proint on 14-4-18.
//  Copyright (c) 2014年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TestHttpRequest : NSObject


- (void)testRegister;

- (void)testCheckVersion;

- (void)testModifyInfo;

- (void)testModifyInfoByGet;

- (void)testModifyPassword;


- (void)testLogin;


- (void)testThirdPartLogin;


- (void)testLogout;
- (void)testLogoutByGet;

- (void)testEye;
- (void)testEyeById:(NSInteger)uid;

- (void)testCancelEye;


- (void)testGetFans;



- (void)testSearchUser;


- (void)testInvite;



- (void)testCancelInvite;

- (void)testRetInvite;


- (void)testGpsUpdate;



- (void)testCreateGroup;


- (void)testDeleteGroup;



- (void)testChangeGroup;


- (void)testSendText;


- (void)testSendVoice;


@end
