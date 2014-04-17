//
//  MsgTypeDefine.h
//  doudizhu
//
//  Created by apple on 13-8-27.
//  Copyright (c) 2013年 joy-cloud. All rights reserved.
//

#ifndef MsgTypeDefine_h
#define MsgTypeDefine_h

enum EMsgType
{
    EMsgClient_Register         = 10001,
    EMsgClient_Login            = 10002,
    EMsgClient_SendToken        = 10003,
    EMSGClient_GetMatchUserInfo = 10004,
    EMSGClient_GetOfflineMsg    = 10005,
    EMSGClient_ModifyPassword   = 10007,
    EMSGClient_RequestHeadImg   = 10008,
    EMSGClient_CommitHeadImg    = 10009,
    EMSGClient_RequestChainID   = 10010,
    EMSGClient_CommitChainID    = 10011,
 
    EMsgClient_RequestMatch     = 20001,
    EMsgClient_CancelMatch      = 20002,
    EMsgClient_ResponseMatch    = 20003,
    EMsgClient_SendTextMsg      = 30001,
    EMsgClient_SendOrderMsg     = 30002,
    EMsgClient_RequestDivorce   = 40001,
    EMsgClient_ResponseDivorce  = 40002,
    EMsgClient_CancelDivorce    = 40003,
};

enum EMsgType_Server
{
    EMsgServer_RegisterResponse                 = 10001,
    EmsgServer_LoginResponse                    = 10002,
    EmsgServer_GetMatchUserInfoResponse         = 10004,
    EmsgServer_GetOfflineMsgResponse            = 10005,
    EmsgServer_ModifyPasswordResponse           = 10007,
    EmsgServer_ResponseHeadImg                  = 10008,
    EmsgServer_ResponseCommitHeadImg            = 10009,
    EmsgServer_ResponseChainID                  = 10010,
    EmsgServer_ResponseCommitChainID            = 10011,
    
    
    
    EmsgServer_MatchUserInfoResponse            = 20001,
    EmsgServer_ReceiveMatchRequest              = 20002,
    EmsgServer_ReceiveMatchCancel               = 20003,
    EmsgServer_ReceiveMatchResult               = 20004,
    EmsgServer_ReceiveTextMsg                   = 30001,
    EmsgServer_ReceiveOrderMsg                  = 30002,
    EmsgServer_ReceiveDivorceRequest            = 40001,
    EmsgServer_ReceiveDivorceResToReq           = 40002,
    EmsgServer_ReceiveCancelDivorce             = 40003,
    EmsgServer_ReceiveAcceptDivorceConfirm      = 40004,
    
};
#endif
