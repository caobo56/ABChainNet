//
//  NetConnNode.h
//  textDemo
//
//  Created by caobo56 on 2018/3/15.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetConnNode;
@class DiscoverReplyMessage_PeerAddress;
@class Transaction;

typedef void(^NetConnNodeBlock)(id message,NSError * error);

@protocol NetConnNodeDelegate <NSObject>

-(void)netConnNode:(NetConnNode *)node DidStart:(BOOL)type;

-(void)netConnNode:(NetConnNode *)node updatPeerArr:(NSMutableArray<DiscoverReplyMessage_PeerAddress*> *)arr;

@end

@interface NetConnNode : NSObject

@property(weak,nonatomic)id<NetConnNodeDelegate> delegate;

+(NetConnNode *)creatNode;

+ (instancetype)shared;

/**
 开始链接区块链，提供重试的方法
 */
-(void)startConnection;

/**
 对外提供的手动刷新节点列表
 
 @param block block 刷新节点列表成功的回调
 */
-(void)sendDiscoverWith:(NetConnNodeBlock)block;

/**
 发送find命令
 
 @param faceID faceID 人脸ID
 @param block block 回调block函数
 */
-(void)findFaceIDWith:(NSString *)faceID and:(NetConnNodeBlock)block;

/**
 发送find命令
 
 @param userAddress userAddress 用户地址
 @param block block 回调block函数
 */
-(void)findUserAddressWith:(NSString *)userAddress and:(NetConnNodeBlock)block;

/**
 用对方用的userAddress 查出对方用户目前在区块链上的Host

 @param userAddress userAddress userAddress
 @param block block 回调block函数
 */
-(void)findHostWith:(NSString *)userAddress and:(NetConnNodeBlock)block;

/**
 发送Transtion命令，创建由faceID生成一笔交易并广播
 
 @param faceID faceID 人脸ID
 @param scriptBytes scriptBytes 交易的锁定脚本
 @param block block 回调block函数
 */
-(void)sendTranstionWith:(NSString *)faceID andScriptBytes:(NSData *)scriptBytes and:(NetConnNodeBlock)block;

/**
 发送Transtion命令，创建由userInfo生成一笔交易并广播
 
 @param userInfo NSDictionary 用户信息
 @param scriptBytes scriptBytes 交易的锁定脚本
 @param block block 回调block函数
 */
-(void)sendTranstionWithUserInfo:(NSDictionary *)userInfo andScriptBytes:(NSData *)scriptBytes and:(NetConnNodeBlock)block;

/**
 发送Transtion命令
 
 @param trans trans 要发送的Transaction消息
 @param block block 回调block函数
 */
-(void)sendTranstionWith:(Transaction *)trans With:(NetConnNodeBlock)block;

@end
