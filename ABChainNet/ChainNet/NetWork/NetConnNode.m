//
//  NetConnNode.m
//  textDemo
//
//  Created by caobo56 on 2018/3/15.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "NetConnNode.h"

#import "BCNetWorking.h"

#import "Pbmessage.pbobjc.h"
#import "FormaterDataObj.h"
#import "BasicMsgModel.h"
#import "KcpOnUdpObj.h"
#import "MsgVersion.h"
#import "MsgPingPong.h"
#import "MsgDiscover.h"
#import "MsgFind.h"
#import "MsgTransaction.h"

#import <NSBencodeSerialization.h>

#import "NSData+UTF8.h"
#import "NSDate+Timestamp.h"

#import "GCDTimer.h"


@interface NetConnNode()

@property(strong,nonatomic)NSMutableArray<DiscoverReplyMessage_PeerAddress*> *peerAddressArray;


@property(strong,nonatomic)NSMutableArray<DiscoverReplyMessage_PeerAddress*> *peerList;

@end

@implementation NetConnNode{
    
}

#pragma mark - init
+ (instancetype)shared{
    static NetConnNode * nodeConn = nil;
    @synchronized (self) {
        if (!nodeConn) {
            nodeConn = [NetConnNode creatNode];
        }
    }
    return nodeConn;
}

+(NetConnNode *)creatNode{
    NetConnNode * sender = [[NetConnNode alloc]init];
    return sender;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self startConnection];
        _peerAddressArray = [NSMutableArray arrayWithCapacity:12];
        _peerList = [NSMutableArray arrayWithCapacity:12];
    }
    return self;
}

-(void)setPeerAddressArray:(NSMutableArray<DiscoverReplyMessage_PeerAddress *> *)peerAddressArray{
    [_peerAddressArray removeAllObjects];
    
    [_peerAddressArray addObjectsFromArray:peerAddressArray];
    
    NSArray * arr_temp = [NSArray arrayWithArray:_peerAddressArray];
    for (DiscoverReplyMessage_PeerAddress * peer in arr_temp) {
        if([peer.id_p isEqualToString:DeviceID]){
            NSUserDefaults * us = [NSUserDefaults standardUserDefaults];
            [us setValue:peer.ip forKey:@"divice_host"];
            [us setValue:[NSString stringWithFormat:@"%d",peer.port] forKey:@"divice_port"];
            [us setValue:DeviceID forKey:@"divice_ID"];
            [us synchronize];
            [_peerAddressArray removeObject:peer];
        }
    }
    
    DiscoverReplyMessage_PeerAddress * peer = [[DiscoverReplyMessage_PeerAddress alloc]init];
    peer.ip = ZeroPointHost;
    peer.port = DefaultPort;
    [_peerAddressArray addObject:[peer copy]];
    
    [_peerList removeAllObjects];
    [_peerList addObject:[peer copy]];
    
    [self sendVersionToPeerList];
    
    if([self.delegate respondsToSelector:@selector(netConnNode:updatPeerArr:)]){
        [self.delegate netConnNode:self updatPeerArr:self.peerAddressArray];
    }
}

#pragma mark - Public FUNC
/**
 对外提供的手动刷新节点列表
 
 @param block block 刷新节点列表成功的回调
 */
-(void)sendDiscoverWith:(NetConnNodeBlock)block{
    WeakSelf
    [[BCNetWorking shared] sendDiscoverMessageWith:[MsgDiscover creatDiscoverMessage] andToHost:ZeroPointHost and:^(GPBMessage *receiveMsg, NSError *error) {
        if (!error) {
            DiscoverReplyMessage * replay = (DiscoverReplyMessage *)receiveMsg;
            [weakSelf setPeerAddressArray:replay.peerAddressArray];
            
            if(block){
                block(weakSelf.peerAddressArray,nil);
            }
        }else{
            if(block){
                block(nil,[[NSError alloc]initWithDomain:NSCocoaErrorDomain code:error.code userInfo:@{@"description":error.userInfo[@"description"]}]);
            }
        }
    }];
}

#pragma mark - SendTranstion

-(void)sendTranstionWith:(NSString *)faceID andScriptBytes:(NSData *)scriptBytes and:(NetConnNodeBlock)block{
    Transaction * trans = [MsgTransaction creatTransactionMessageWith:faceID andScriptBytes:scriptBytes];
    NSLog(@"trans == %@",trans);
    for (DiscoverReplyMessage_PeerAddress * peer in _peerList) {
        [[BCNetWorking shared] sendTransactionMessageWith:trans andToHost:peer.ip and:nil];
    }
    block(@"消息已经广播完成！",nil);
}



#pragma mark - FindFaceID
/**
 发送find命令
 
 @param faceID faceID 人脸ID
 @param findFaceIDBlock block 回调block函数
 */
-(void)findFaceIDWith:(NSString *)faceID and:(NetConnNodeBlock)findFaceIDBlock{
    NSMutableArray<Transaction *> * transArr = [NSMutableArray arrayWithCapacity:12];
    __block NSMutableArray<Transaction *> * blk_transArr = transArr;
    int allCount = 0;
    int timeoutCount = 0;
    int emptyCount = 0;
    __block int blk_allCount = allCount;
    __block int blk_timeoutCount = timeoutCount;
    __block int blk_emptyCount = emptyCount;
    WeakSelf
    for(DiscoverReplyMessage_PeerAddress * peer in _peerList){
        [self circulationFindFaceIDWith:faceID and:peer and:^(id message, NSError *error) {
            if (!error) {
                [blk_transArr addObject:message];
            }else if (error.code == KUFindEmpty){
                blk_emptyCount++;
            }else if (error.code == KUFindTimeOut){
                blk_timeoutCount++;
            }
            blk_allCount++;
            if (blk_allCount == weakSelf.peerList.count) {
                NSDictionary * dict = @{
                                        @"allCount":@(blk_allCount),
                                        @"timeoutCount":@(blk_timeoutCount),
                                        @"emptyCount":@(blk_emptyCount),
                                        @"trans":blk_transArr
                                        };
                findFaceIDBlock(dict,nil);
            }
        }];
    }
}

/**
 向维持心跳的节点列表，广播find消息，并执行block。
 
 @param faceID faceID 查询条件
 @param peer peer 节点列表
 @param block block 回调函数
 */
-(void)circulationFindFaceIDWith:(NSString *)faceID and:(DiscoverReplyMessage_PeerAddress *)peer and:(NetConnNodeBlock)block{
    __block NSString * blockFaceId = faceID;
    FindMessage * find = [MsgFind creatFindMessageWithFaceID:faceID andPeer:peer];
    WeakSelf
    [[BCNetWorking shared] sendFindMessageWith:find andToHost:peer.ip and:^(id receiveMsg, NSError *error) {
        if (!error) {
            FindAckMessage * replay = (FindAckMessage *)receiveMsg;
            Transaction * trans = [weakSelf checkFindAckMessage:replay andCondition:blockFaceId];
            if (trans) {
                block(trans,nil);
            }else{
                block(nil,Ferror(KUFindEmpty,@"未查询到相关结果！"));
            }
        }else{
            if (error.code == KUNetTimeOut) {
                block(nil,Ferror(KUFindTimeOut,@"find超时！"));
            }else{
                block(nil,error);
            }
        }
    }];
}


/**
 checkFindAckMessage
 
 @param replay replay FindAckMessage
 @param condition condition 查询条件
 @return return Transaction 返回查询成功的交易
 */
-(Transaction *)checkFindAckMessage:(FindAckMessage *)replay andCondition:(NSString *)condition{
    Transaction * trans = nil;
    NSError * error;
    NSArray * arr = [NSBencodeSerialization bencodedObjectWithData:replay.result.data_p error:&error];
    if (!error && arr && arr.count > 0) {
        //#warning arr[0] 此处需判断哪一个Transaction 是有效的
        FormaterDataObj * obj = [[FormaterDataObj alloc]initFromData:arr[0]];
        Transaction * trans_p = (Transaction *)obj.payload;
        NSLog(@"%@",trans_p);
        for (Transaction_Inputs * input in trans_p.inputsArray) {
            Transaction_Inputs_IssueInput * issueInput = input.issueInput;
            NSString * faceID = [issueInput.data_p utf8String];
            if ([issueInput.sourceType isEqualToString:@"faceID"] && [faceID isEqualToString:condition]) {
                trans = [trans_p copy];
                break;
            }
        }
    }
    return trans;
}

#pragma mark - StartConnect
-(void)startConnection{
    [self sendVersionMessageToZeroPoint];
}

/**
 连接零类节点
 */
-(void)sendVersionMessageToZeroPoint{
    WeakSelf
    VersionMessage * ver = [MsgVersion creatVersionMessage];
    [[BCNetWorking shared] sendVersionMessageWith:ver andToHost:ZeroPointHost and:^(GPBMessage *receiveMsg, NSError *error) {
        if (!error) {
            NSUserDefaults * us = [NSUserDefaults standardUserDefaults];
            [us setValue:@"YES" forKey:Networkstate];
            [us synchronize];
            [weakSelf sendDiscoverToZeroPoint];
            [weakSelf startNetConnHeartbeat];
            if(self.delegate){
                [self.delegate netConnNode:self DidStart:YES];
            }
        }else{
            if(self.delegate){
                [self.delegate netConnNode:self DidStart:NO];
            }
        }
    }];
}

/**
 sendDiscover 发送消息
 */
-(void)sendDiscoverToZeroPoint{
    WeakSelf
    [[BCNetWorking shared] sendDiscoverMessageWith:[MsgDiscover creatDiscoverMessage] andToHost:ZeroPointHost and:^(GPBMessage *receiveMsg, NSError *error) {
        if (!error) {
            DiscoverReplyMessage * replay = (DiscoverReplyMessage *)receiveMsg;
            [weakSelf setPeerAddressArray:replay.peerAddressArray];
            
            if([weakSelf.delegate respondsToSelector:@selector(netConnNode:DidStart:)]){
                [weakSelf.delegate netConnNode:self DidStart:YES];
            }
        }else{
            if([weakSelf.delegate respondsToSelector:@selector(netConnNode:DidStart:)]){
                [weakSelf.delegate netConnNode:self DidStart:NO];
            }
        }
    }];
}

/**
 sendVersionToPeerList
 */
-(void)sendVersionToPeerList{
    for(__strong DiscoverReplyMessage_PeerAddress * peer in _peerAddressArray){
        WeakSelf
        __block DiscoverReplyMessage_PeerAddress * blockPeer = peer;
        VersionMessage * version = [MsgVersion creatVersionMessage];
        [[BCNetWorking shared] sendVersionMessageWith:version andToHost:peer.ip and:^(id receiveMsg, NSError *error) {
            if(!error){
                [weakSelf.peerList addObject:blockPeer];
            }
        }];
    }
}

/**
 开始执行心跳
 */
-(void)startNetConnHeartbeat{
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(netConnHeartbeat) userInfo:nil repeats:YES];
}

/**
 每次心跳执行的Action
 */
-(void)netConnHeartbeat{
    if (_peerList.count < 1) {
        return;
    }else{
        for(DiscoverReplyMessage_PeerAddress * peer in _peerList){
            [self sendPingMessageWith:peer.ip];
        }
    }
}

/**
 sendPingMessage
 
 @param host host 对应节点的IP
 */
-(void)sendPingMessageWith:(NSString *)host{
    __block NSString * blockHost = host;
    PingMessage * pingMessage = [MsgPing creatPingMessage];
    [[BCNetWorking shared] sendPingMessageWith:pingMessage andToHost:host and:^(GPBMessage *receiveMsg, NSError *error) {
        if(!error){
            NSLog(@"receiveMsg From %@:\n%@",blockHost,receiveMsg);
        }else{
            NSLog(@"sendPingMessage %@",error.userInfo[@"description"]);
        }
    }];
}

@end
