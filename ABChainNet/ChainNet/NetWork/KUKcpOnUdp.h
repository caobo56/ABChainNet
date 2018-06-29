//
//  KcpOnUdp.h
//  textDemo
//
//  Created by caobo56 on 2018/2/23.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KcpOnUdpObj.h"
#import "KUNetWorkHeader.h"

@class KUKcpOnUdp;

@protocol KcpOnUdpDelegate <NSObject>

//didReciveMsg
-(void)kcpOnUdp:(KcpOnUdpObj *)kcpPoint didReciveMsg:(NSData *)data;

//didSendWithMsg
-(void)kcpOnUdp:(KcpOnUdpObj *)kcpPoint didSendWithMsg:(NSData *)data toHost:(NSString *)host port:(int)port tag:(int)tag;

//didSendOverflowMsg
-(void)kcpOnUdp:(KcpOnUdpObj *)kcpPoint didSendOverflowMsg:(NSData *)data toHost:(NSString *)host port:(int)port tag:(int)tag;

@end

@interface KUKcpOnUdp : NSObject

+(KUKcpOnUdp *)creatKcpOnUdpWithHost:(NSString *)host andPort:(int)port;

@property(weak,nonatomic) id<KcpOnUdpDelegate> delegate;
@property(assign,nonatomic)int tag;

-(void)reciveMsg:(NSData *)data fromHost:(NSString *)ip fromPort:(int)port;

-(void)sendMsg:(NSData *)data toHost:(NSString *)ip toPort:(int)port;

@end



