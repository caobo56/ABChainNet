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
 sendTransaction
 
 @param trans trans 要广播的交易
 @param host host 交易到达的节点
 @param block block 回调函数
 */
-(void)sendTransactionMessageWith:(Transaction *)trans andToHost:(NSString *)host and:(BCNetWorkingCallBack)block{
    [self sendMessageWith:trans andMsgId:trans.messageId andToHost:host and:block];
}

@end
