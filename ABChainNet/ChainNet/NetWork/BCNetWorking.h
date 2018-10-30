//
//  BCNetWorking.h
//  textDemo
//
//  Created by caobo56 on 2018/3/19.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCNetWorkingHandle.h"
#import "KUNetWorking.h"
#import "Pbmessage.pbobjc.h"

/**
 BCNetWorking 是继承于KUNetWorking 面向业务层的网络调用API
 回调函数都是在主线程中执行的
 */
@interface BCNetWorking : KUNetWorking

+ (instancetype)shared;

/**
 sendVersionMessageWith
 
 @param versionMsg versionMsg version消息
 @param host host IP地址
 @param block block 回调函数
 */
-(void)sendVersionMessageWith:(VersionMessage *)versionMsg andToHost:(NSString *)host and:(BCNetWorkingCallBack)block;

/**
 sendPingMessage
 
 @param pingMsg pingMsg ping消息
 @param host host IP地址
 @param block block 回调函数
 */
-(void)sendPingMessageWith:(PingMessage *)pingMsg andToHost:(NSString *)host and:(BCNetWorkingCallBack)block;

/**
 sendDiscoverMessage
 
 @param discoverMsg discoverMsg discover消息
 @param host host IP地址
 @param block block 回调函数
 */
-(void)sendDiscoverMessageWith:(DiscoverMessage *)discoverMsg andToHost:(NSString *)host and:(BCNetWorkingCallBack)block;

/**
 sendFindMessage

 @param findMsg findMsg find消息
 @param host host IP地址
 @param block block 回调函数
 */
-(void)sendFindMessageWith:(FindMessage *)findMsg andToHost:(NSString *)host and:(BCNetWorkingCallBack)block;

/**
 sendIMMessage
 
 @param imMsg imMsg im消息
 @param host host IP地址
 @param block block 回调函数
 */
-(void)sendIMMessageWith:(IMMessage *)imMsg andToHost:(NSString *)host and:(BCNetWorkingCallBack)block;


/**
 sendTransaction

 @param trans trans 要广播的交易
 @param host host 交易到达的节点
 @param block block 回调函数
 */
-(void)sendTransactionMessageWith:(Transaction *)trans andToHost:(NSString *)host and:(BCNetWorkingCallBack)block;


@end
