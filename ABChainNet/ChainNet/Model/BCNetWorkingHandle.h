//
//  BCNetWorkingHandle.h
//  textDemo
//
//  Created by caobo56 on 2018/3/21.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BCNetWorkingCallBack)(id receiveMsg,NSError * error);

typedef void(^BCNetWorkingTimeout)(NSString * msgID);

typedef enum{
    TypeDefault = 0,//默认
    HandleTypeYES,        //handle已解析
    HandleTypeNO          //handle未解析
} HandleType;

/**
 BCNetWorkingHandle
 block不能直接存储到NSDictory，
 那就先把block 用Handle 持有，
 再用NSDictory 来管理Handle，
 从而达到间接的管理block对象
 */
@interface BCNetWorkingHandle : NSObject

/**
 初始化

 @param timeout timeout 超时时间
 @return return value BCNetWorkingHandle对象
 */
- (instancetype)initWithTimeout:(float)timeout;

@property(strong,nonatomic)NSString * msgID;

@property(strong,nonatomic)NSString * host;

/**
 BCNetWorkingCallBack block 回调对象
 */
@property(copy,nonatomic)BCNetWorkingCallBack comp;

@property(assign,nonatomic)HandleType type;

@property(copy,nonatomic)BCNetWorkingTimeout timeoutComp;

@end
