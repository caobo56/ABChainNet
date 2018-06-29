//
//  KcpDataQueue.m
//  textDemo
//
//  Created by caobo56 on 2018/3/7.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "KUKcpDataQueue.h"
#import "NetEncrypt.h"
#import "KcpOnUdpObj.h"
#import "NSData+UTF8.h"


@interface KUKcpDataQueue()

@property(strong,nonatomic)NSMutableArray <KcpObj *>* sendDataQueue;
//KcpOnUdp 待发送包队列上限 2k

@property(strong,nonatomic)NSMutableArray <ReciveData *>* reciveDataQueue;

@end

@implementation KUKcpDataQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sendDataQueue = [NSMutableArray arrayWithCapacity:UdpQueueSize/10];
        _reciveDataQueue = [NSMutableArray arrayWithCapacity:UdpQueueSize/10];
    }
    return self;
}

-(NSInteger)count{
    return _sendDataQueue.count;
}

-(void)addKcpObj:(NSData *)obj{
    //转换为 const char * buf
//    const char * buf = [[obj copy] bytes];
//    NSLog(@"%lu",strlen(buf));
    NSArray * arr = [self kcpDataUnpackWith:obj];
    [_sendDataQueue addObjectsFromArray:arr];
}

-(KcpObj *)queueFirstObj{
    KcpObj * kcpObj;
    if (_sendDataQueue.count > 0) {
        kcpObj = _sendDataQueue.firstObject;
    }else{
        kcpObj = nil;
    }
    return kcpObj;
}

-(void)removeKcpObj:(KcpObj *)obj{
    [_sendDataQueue removeObject:obj];
}

#pragma mark -合包
-(void)reciveKcpData:(NSData *)data{
    ReciveData * reciveData = [[ReciveData alloc]initWithData:data];
    NSMutableArray <ReciveData *>* tempArr = [NSMutableArray arrayWithCapacity:reciveData.count];
    for (ReciveData * redata in _reciveDataQueue) {
        if ([redata.dataId isEqualToString:reciveData.dataId]) {
            if (redata.index != reciveData.index) {
                [tempArr addObject:redata];
            }
        }
    }
    [tempArr addObject:reciveData];
    
    if (tempArr.count < reciveData.count) {
        [_reciveDataQueue addObject:reciveData];
    }else if(tempArr.count == reciveData.count){
        NSSortDescriptor *sortDescripttor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
        NSArray *sortArr = [tempArr sortedArrayUsingDescriptors:@[sortDescripttor]];
        NSMutableData * reData = [NSMutableData dataWithCapacity:sortArr.count];
        for (int i = 0; i <sortArr.count; i++) {
            ReciveData * reDa = (ReciveData *)sortArr[i];
            [reData appendData:reDa.data];
            [_reciveDataQueue removeObject:reDa];
        }
        if (_delegate) {
            [_delegate kcpDataQueue:self DidReciveData:(NSData *)reData];
        }
    }
}


#pragma mark -拆包
-(NSArray *)kcpDataUnpackWith:(NSData *)data{
    NSMutableArray <NSData *>*array = [NSMutableArray arrayWithCapacity:100];
    while (data.length >= KDataSize) {
        NSData * subData = [data subdataWithRange:NSMakeRange(0, KDataSize)];
        [array addObject:subData];
        NSData * tempData = [data subdataWithRange:NSMakeRange(KDataSize, data.length-KDataSize)];
        data = [tempData copy];
    }
    if (data.length > 0) {
        NSData * subData = [data subdataWithRange:NSMakeRange(0, data.length)];
        [array addObject:subData];
    }
    
    NSMutableArray <KcpObj *>* kcpArray = [NSMutableArray arrayWithCapacity:100];
    NSData * dataId = [NetEncrypt sha1DataWithData:data];
    
    for (int i = 0; i< array.count; i++) {
        NSMutableData * mData = [NSMutableData dataWithCapacity:KcpDataSize];
        [mData appendData:[dataId subdataWithRange:NSMakeRange(0, 4)]];
        
        int count = (int)array.count;
        [mData appendData:[NSData int2Nsdata:count]];

        int index = i+1;
        [mData appendData:[NSData int2Nsdata:index]];

        [mData appendData:array[i]];
        KcpObj * obj = [[KcpObj alloc]init];
        obj.data = (NSData *)mData;
        [kcpArray addObject:obj];
    }

    return kcpArray;
}




@end
