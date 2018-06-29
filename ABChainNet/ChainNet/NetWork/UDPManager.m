//
//  UDPManager.m
//  textDemo
//
//  Created by caobo56 on 2018/2/24.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "UDPManager.h"

@interface UDPManager ()<GCDAsyncUdpSocketDelegate>

@property(nonatomic,strong)GCDAsyncUdpSocket *reciveSocket;

@end

@implementation UDPManager

static UDPManager *udpManager;

+ (instancetype)shareUDPManagerWithPort:(int)port{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UdpServerPort = port;
        udpManager = [[self alloc] init];
    });
    return udpManager;
}

-(void)restartUDPServer{
    [_reciveSocket close];
    _reciveSocket.delegate = nil;
    _reciveSocket = nil;
    UdpServerPort = 10000;
    [self loadSetting];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadSetting];
    }
    return self;
}

-(void)loadSetting{
    dispatch_queue_t sQueue = dispatch_queue_create(UDPServerQueueName, NULL);
    _reciveSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:sQueue];
    NSError *error;
    [_reciveSocket bindToPort:UdpServerPort error:&error];
    if (error) {
        [self.delegate udpManager:self failedBindToPort:UdpServerPort error:error];
    }
    NSError *perror;
    [_reciveSocket beginReceiving:&perror];
    if (perror) {
        [self.delegate udpManager:self failedBeginReceivingWithError:perror];
    }
}

- (void)dealloc {
    [_reciveSocket close];
    _reciveSocket = nil;
}

- (void)sendData:(NSData *)data
          toHost:(NSString *)host
            port:(uint16_t)port
     withTimeout:(NSTimeInterval)timeout
             tag:(long)tag
{
//    NSLog(@"udp == %s",[data bytes]);
    [_reciveSocket sendData:data toHost:host port:port withTimeout:timeout tag:tag];
}


#pragma mark delegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    [self.delegate udpManager:self didReceiveData:data fromAddress:address withFilterContext:filterContext];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address{
    if (self.delegate && [self.delegate respondsToSelector:@selector(udpManager:didConnectToAddress:)]) {
        [self.delegate udpManager:self didConnectToAddress:address];
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(udpSocket:didNotConnect:)]) {
        [self.delegate udpManager:self didNotConnect:error];
    }
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(udpManager:didCloseWithError:)]) {
        [self.delegate udpManager:self didCloseWithError:error];
    }
}


@end
