//
//  NetWorkManager.h
//  textDemo
//
//  Created by caobo56 on 2018/2/27.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KUNetWorkHeader.h"

@class KUNetWorkManager;

/**
 NetWorkManagerDelegate
 NetWorkManager 的代理
 */
@protocol NetWorkManagerDelegate <NSObject>

/**
 netWorkManager didReciveMsg

 @param manager manager 当前manager对象
 @param data data 本次manager对象收到的数据
 @param host host 本次manager消息对方的host
 */
-(void)netWorkManager:(KUNetWorkManager *)manager didReciveMsg:(NSData *)data from:(NSString *)host;

/**
 netWorkManager isBusyWithHost

 @param manager manager 当前manager对象
 @param data data 本次manager消息对方的host
 @param host host 当前拥塞的ip路径
 @param port port 当前拥塞的ip路径 使用的端口
 */
-(void)netWorkManager:(KUNetWorkManager *)manager
 dataSendBusywithData:(NSData *)data
             withHost:(NSString *)host
             withPort:(int)port;

/**
 netWorkManager failedBindToPortWithError
 
 @param manager manager 当前对象
 @param error error 错误信息
 */
@optional
-(void)netWorkManager:(KUNetWorkManager *)manager failedBindToPortWithError:(NSError *)error;

/**
 netWorkManager failedBeginReceivingWithError
 
 @param manager manager 当前对象
 @param error error 错误信息
 */
@optional
-(void)netWorkManager:(KUNetWorkManager *)manager failedBeginReceivingWithError:(NSError *)error;


@end

/**
 NetWorkManager
 网络节点收发管理类
 实现内部的 KCP 多节点 管理
 保证一个host 对应一个 KCPNode，可以让消息收发互相隔离
 */
@interface KUNetWorkManager : NSObject

/**
 NetWorkManagerDelegate 代理方法
 */
@property(nonatomic,weak) id<NetWorkManagerDelegate> delegate;

/**
 发送消息接口

 @param data data 将要发送的数据
 @param ip ip 要发送到对应的节点
 @param port port 要发送到对应的端口
 */
-(void)sendMsg:(NSData *)data toHost:(NSString *)ip toPort:(int)port;

/**
 关闭所有的KcpOnUdp
 */
-(void)closeAllKcpOnUdp;

/**
 在异常情况下，关闭host对应的kcp

 @param host host kcp的host
 */
-(void)closeKcpOnUdpWith:(NSString *)host;

@end
