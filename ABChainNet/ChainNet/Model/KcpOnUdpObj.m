//
//  KcpOnUdpObj.m
//  textDemo
//
//  Created by caobo56 on 2018/3/6.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "KcpOnUdpObj.h"

/**
 static关键字修饰局部变量：
 1：当static关键字修饰局部变量时，该局部变量只会初始化一次，在系统中只有一份内存
 2：static关键字不可以改变局部变量的作用域，
 但是可延长局部变量的生命周期，
 该变量直到整个项目结束的时候才会被销毁
 */
static NSMutableDictionary <NSString *,KcpOnUdpObj *>* hostKcpDict;
//kcpOnUdpObj 的 以host 为 索引的字典
// The Dict for kcpOnUdpObj order key by host

static int kcpConnCount = 12;
//kcpConnCount 是 hostKcpDict 的 Capacity

@implementation KcpOnUdpObj

+(KcpOnUdpObj *)getObjByKcp:(ikcpcb *)kcp{
    if (!hostKcpDict) {
        return nil;
    }
    KcpOnUdpObj * kcpOnUdpObj = nil;
    if (kcp) {
        for (KcpOnUdpObj * obj in [hostKcpDict allValues]) {
            if (obj.c_kcp == kcp) {
                //kcp 是C函数指针，
                //两个C函数指针可以通过 == 判断是否为同一个指针
                //从而确认kcpOnUdpObj
                kcpOnUdpObj = obj;
                break;
            }
        }
    }
    return kcpOnUdpObj;
}

+(KcpOnUdpObj *)getObjByHost:(NSString *)host{
    if (!hostKcpDict) {
        return nil;
    }
    KcpOnUdpObj * kcpOnUdpObj = nil;
    if (host) {
        kcpOnUdpObj = [hostKcpDict objectForKey:host];
    }
    return kcpOnUdpObj;
}

- (instancetype)initWithHost:(NSString *)host
{
    self = [super init];
    if (self) {
        if (!hostKcpDict) {
            hostKcpDict = [NSMutableDictionary dictionaryWithCapacity:kcpConnCount];
        }
        if ([hostKcpDict valueForKey:host]) {
            self = [hostKcpDict valueForKey:host];
        }else{
            [hostKcpDict setObject:self forKey:host];
        }
        self.c_host = host;
    }
    return self;
}

+(void)releaseObjWithHost:(NSString *)host{
    if(hostKcpDict){
        [hostKcpDict removeObjectForKey:host];
    }
}


@end


@implementation KcpObj

@end


@implementation ReciveData

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        [self fomateReciveData:data];
    }
    return self;
}

-(void)fomateReciveData:(NSData *)data{
    NSData * dataId = [[data subdataWithRange:NSMakeRange(0, 4)] copy];
    NSData * dataCount = [[data subdataWithRange:NSMakeRange(4, 4)] copy];
    NSData * dataIndex = [[data subdataWithRange:NSMakeRange(8, 4)] copy];

    self.count = [self dataToInt:dataCount];
    self.index = [self dataToInt:dataIndex];
    self.dataId = [[NSString alloc]initWithData:dataId encoding:NSUTF8StringEncoding];
    self.data = [data subdataWithRange:NSMakeRange(12, data.length-12)];
}


/**
 将定长的 buf数据 转换为 int

 @param data data 原始数据
 @return return value 转换结果 int类型
 */
-(int)dataToInt:(NSData *)data{
    int i;
    [data getBytes: &i length: sizeof(i)];
//    return htonl(i);
    return i;
}

@end

