//
//  BasicMsgModel.m
//  textDemo
//
//  Created by caobo56 on 2018/3/15.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "BasicMsgModel.h"

@implementation BasicMsgModel

+(instancetype)creatWith:(FormaterDataObj *)obj andHost:(NSString *)host andDelegate:(id)delegate{
    NSString * className = [BasicMsgModel classNameFrom:obj.command];
    Class Class = NSClassFromString(className);
    BasicMsgModel *msgModel = [[Class alloc]initWith:obj andDelegate:delegate];
    msgModel.host = host;
    return msgModel;
}

- (instancetype)initWith:(FormaterDataObj *)obj andDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _obj = obj;
    }
    return self;
}

+(NSString *)classNameFrom:(NSString *)command{
    command = [command stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    NSDictionary * dict = @{
                            @"version":@"MsgVersion",
                            @"ping":@"MsgPing",
                            @"pong":@"MsgPong",
                            @"discover":@"MsgDiscover",
                            @"discReply":@"MsgDiscReply",
                            @"find":@"MsgFind",
                            @"findack":@"MsgFindAck",
                            @"imMsg":@"MsgIM"
                            };
    NSString * className = [[dict objectForKey:command] copy];
    return className;
}



@end
