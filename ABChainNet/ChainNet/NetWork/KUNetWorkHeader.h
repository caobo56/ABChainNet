//
//  KUNetWorkHeader.h
//  textDemo
//
//  Created by caobo56 on 2018/6/1.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#ifndef KUNetWorkHeader_h
#define KUNetWorkHeader_h

//------------------------网络层配置-------------------------------------

static NSString * const ZeroPointHost = @"10.10.103.76";
//static NSString * const ZeroPointHost = @"10.10.120.70";

static int const Timeout = 10.0f;//超时时间，udp networkhandle

static int const DefaultPort = 9612;//网络层默认端口号
//static int const DefaultPort = 10001;//网络层默认端口号

static NSString *const MagicStr = @"f9beb4d9";//序列化层的魔术关键字，用于识别

static char * const SendQueueName = "net.kcp.sendQueue";//kcp处理数据所用的子线程名称
static char * const UDPServerQueueName = "net.udp.serverQueue";//UDP处理数据所用的子线程名称

static const long KcpDataSize = 1400;//kcp处理数据时拆包的子包大小

static const long KDataSize = KcpDataSize - 12;//kcp处理拆包数据时的子包数据大小

static int UdpServerPort = 10000;//UDP服务的端口号，供程序更改

static int const UdpQueueSize = 20000;//KCP数据缓存区的大小

//------------------------开发设置-------------------------------------

#import "CBKeychain.h"

#define DeviceID [NSString stringWithFormat:@"Mobile-%@",[CBKeychain getDeviceIDInKeychain]]

#define WeakSelf __weak typeof(self) weakSelf = self;

#define error(Code) [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:Code userInfo:@{@"description":[self NetWorkErrorMsg:Code]}]

#define Ferror(Code,disc) [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:Code userInfo:@{@"description":disc}]


typedef enum{
    KUNetSucess = 0,    //成功
    KUNetStructError,   //数据结构解析失败
    KUNetHostBusy,      //发送host数据拥塞
    KUNetPortBindError, //本地发送服务端口绑定失败
    KUNetReceiveError,  //本地发送服务启动失败
    KUNetTimeOut        //数据应答超时
} KUNetState;           //网络状态的错误码状态

typedef enum{
    KUFindSucess = 10,   //成功
    KUFindEmpty,         //数据结构解析失败
    KUFindTimeOut        //数据应答超时
} KUFindState;           //find命令状态的错误码状态

static NSString *const Networkstate = @"networkstate";


#endif /* KUNetWorkHeader_h */
