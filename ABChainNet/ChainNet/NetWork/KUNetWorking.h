//
//  KUNetWorking.h
//  textDemo
//
//  Created by caobo56 on 2018/4/23.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KUNetWorkHeader.h"

#import "BCNetWorkingHandle.h"
#import "Pbmessage.pbobjc.h"


/**
 BCNetWorking 是面向业务层的网络调用API
 隐藏下层的网络实现
 单例模式
 实现上层发消息同回调函数整合
 回调函数都是在主线程中执行的
 */
@interface KUNetWorking : NSObject

/**
 单例
 
 @return return 单例对象
 */
+ (instancetype)sharedWithPort:(int)port;

/**
 数据发送接口

 @param msg 消息结构体
 @param msgId msgId 消息ID
 @param host host 端口
 @param block block 回调
 */
-(void)sendMessageWith:(GPBMessage *)msg andMsgId:(NSString *)msgId andToHost:(NSString *)host and:(BCNetWorkingCallBack)block;


@end
