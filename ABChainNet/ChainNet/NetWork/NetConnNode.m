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
#import "MsgIM.h"

#import <NSBencodeSerialization.h>

#import "NSData+UTF8.h"
#import "NSDate+Timestamp.h"

#import "GCDTimer.h"


@interface NetConnNode()

@property(strong,nonatomic)NSMutableArray<DiscoverReplyMessage_PeerAddress*> *peerAddressArray;


//@property(strong,nonatomic)NSMutableArray<DiscoverReplyMessage_PeerAddress*> *peerList;

@end

@implementation NetConnNode{
    
}

#pragma mark - init

static NetConnNode * nodeConn = nil;

+ (instancetype)shared
{
    static NetConnNode *sharedManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [NetConnNode creatNode];
    });
    return sharedManagerInstance;
}


+(NetConnNode *)creatNode{
    NetConnNode * sender = [[NetConnNode alloc]init];
    return sender;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _peerAddressArray = [NSMutableArray arrayWithCapacity:12];
    }
    return self;
}

-(void)setPeerAddressArray:(NSMutableArray<DiscoverReplyMessage_PeerAddress *> *)peerAddressArray{
    [_peerAddressArray removeAllObjects];
    
    [_peerAddressArray addObjectsFromArray:peerAddressArray];
    
    NSArray * arr_temp = [NSArray arrayWithArray:peerAddressArray];
    NSLog(@"arr_temp = %@",arr_temp);
    for (DiscoverReplyMessage_PeerAddress * peer in arr_temp) {
        NSLog(@"peer.id_p = %@",peer.id_p);
        if([peer.id_p isEqualToString:DeviceID]){
            NSUserDefaults * us = [NSUserDefaults standardUserDefaults];
            NSArray *address_array = [peer.address componentsSeparatedByString:@":"];
            [us setValue:[address_array[1] copy] forKey:@"divice_host"];
            [us setValue:[address_array[2] copy] forKey:@"divice_port"];
            [us setValue:DeviceID forKey:@"divice_ID"];
            [us synchronize];
            [_peerAddressArray removeObject:peer];
        }
    }
    
    DiscoverReplyMessage_PeerAddress * peer = [[DiscoverReplyMessage_PeerAddress alloc]init];
    peer.address = [NSString stringWithFormat:@"udp:%@:%ld",ZeroPointHost,DefaultPort];
    [_peerAddressArray addObject:[peer copy]];
    
//    [self sendVersionToPeerList];
    
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

-(void)sendTranstionWithUserInfo:(NSDictionary *)userInfo andScriptBytes:(NSData *)scriptBytes and:(NetConnNodeBlock)block{
    Transaction * trans = [MsgTransaction creatTransactionMessageWithUserInfo:userInfo andScriptBytes:scriptBytes];
    NSLog(@"trans == %@",trans);
    for (DiscoverReplyMessage_PeerAddress * peer in _peerAddressArray) {
        NSArray *address_array = [peer.address componentsSeparatedByString:@":"];
        [[BCNetWorking shared] sendTransactionMessageWith:trans andToHost:address_array[1] and:nil];
    }
    block(@"消息已经广播完成！",nil);
}




-(void)sendTranstionWithFileInfo:(NSDictionary *)fileInfo andScriptBytes:(NSData *)scriptBytes and:(NetConnNodeBlock)block{
    Transaction * trans = [MsgTransaction creatTransactionMessageWithFileInfo:fileInfo andScriptBytes:scriptBytes];
    NSLog(@"trans == %@",trans);
    for (DiscoverReplyMessage_PeerAddress * peer in _peerAddressArray) {
        NSArray *address_array = [peer.address componentsSeparatedByString:@":"];
        [[BCNetWorking shared] sendTransactionMessageWith:trans andToHost:address_array[1] and:nil];
    }
    block(@"消息已经广播完成！",nil);
}


-(void)sendTranstionWith:(Transaction *)trans With:(NetConnNodeBlock)block{
    for (DiscoverReplyMessage_PeerAddress * peer in _peerAddressArray) {
        NSArray *address_array = [peer.address componentsSeparatedByString:@":"];
        [[BCNetWorking shared] sendTransactionMessageWith:trans andToHost:address_array[1] and:nil];
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
    DiscoverReplyMessage_PeerAddress * peer = [[DiscoverReplyMessage_PeerAddress alloc]init];
    peer.address = [NSString stringWithFormat:@"udp:%@:%ld",ZeroPointHost,DefaultPort];
    __block NSString * blkfaceID = faceID;
    [self circulationFindFaceIDWith:blkfaceID and:peer and:^(id message, NSError *error) {
        findFaceIDBlock(message,error);
    }];
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
    NSArray *address_array = [peer.address componentsSeparatedByString:@":"];
    [[BCNetWorking shared] sendFindMessageWith:find andToHost:address_array[1] and:^(id receiveMsg, NSError *error) {
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


#pragma mark - findUserAddress

/**
 发送find命令
 
 @param userAddress userAddress 用户地址
 @param block block 回调block函数
 */
-(void)findUserAddressWith:(NSString *)userAddress and:(NetConnNodeBlock)block{
    DiscoverReplyMessage_PeerAddress * peer = [[DiscoverReplyMessage_PeerAddress alloc]init];
    
    peer.address = [NSString stringWithFormat:@"udp:%@:%ld",ZeroPointHost,DefaultPort];

    __block NSString * blockAddress = userAddress;

    FindMessage * find = [MsgFind creatFindMessageWithUserAddress:userAddress andPeer:peer];
    WeakSelf
    NSArray *address_array = [peer.address componentsSeparatedByString:@":"];
    [[BCNetWorking shared] sendFindMessageWith:find andToHost:address_array[1] and:^(id receiveMsg, NSError *error) {
        if (!error) {
            FindAckMessage * replay = (FindAckMessage *)receiveMsg;
            Transaction * trans = [weakSelf checkFindAckMessage:replay andUserAddress:blockAddress];
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
 向维持心跳的节点列表，广播find消息，并执行block。
 
 @param address faceID 查询条件
 @param peer peer 节点列表
 @param block block 回调函数
 */
-(void)circulationFindUserAddressWith:(NSString *)address and:(DiscoverReplyMessage_PeerAddress *)peer and:(NetConnNodeBlock)block{
    __block NSString * blockAddress = address;
    FindMessage * find = [MsgFind creatFindMessageWithUserAddress:address andPeer:peer];
    WeakSelf
    NSArray *address_array = [peer.address componentsSeparatedByString:@":"];

    [[BCNetWorking shared] sendFindMessageWith:find andToHost:address_array[1] and:^(id receiveMsg, NSError *error) {
        if (!error) {
            FindAckMessage * replay = (FindAckMessage *)receiveMsg;
            Transaction * trans = [weakSelf checkFindAckMessage:replay andUserAddress:blockAddress];
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
 @param address condition 查询条件
 @return return Transaction 返回查询成功的交易
 */
-(Transaction *)checkFindAckMessage:(FindAckMessage *)replay andUserAddress:(NSString *)address{
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
            if ([issueInput.sourceType isEqualToString:@"userAddress"] && [faceID isEqualToString:address]) {
                trans = [trans_p copy];
                break;
            }
        }
    }
    return trans;
}

#pragma mark - findFileInfos

-(void)findFileInfosWith:(NSString *)userAddress and:(NetConnNodeBlock)block{
    DiscoverReplyMessage_PeerAddress * peer = [[DiscoverReplyMessage_PeerAddress alloc]init];
    peer.address = [NSString stringWithFormat:@"udp:%@:%ld",ZeroPointHost,DefaultPort];

    __block NSString * blockAddress = userAddress;

    FindMessage * find = [MsgFind creatFindFileWithUserAddress:userAddress andPeer:peer];
    WeakSelf
    NSArray *address_array = [peer.address componentsSeparatedByString:@":"];
    [[BCNetWorking shared] sendFindMessageWith:find andToHost:address_array[1] and:^(id receiveMsg, NSError *error) {
        if (!error) {
            FindAckMessage * replay = (FindAckMessage *)receiveMsg;
            NSArray * trans = [weakSelf checkFileFindAckMessage:replay andUserAddress:blockAddress];
            if (trans.count > 0) {
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

-(NSArray *)checkFileFindAckMessage:(FindAckMessage *)replay andUserAddress:(NSString *)address{
    Transaction * trans = nil;
    NSError * error;
    NSArray * arr = [NSBencodeSerialization bencodedObjectWithData:replay.result.data_p error:&error];
    NSMutableArray * marr = [NSMutableArray arrayWithCapacity:12];
    if (!error && arr && arr.count > 0) {
        for (NSData * data in arr) {
            FormaterDataObj * obj = [[FormaterDataObj alloc]initFromData:data];
            Transaction * trans_p = (Transaction *)obj.payload;
            if (trans_p) {
                [marr addObject:trans_p];
            }
        }
    }
    return marr;
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
    NSLog(@"start VersionMessage");
    VersionMessage * ver = [MsgVersion creatVersionMessageWithOpCode:@"VER-1"];
    [[BCNetWorking shared] sendVersionMessageWith:ver andToHost:ZeroPointHost and:^(GPBMessage *receiveMsg, NSError *error) {
        if (!error) {
            NSLog(@"VersionMessage recive");
            [weakSelf startNetConnHeartbeat];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf sendDiscoverToZeroPoint];
            });
            if(self.delegate){
                [self.delegate netConnNode:self DidStart:YES];
            }
        }else{
            NSLog(@"VersionMessage timeout");
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
    NSLog(@"start DiscoverMessage");
    [[BCNetWorking shared] sendDiscoverMessageWith:[MsgDiscover creatDiscoverMessage] andToHost:ZeroPointHost and:^(GPBMessage *receiveMsg, NSError *error) {
        if (!error) {
            NSLog(@"DiscoverMessage recive");
            DiscoverReplyMessage * replay = (DiscoverReplyMessage *)receiveMsg;
            [weakSelf setPeerAddressArray:replay.peerAddressArray];
            
            if([weakSelf.delegate respondsToSelector:@selector(netConnNode:DidStart:)]){
                [weakSelf.delegate netConnNode:self DidStart:YES];
            }
        }else{
            NSLog(@"DiscoverMessage timeout");
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
#warning OpCode
        VersionMessage * version = [MsgVersion creatVersionMessageWithOpCode:@""];
        NSArray *address_array = [peer.address componentsSeparatedByString:@":"];
        [[BCNetWorking shared] sendVersionMessageWith:version andToHost:address_array[1] and:^(id receiveMsg, NSError *error) {
            if(!error){
                [weakSelf.peerAddressArray addObject:blockPeer];
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
    [self sendPingMessageWith:ZeroPointHost];
    return;
//    if (_peerAddressArray.count < 1) {
//        return;
//    }else{
//        for(DiscoverReplyMessage_PeerAddress * peer in _peerAddressArray){
//        }
//    }
}

/**
 sendPingMessage
 
 @param host host 对应节点的IP
 */
-(void)sendPingMessageWith:(NSString *)host{
    __block NSString * blockHost = host;
    WeakSelf
    PingMessage * pingMessage = [MsgPing creatPingMessage];
    [[BCNetWorking shared] sendPingMessageWith:pingMessage andToHost:host and:nil];
    NSLog(@"pingMessage send");
    return;
    [[BCNetWorking shared] sendPingMessageWith:pingMessage andToHost:host and:^(GPBMessage *receiveMsg, NSError *error) {
        if(!error){
            NSLog(@"receiveMsg From %@:\n%@",blockHost,receiveMsg);
        }else{
            NSLog(@"host %@ sendPingMessage %@",host,error.userInfo[@"description"]);
            NSArray * arr_temp = [NSArray arrayWithArray:weakSelf.peerAddressArray];
            for (DiscoverReplyMessage_PeerAddress * peer in arr_temp) {
                NSArray *address_array = [peer.address componentsSeparatedByString:@":"];
                if([address_array[1] isEqualToString:host]){
                    [weakSelf.peerAddressArray removeObject:peer];
                    NSLog(@"host %@ removed",host);
                }
            }
        }
    }];
}

@end
