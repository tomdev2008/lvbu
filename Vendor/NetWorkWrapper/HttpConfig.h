//
//  HttpConfig.h
//  DemoProject
//
//  Created by zzc on 13-12-27.
//  Copyright (c) 2013年 zzc. All rights reserved.
//

#ifndef HttpConfig_h
#define HttpConfig_h


#define BASE_URL @"http://api.reallybe.com"
//#define BASE_URL @"http://api.maipal.com"
//#define BASE_URL @"http://114.215.191.238"


//注册
#define URL_REGISTER                @"/v1/user/registe"


//修改信息
#define URL_MODIFYINFO              @"/v1/user/modinfo"


//修改密码
#define URL_MODIFYPASSWORD          @"/v1/user/modpass"



//第三方登录
#define URL_THIRDPARTLOGIN          @"/v1/user/login_threepart"


//登录
#define URL_LOGIN                   @"/v1/login/login1"

//注销
#define URL_LOGOUT                  @"/v1/login/logout"


//关注
#define URL_EYE                     @"/v1/fans/eyes_on"

//取消关注
#define URL_CANCEL_EYE              @"/v1/fans/eyes_off"

//取好友列表
#define URL_GETFANS                 @"/v1/fans/getfans"

//附近的人
#define URL_NEARBY                  @"/v1/around/near"

//查找用户列表
#define URL_SEARCHUSER              @"/v1/fans/getusers"

//运动服务
//邀跑
#define URL_INVITE                  @"/v1/banpao/invite"

//取消邀请
#define URL_INVITE_CANCEL           @"/v1/banpao/invite_cancel"

//回复邀请
#define URL_INVITE_RET             @"/v1/banpao/invite_ret"

//发定时GPS轨迹
#define URL_GPSUPDATE               @"/v1/sport/gps_update"

//取运动统计信息
#define URL_SPORT_SUM               @"/v1/sport/sport_sum"

//取运动历史
#define URL_SPORT_HISTORY           @"/v1/sport/sport_get"

//增加主动运动历史
#define URL_SPORT_ADDSPORT          @"/v1/sport/sport_add"

//删除主动运动历史
#define URL_SPORT_DELSPORT          @"/v1/sport/sport_delete"

//增加碎片运动历史
#define URL_SPORT_ADDFRAGMENT       @"/v1/sport/fragment_add"

//删除碎片运动历史
#define URL_SPORT_DELFRAGMENT       @"/v1/sport/fragment_delete"



//分组服务
#define URL_GROUP_CREATE            @"/v1/group/group_new"

#define URL_GROUP_DELETE            @"/v1/group/group_delete"

#define URL_GROUP_CHANGE            @"/v1/group/group_change"



//IM聊天
#define URL_SEND_TEXT               @"/v1/im/im_text"

#define URL_SEND_VOICE              @"/v1/im/im_voice"

#define URL_SEND_IMAGE              @"/v1/im/im_image"



//群聊
#define URL_CHAT_CHANGEGROUP        @"/v1/chat/chat_change"

//推荐服务
#define URL_RECOMMEND               @"/v1/recommend/recommend_self"

//历史
#define URL_HISTORY_SPORT           @"/v1/histroy/sport_histroy"

#define URL_HISTORY_ADDSPORT        @"/v1/histroy/sport_add"

#define URL_HISTORY _DELSPORT       @"/v1/histroy/sport_delete"

#define URL_HISTORY_PARTNER         @"/v1/histroy/partner"


//离线消息
#define URL_OFFLINE_GET             @"/v1/offline/offline_get"

#define URL_OFFLINE_GETMULTI        @"/v1/offline/offline_multi"


//获取所有上传URL
#define URL_GET_UPLOADURL           @"/v1/system/get_upload_url"


#endif
