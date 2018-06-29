//
//  KcpDataQueue.h
//  textDemo
//
//  Created by caobo56 on 2018/3/7.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KcpOnUdpObj.h"
#import "KUNetWorkHeader.h"

@class KUKcpDataQueue;

/**
 KcpDataQueueDelegate
 */
@protocol KcpDataQueueDelegate <NSObject>

/**
 kcpDataQueue DidReciveData

 @param queue queue 当前队列对象
 @param data data 当前收到的拼接好的完整数据
 */
-(void)kcpDataQueue:(KUKcpDataQueue *)queue DidReciveData:(NSData *)data;

@end

/**
 KcpDataQueue kcp发送数据所用的队列管理类
 主要负责，将大的数据包拆成适合KCP协议发送的数据包，以防止KCP数据包数据丢失
 内部实现了两个队列管理
 管理对象为 1）kcpobj     发送数据对象
          2）ReciveData 接收的数据的对象
 */
@interface KUKcpDataQueue : NSObject

/**
 KcpDataQueue 的 队列长度 count

 @return return count
 */
-(NSInteger)count;

/**
 addKcpObj 添加kcp 对象

 @param obj obj description
 */
-(void)addKcpObj:(NSData *)obj;

/**
 获取队列首对象，即发送的第一个对象

 @return return KcpObj 发送数据对象
 */
-(KcpObj *)queueFirstObj;

/**
 删除指定的发送对象

 @param obj KcpObj
 */
-(void)removeKcpObj:(KcpObj *)obj;

/**
 在接受队列里增加新收到的数据

 @param data data 新收到的数据
 */
-(void)reciveKcpData:(NSData *)data;

/**
 KcpDataQueueDelegate
 */
@property(weak,nonatomic)id<KcpDataQueueDelegate> delegate;


@end
