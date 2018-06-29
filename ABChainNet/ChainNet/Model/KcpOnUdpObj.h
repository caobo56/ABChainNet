//
//  KcpOnUdpObj.h
//  textDemo
//
//  Created by caobo56 on 2018/3/6.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pbmessage.pbobjc.h"

#import <arpa/inet.h>
#import <netdb.h>
#import "ikcp.h"


@class KUKcpOnUdp;

/**
 KcpOnUdpObj KcpOnUdp对象，方便KcpOnUdp多线程管理
 */
@interface KcpOnUdpObj : NSObject

@property(strong,nonatomic) NSString * c_host;
@property(assign,nonatomic) int c_port;
@property(assign,nonatomic) ikcpcb * c_kcp;
@property(weak,nonatomic) KUKcpOnUdp * c_kcpPoint;

/**
 创建

 @param host host description
 @return return value description
 */
- (instancetype)initWithHost:(NSString *)host;

/**
 释放host对应的kcp对象
 */
+(void)releaseObjWithHost:(NSString *)host;

/**
 通过kcp，在hostKcpDict中，查找对应的 KcpOnUdpObj 对象

 @param kcp kcp 指针
 @return return kcpOnUdpObj KcpOnUdpObj对象
 */
+(KcpOnUdpObj *)getObjByKcp:(ikcpcb *)kcp;

/**
 通过host，在hostKcpDict中，查找对应的 KcpOnUdpObj 对象
 
 @param host host ip地址
 @return return kcpOnUdpObj KcpOnUdpObj对象
 */
+(KcpOnUdpObj *)getObjByHost:(NSString *)host;

@end


/**
 KcpObj Kcp发送数据对象，仅有data,单独列出对象，方便管理
 */
@interface KcpObj:NSObject

@property(copy,nonatomic) NSData * data;

@end


/**
 ReciveData Kcp收数据对象，方便数据合包
 */
@interface ReciveData:NSObject

@property(assign,nonatomic)int count;
@property(assign,nonatomic)int index;
@property(strong,nonatomic)NSString * dataId;
@property(strong,nonatomic)NSData *data;

- (instancetype)initWithData:(NSData *)data;

@end




