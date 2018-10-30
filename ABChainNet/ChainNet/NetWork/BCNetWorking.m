//
//  BCNetWorking.m
//  textDemo
//
//  Created by caobo56 on 2018/3/19.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "BCNetWorking.h"
#import "KUNetWorkHeader.h"
@implementation BCNetWorking

#pragma mark - public Method

+ (instancetype)shared{
    return [BCNetWorking sharedWithPort:DefaultPort];
}

/**
 sendVersionMessageWith

 @param versionMsg versionMsg version消息
 @param host host IP地址
 @param block block 回调函数
 */
-(void)sendVersionMessageWith:(VersionMessage *)versionMsg andToHost:(NSString *)host and:(BCNetWorkingCallBack)block{
    [self sendMessageWith:versionMsg andMsgId:versionMsg.messageId andToHost:host and:block];
}

/**
 sendPingMessage

 @param pingMsg pingMsg ping消息
 @param host host IP地址
 @param block block 回调函数
 */
-(void)sendPingMessageWith:(PingMessage *)pingMsg andToHost:(NSString *)host and:(BCNetWorkingCallBack)block{
    [self sendMessageWith:pingMsg andMsgId:pingMsg.messageId andToHost:host and:block];
}

/**
 sendDiscoverMessage

 @param discoverMsg discoverMsg discover消息
 @param host host IP地址
 @param block block 回调函数
 */
-(void)sendDiscoverMessageWith:(DiscoverMessage *)discoverMsg andToHost:(NSString *)host and:(BCNetWorkingCallBack)block{
    [self sendMessageWith:discoverMsg andMsgId:discoverMsg.messageId andToHost:host and:block];
}

/**
 sendFindMessage
 
 @param findMsg findMsg find消息
 @param host host IP地址
 @param block block 回调函数
 */
-(void)sendFindMessageWith:(FindMessage *)findMsg andToHost:(NSString *)host and:(BCNetWorkingCallBack)block{
    [self sendMessageWith:findMsg andMsgId:findMsg.messageId andToHost:host and:block];
}

/**
 sendIMMessage
 
 @param imMsg imMsg im消息
 @param host host IP地址
 @param block block 回调函数
 */
-(void)sendIMMessageWith:(IMMessage *)imMsg andToHost:(NSString *)host and:(BCNetWorkingCallBack)block{
    [self sendMessageWith:imMsg andMsgId:imMsg.messageId andToHost:host and:block];
}

/**
 sendTransaction
 
 @param trans trans 要广播的交易
 @param host host 交易到达的节点
 @param block block 回调函数
 */
-(void)sendTransactionMessageWith:(Transaction *)trans andToHost:(NSString *)host and:(BCNetWorkingCallBack)block{
    [self sendMessageWith:trans andMsgId:trans.messageId andToHost:host and:block];
}


#pragma mark - receiveMessage
/**
 数据接收接口
 
 @param msg 消息结构体
 @param msgId msgId 消息ID
 @param host host 发送方地址
 @param port port 发送方端口
 */
-(void)receiveMessageWith:(GPBMessage *)msg andMsgId:(NSString *)msgId from:(NSString *)host andPort:(int)port{
    if ([msg isKindOfClass:[IMMessage class]]) {
        NSDictionary * dict = @{
                                @"msg":(IMMessage *)msg,
                                @"msgId":msgId,
                                @"host":host,
                                @"port":@(port)
                                };
        [[NSNotificationCenter defaultCenter] postNotificationName:IMMessageNotification object:dict];
    }
}

@end
