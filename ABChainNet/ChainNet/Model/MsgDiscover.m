//
//  MsgDiscover.m
//  textDemo
//
//  Created by caobo56 on 2018/3/15.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "MsgDiscover.h"
#import "NSDate+Timestamp.h"

@implementation MsgDiscover

+(DiscoverMessage *)creatDiscoverMessage{
    DiscoverMessage * disMsg = [[DiscoverMessage alloc]init];
    disMsg.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    disMsg.minimum = 1;
    disMsg.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
    disMsg.replyId = @"";
    return disMsg;
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
    NSLog(@"MsgDiscover From %@",self.host);
    [self msgAction];
}

-(void)msgAction{
    if (self.obj.resData) {
        FormaterDataObj * fmt = [[FormaterDataObj alloc]initFromData:self.obj.resData];
        DiscoverMessage * msg = (DiscoverMessage *)fmt.payload;
        super.responseId = msg.replyId;
        super.messageId = msg.messageId;
        super.payload = fmt.payload;
    }
}

@end

@implementation MsgDiscReply

- (instancetype)initWith:(FormaterDataObj *)obj andDelegate:(id)delegate
{
    self = [super initWith:obj andDelegate:delegate];
    if (self) {
    }
    return self;
}

-(void)setHost:(NSString *)host{
    super.host = host;
    NSLog(@"MsgDiscReply From %@",self.host);
    [self msgAction];
}

-(void)msgAction{
    if (self.obj.resData) {
        FormaterDataObj * fmt = [[FormaterDataObj alloc]initFromData:self.obj.resData];
        DiscoverReplyMessage * msg = (DiscoverReplyMessage *)fmt.payload;
        super.responseId = msg.replyId;
        super.messageId = msg.messageId;
        super.payload = fmt.payload;
    }
}

@end
