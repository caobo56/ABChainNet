//
//  KUNetWorking.m
//  textDemo
//
//  Created by caobo56 on 2018/4/23.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "KUNetWorking.h"
#import "KUNetWorkManager.h"
#import "FormaterDataObj.h"
#import "BasicMsgModel.h"
#import "KcpOnUdpObj.h"

#import "NSData+UTF8.h"
#import "NSDate+Timestamp.h"


@interface KUNetWorking()<NetWorkManagerDelegate>

@property(strong,nonatomic)NSMutableDictionary<NSString*,BCNetWorkingHandle*> * blockMap;

@property (nonatomic,strong)KUNetWorkManager * netWorkManager;

@end

@implementation KUNetWorking


+ (instancetype)sharedWithPort:(int)port{
    static KUNetWorking *netWorking = nil;
    @synchronized (self) {
        if (!netWorking) {
            netWorking = [[self alloc] init];
        }
    };
    return netWorking;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _blockMap = [NSMutableDictionary dictionaryWithCapacity:50];
        _netWorkManager = [[KUNetWorkManager alloc]init];
        _netWorkManager.delegate = self;
    }
    return self;
}

/**
 析构函数
 */
- (void)dealloc
{
    [_blockMap removeAllObjects];
    _blockMap = nil;
    _netWorkManager.delegate = nil;
    _netWorkManager = nil;
}

-(void)sendMessageWith:(GPBMessage *)msg andMsgId:(NSString *)msgId andToHost:(NSString *)host and:(BCNetWorkingCallBack)block{
//    NSLog(@"msgId == %@,class = %@",msgId,msg);
    if (msg) {
        FormaterDataObj * fmt = [[FormaterDataObj alloc]initWithObj:msg];
//        NSLog(@"fmt.resData = %@",fmt.resData);
        [_netWorkManager sendMsg:fmt.resData toHost:host toPort:DefaultPort];
        if (!msgId) {
            if (block) {
                block(nil,error(KUNetStructError));
            }
        }else{
            if (block) {
                BCNetWorkingHandle * handle = [[BCNetWorkingHandle alloc]initWithTimeout:Timeout];
                handle.msgID = msgId;
                handle.comp = block;
                handle.host = host;
                __weak __typeof(self)weakSelf = self;
                handle.timeoutComp = ^(NSString *msgID) {
                    BCNetWorkingHandle * handleInMap = [weakSelf.blockMap objectForKey:msgID];
//                     NSLog(@"有超时消息，msgID == %@",msgID);
                    if (handleInMap) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            handleInMap.comp(nil,error(KUNetTimeOut));
                        });
                        [weakSelf.blockMap removeObjectForKey:msgID];
                        handleInMap = nil;
//                        [weakSelf.netWorkManager closeKcpOnUdpWith:handleInMap.host];
                    }
                };
                [_blockMap setObject:handle forKey:msgId];
            }
        }
    }else{
        if (block) {
            block(nil,error(KUNetStructError));
        }
    }
}

#pragma mark - receiveMessage
/**
 数据接收接口
 
 @param msg 消息结构体
 @param msgId msgId 消息ID
 */
-(void)receiveMessageWith:(GPBMessage *)msg andMsgId:(NSString *)msgId{
    
}

#pragma mark - BasicMsgModelDelegate
-(void)msgModel:(BasicMsgModel *)msgModel didSendMsg:(NSData *)data from:(NSString *)host{
    [_netWorkManager sendMsg:data toHost:host toPort:DefaultPort];
}

#pragma mark - NetWorkManagerDelegate
- (void)netWorkManager:(KUNetWorkManager *)manager didReciveMsg:(NSData *)data from:(NSString *)host{
    FormaterDataObj * fmt = [[FormaterDataObj alloc]initFromData:data];
    if(fmt.payload){
        BasicMsgModel * msgModel = [BasicMsgModel creatWith:fmt andHost:host andDelegate:self];
        if (msgModel.responseId) {
            BCNetWorkingHandle * handle = [self.blockMap objectForKey:msgModel.responseId];
            if (handle && handle.type == HandleTypeNO) {
                handle.type = HandleTypeYES;
//                NSLog(@"self.blockMap = %@",self.blockMap);
                dispatch_async(dispatch_get_main_queue(), ^{
                    handle.comp(msgModel.payload, nil);
                });
                handle = nil;
                [self.blockMap removeObjectForKey:msgModel.responseId];
//                NSLog(@"self.blockMap = %@",self.blockMap);
            }
        }else{
            [self receiveMessageWith:fmt.payload andMsgId:msgModel.messageId];
        }
    }else{
        //        NSLog(@"返回数据解析异常！");
    }
}

-(void)netWorkManager:(KUNetWorkManager *)manager
 dataSendBusywithData:(NSData *)data
             withHost:(NSString *)host
             withPort:(int)port{
    FormaterDataObj * fmt = [[FormaterDataObj alloc]initFromData:data];
    if(fmt.payload){
        BasicMsgModel * msgModel = [BasicMsgModel creatWith:fmt andHost:host andDelegate:self];
        if (msgModel.messageId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                BCNetWorkingHandle * handle = [self.blockMap objectForKey:msgModel.messageId];
                if (handle && handle.type == HandleTypeNO) {
                    handle.type = HandleTypeYES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handle.comp(nil, error(KUNetHostBusy));
                    });
                    [self.blockMap removeObjectForKey:msgModel.responseId];
                    handle = nil;
                }
            });
        }
    }else{
        //NSLog(@"返回数据解析异常！");
    }
}

-(void)netWorkManager:(KUNetWorkManager *)manager failedBindToPortWithError:(NSError *)error{
    if ([self.blockMap allValues].count != 0) {
        for (__strong BCNetWorkingHandle * handle in self.blockMap) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handle.type = HandleTypeYES;
                handle.comp(nil, error(KUNetPortBindError));
            });
            handle = nil;
        }
        [self.blockMap removeAllObjects];
    }
}

-(void)netWorkManager:(KUNetWorkManager *)manager failedBeginReceivingWithError:(NSError *)error{
    if ([self.blockMap allValues].count != 0) {
        for (__strong BCNetWorkingHandle * handle in self.blockMap) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handle.type = HandleTypeYES;
                handle.comp(nil, error(KUNetReceiveError));
            });
            handle = nil;
        }
        [self.blockMap removeAllObjects];
    }
}


#pragma mark - NetWorkErrorMsg
/**
 NetworkErrCode_Unknown=0,
 NetworkErrCode_ReqParamError,
 NetworkErrCode_ReqURLError,
 NetworkErrCode_RespSCNot200
 
 @param input ErrorType
 @return NetWorkErrorMsg
 */
-(NSString* )NetWorkErrorMsg:(KUNetState)input{
    NSString * errorMsg = @"";
    switch (input) {
        case KUNetSucess:
            errorMsg = @"成功";
            break;
        case KUNetStructError:
            errorMsg = @"将要发送的对象结构错误，无法解析！";
            break;
        case KUNetHostBusy:
            errorMsg = @"当前ip路径数据拥塞，请稍后再尝试发送！";
            break;
        case KUNetPortBindError:
            errorMsg = @"UDP服务端口绑定失败！请检查网络设置！";
            break;
        case KUNetTimeOut:
            errorMsg = @"该请求已超时！";
            break;
        default:
            errorMsg = @"成功";
            break;
    }
    return errorMsg;
}

@end
