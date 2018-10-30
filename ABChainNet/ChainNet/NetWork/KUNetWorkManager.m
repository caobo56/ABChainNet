//
//  NetWorkManager.m
//  textDemo
//
//  Created by caobo56 on 2018/2/27.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "KUNetWorkManager.h"

#import "KUKcpOnUdp.h"
#import "UDPManager.h"
#import "KcpOnUdpObj.h"


@interface KUNetWorkManager()<UDPManagerDelegate,KcpOnUdpDelegate>

@property(nonatomic,strong)UDPManager *udpManager;

@property(nonatomic,strong)NSMutableDictionary <NSString*,KUKcpOnUdp*>* pointMap;

@end

@implementation KUNetWorkManager{
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setNetWork];
    }
    return self;
}

-(void)setNetWork{
    _udpManager = [UDPManager shareUDPManagerWithPort:DefaultPort];
    _udpManager.delegate = self;
    _pointMap = [NSMutableDictionary dictionaryWithCapacity:12];
}

-(void)sendMsg:(NSData *)data toHost:(NSString *)host toPort:(int)port{
    KUKcpOnUdp * kcpPoint = [_pointMap objectForKey:host];
    if (!kcpPoint) {
        kcpPoint = [KUKcpOnUdp creatKcpOnUdpWithHost:host andPort:port];
        kcpPoint.delegate = self;
        kcpPoint.tag = (int)[[_pointMap allKeys] count];
        [_pointMap setObject:kcpPoint forKey:host];
    }
    [kcpPoint sendMsg:data toHost:host toPort:port];
}

-(void)closeKcpOnUdpWith:(NSString *)host{
    KUKcpOnUdp * kcpPoint = [_pointMap objectForKey:host];
    if (kcpPoint) {
        [_pointMap removeObjectForKey:host];
        kcpPoint = nil;
    }
}

-(void)closeAllKcpOnUdp{
    if (_pointMap.allKeys.count > 0) {
        [_pointMap removeAllObjects];
    }
}

- (void)dealloc
{
    [self closeAllKcpOnUdp];
}

#pragma mark - UDPManager delegate
- (void)udpManager:(UDPManager *)manager didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    if (!data || !address) {
        return;
    }
    
    if (data.length == 0) {
        return;
    }
    
    NSString * host = [GCDAsyncUdpSocket hostFromAddress:address];
    int port = [GCDAsyncUdpSocket portFromAddress:address];
    KUKcpOnUdp * kcpPoint = [_pointMap objectForKey:host];
    if (!kcpPoint) {
        kcpPoint = [KUKcpOnUdp creatKcpOnUdpWithHost:host andPort:port];
        kcpPoint.delegate = self;
        kcpPoint.tag = (int)[[_pointMap allKeys] count];
        [_pointMap setObject:kcpPoint forKey:host];
    }
    [kcpPoint reciveMsg:data fromHost:host fromPort:port];
}

-(void)udpManager:(UDPManager *)manager failedBindToPort:(int)port error:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(udpManager:failedBindToPort:error:)]) {
        [self.delegate netWorkManager:self failedBindToPortWithError:error];
    }
}

-(void)udpManager:(UDPManager *)manager failedBeginReceivingWithError:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(udpManager:failedBeginReceivingWithError:)]) {
        [self.delegate netWorkManager:self failedBeginReceivingWithError:error];
    }
}

#pragma mark - KcpOnUdp delegate
- (void)kcpOnUdp:(KcpOnUdpObj *)kcpPoint didReciveMsg:(NSData *)data {
    [_delegate netWorkManager:self didReciveMsg:data from:[kcpPoint.c_host copy] andPort:kcpPoint.c_port];
}

- (void)kcpOnUdp:(KcpOnUdpObj *)kcpPoint didSendWithMsg:(NSData *)data toHost:(NSString *)host port:(int)port tag:(int)tag {
    [_udpManager sendData:data toHost:host port:port withTimeout:Timeout tag:tag];
}

-(void)kcpOnUdp:(KcpOnUdpObj *)kcpPoint didSendOverflowMsg:(NSData *)data toHost:(NSString *)host port:(int)port tag:(int)tag{
    [self.delegate netWorkManager:self dataSendBusywithData:data withHost:[kcpPoint.c_host copy] withPort:tag];
}


@end
