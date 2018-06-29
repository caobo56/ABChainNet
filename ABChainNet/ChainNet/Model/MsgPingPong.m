//
//  MsgPingPong.m
//  textDemo
//
//  Created by caobo56 on 2018/3/15.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "MsgPingPong.h"
#import "NSDate+Timestamp.h"

@interface MsgPing()


@end

@implementation MsgPing

+(PingMessage *)creatPingMessage{
    PingMessage * pmsg = [[PingMessage alloc]init];
    pmsg.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    pmsg.minimum = 1;
    pmsg.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
    pmsg.nonce = pmsg.timestamp;
    return pmsg;
}

- (instancetype)initWith:(FormaterDataObj *)obj andDelegate:(id)delegate
{
    self = [super initWith:obj andDelegate:delegate];
    if (self) {        
    }
    return self;
}

-(void)setHost:(NSString *)host{
    super.host = host;
//    NSLog(@"MsgPing From %@",self.host);
    [self msgAction];
}

-(void)msgAction{
    if (self.obj.resData) {
        FormaterDataObj * fmt = [[FormaterDataObj alloc]initFromData:self.obj.resData];
        PingMessage * pmsg = (PingMessage *)fmt.payload;
        super.responseId = pmsg.replyId;
        super.messageId = pmsg.messageId;
        super.payload = fmt.payload;
        
        NSUserDefaults * us = [NSUserDefaults standardUserDefaults];
        BOOL networkstate = [us boolForKey:Networkstate];
        //networkStatue 网络状态连通性，如果是NO，就不可以回复pong
        if (networkstate) {
            PongMessage * pomsg = [[PongMessage alloc]init];
            pomsg.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
            pomsg.minimum = 1;
            pomsg.replyId = pmsg.messageId;
            pomsg.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
            pomsg.nonce = pomsg.timestamp;
            FormaterDataObj * fmtReturn = [[FormaterDataObj alloc]initWithObj:pomsg];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(msgModel:didSendMsg:from:)]) {
                [super.delegate msgModel:self didSendMsg:fmtReturn.resData from:self.host];
            }
        }else{
            NSLog(@"un reply MsgPing From %@",self.host);
        }
    }
}
@end

@interface MsgPong()

@end

@implementation MsgPong

- (instancetype)initWith:(FormaterDataObj *)obj andDelegate:(id)delegate
{
    self = [super initWith:obj andDelegate:delegate];
    if (self) {
    }
    return self;
}

-(void)setHost:(NSString *)host{
    super.host = host;
//    NSLog(@"MsgPong From %@",self.host);
    [self msgAction];
}

-(void)msgAction{
    if (super.obj.resData) {
        FormaterDataObj * fmt = [[FormaterDataObj alloc]initFromData:self.obj.resData];
        PongMessage * pomsg = (PongMessage *)fmt.payload;
        super.responseId = pomsg.replyId;
        super.messageId = pomsg.messageId;
        super.payload = fmt.payload;
        
        PingMessage * pimsg = [[PingMessage alloc]init];
        pimsg.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
        pimsg.minimum = 1;
        pimsg.replyId = pomsg.messageId;
        pimsg.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
        pimsg.nonce = pomsg.timestamp;
        FormaterDataObj * fmtReturn = [[FormaterDataObj alloc]initWithObj:pomsg];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(msgModel:didSendMsg:from:)]) {
            [super.delegate msgModel:self didSendMsg:fmtReturn.resData from:self.host];
        }
    }
}


@end
