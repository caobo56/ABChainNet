//
//  KcpOnUdp.m
//  textDemo
//
//  Created by caobo56 on 2018/2/23.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "KUKcpOnUdp.h"
#import "KUKcpDataQueue.h"
#import "NSDate+Timestamp.h"


@interface KUKcpOnUdp ()<KcpDataQueueDelegate>

@property(strong,nonatomic)KUKcpDataQueue * dataQueue;
//KcpOnUdp 待发送包队列上限 2w

@property(strong,nonatomic)KcpOnUdpObj * kcpOnUdpObj;

@end

@implementation KUKcpOnUdp{
    dispatch_queue_t queueSend;
    long long lastTime;
}

+(KUKcpOnUdp *)creatKcpOnUdpWithHost:(NSString *)host andPort:(int)port{
    KUKcpOnUdp * sender = [[KUKcpOnUdp alloc]init];
    sender.kcpOnUdpObj = [[KcpOnUdpObj alloc]initWithHost:host];
    sender.kcpOnUdpObj.c_host = host;
    sender.kcpOnUdpObj.c_port = port;
    [sender loadSetting];
    return sender;
}

- (void)dealloc
{
    [KcpOnUdpObj releaseObjWithHost:self.kcpOnUdpObj.c_host];
    _dataQueue = nil;
    _kcpOnUdpObj = nil;
}

-(void)loadSetting{
    _dataQueue = [[KUKcpDataQueue alloc]init];
    _dataQueue.delegate = self;
    
    //设置KCP参数，同服务端或者对点端参数保持一致
    int32_t conv = 121106;
    _kcpOnUdpObj.c_kcp = ikcp_create(conv, NULL);
    _kcpOnUdpObj.c_kcp->output = c_udp_output;
    ikcp_nodelay(_kcpOnUdpObj.c_kcp, 1, 10, 1, 1);
    _kcpOnUdpObj.c_kcp->rx_minrto = 10;
    ikcp_wndsize(_kcpOnUdpObj.c_kcp, 64, 64);
    ikcp_setmtu(_kcpOnUdpObj.c_kcp, 512);

    _kcpOnUdpObj.c_kcpPoint = self;
    //设置栈上的 c_kcpPoint，以便在kcp的C函数中调用self

    queueSend = dispatch_queue_create(SendQueueName, DISPATCH_QUEUE_SERIAL);

    //设置在子线程中update，并设置ikcp_update 的频率
    [NSTimer scheduledTimerWithTimeInterval:0.01f repeats:YES block:^(NSTimer * _Nonnull timer) {
        dispatch_async(self->queueSend, ^{
            ikcp_update(self->_kcpOnUdpObj.c_kcp,clock());
            if ([self->_dataQueue count] != 0) {
                KcpObj * kcpObj = [self->_dataQueue queueFirstObj];
                int a = ikcp_send(self->_kcpOnUdpObj.c_kcp, kcpObj.data.bytes, (int)kcpObj.data.length);
                a = a;
//                NSLog(@" -- ikcp_send => %d  size => %ld kcpObj => %@",a,kcpObj.data.length, kcpObj.data);
                [self->_dataQueue removeKcpObj:kcpObj];
            }
        });
    }];
}

-(void)sendMsg:(NSData *)data toHost:(NSString *)ip toPort:(int)port{
    dispatch_async(queueSend, ^{
        if ([self->_dataQueue count] < UdpQueueSize) {
            [self->_dataQueue addKcpObj:data];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                KUKcpOnUdp * kcpPoint = self->_kcpOnUdpObj.c_kcpPoint;
                if (kcpPoint.delegate) {
                    [self->_delegate kcpOnUdp:self.kcpOnUdpObj didSendOverflowMsg:data toHost:ip port:port tag:kcpPoint.tag];
                }
            });
        }
    });
}

int c_udp_output(const char * buf, int len, ikcpcb * kcp, void * user)
{
//    NSLog(@"buf = %s len = %d",buf,len);
    NSData * data = [NSData dataWithBytes:buf length:len];
    dispatch_async(dispatch_get_main_queue(), ^{
        KcpOnUdpObj * obj = [KcpOnUdpObj getObjByKcp:kcp];
        KUKcpOnUdp * kcpPoint = obj.c_kcpPoint;
        NSString * host  = obj.c_host;
        int port = obj.c_port;
        int tag = kcpPoint.tag;
        if (kcpPoint.delegate) {
            [kcpPoint.delegate kcpOnUdp:obj didSendWithMsg:data toHost:host port:port tag:tag];
        }
    });
    return 0;
}

-(void)reciveMsg:(NSData *)data fromHost:(NSString *)ip fromPort:(int)port{
    dispatch_async(dispatch_get_main_queue(), ^{
        ikcpcb * c_kcp = self->_kcpOnUdpObj.c_kcp;
        
        int input = ikcp_input(c_kcp, data.bytes, data.length);
        if (input != 0) {
            return;
        }
        char buffer[1000000];
        int recv = ikcp_recv(c_kcp, buffer, sizeof(buffer));
        if (recv > 0) {
            NSData * receiveData = [NSData dataWithBytes:buffer length:recv];
            [self.dataQueue reciveKcpData:receiveData];
        }
    });
}

-(void)kcpDataQueue:(KUKcpDataQueue *)queue DidReciveData:(NSData *)data{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate) {
            [self.delegate kcpOnUdp:self.kcpOnUdpObj didReciveMsg:data];
        }
    });
}

@end




