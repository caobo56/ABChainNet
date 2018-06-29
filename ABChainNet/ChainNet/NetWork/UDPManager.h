//
//  UDPManager.h
//  textDemo
//
//  Created by caobo56 on 2018/2/24.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncUdpSocket.h>

#import "KUNetWorkHeader.h"

@class UDPManager;
@protocol UDPManagerDelegate <NSObject>

/**
 udpManager DidReceiveData
 
 @param manager manager 当前对象
 @param data data 收到的数据
 @param address address 收到数据的来源，包括host 和 port
 @param filterContext filterContext description
 */
-(void)udpManager:(UDPManager*)manager didReceiveData:(NSData *)data
      fromAddress:(NSData *)address withFilterContext:(id)filterContext;

/**
 udpManager failedBindToPort

 @param manager manager 当前对象
 @param port port 将要绑定的端口
 @param error error 错误信息
 */
-(void)udpManager:(UDPManager*)manager failedBindToPort:(int)port error:(NSError *)error;

/**
 udpManager failedBeginReceiving

 @param manager manager 当前对象
 @param error error 错误信息
 */
-(void)udpManager:(UDPManager*)manager failedBeginReceivingWithError:(NSError *)error;

/**
 udpManager didCloseWithError

 @param manager manager 当前对象
 @param error error 错误信息
 */
@optional
-(void)udpManager:(UDPManager*)manager didCloseWithError:(NSError *)error;

/**
 udpManager didConnectToAddress

 @param manager manager 当前对象
 @param address address 对应地址
 */
@optional
-(void)udpManager:(UDPManager*)manager didConnectToAddress:(NSData *)address;

/**
 udpManager didNotConnect

 @param manager manager 当前对象
 @param error error 错误信息
 */
@optional
-(void)udpManager:(UDPManager*)manager didNotConnect:(NSError *)error;

@end

@interface UDPManager : NSObject

/**
 创建UDPManager 单例

 @param port port 指定UDP端口
 @return return value UDPManager单例实例
 */
+(instancetype)shareUDPManagerWithPort:(int)port;

/**
 重启UDP服务
 */
-(void)restartUDPServer;

/**
 UDPManagerDelegate
 */
@property(nonatomic,weak) id<UDPManagerDelegate> delegate;

/**
 UDPManager sendDataAPI

 @param data data 需要发送的数据
 @param host host 数据目的地host
 @param port port 数据目的地port
 @param timeout timeout UDPManager发送超时时间
 @param tag tag 发送标签，这里是上层KCP使用的标签，可以面向其他扩展，
                在消息回调的时候，可以通过tag区分消息
 */
- (void)sendData:(NSData *)data
          toHost:(NSString *)host
            port:(uint16_t)port
     withTimeout:(NSTimeInterval)timeout
             tag:(long)tag;

@end
