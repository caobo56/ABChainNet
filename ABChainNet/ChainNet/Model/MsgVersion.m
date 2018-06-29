//
//  MsgVersion.m
//  textDemo
//
//  Created by caobo56 on 2018/3/15.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "MsgVersion.h"
#import "NSDate+Timestamp.h"

@interface MsgVersion()

@end

@implementation MsgVersion

+(VersionMessage *)creatVersionMessage{
    VersionMessage * versionMessage = [[VersionMessage alloc]init];
    versionMessage.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    versionMessage.minimum = 1;
    versionMessage.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
    versionMessage.replyId = @"";
    versionMessage.version = 1;
    versionMessage.services = 1;
    versionMessage.subVer = @"1";
    versionMessage.id_p = DeviceID;
    versionMessage.sessionId = versionMessage.messageId;
    return versionMessage;
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
    NSLog(@"MsgVersion From %@",self.host);
    [self msgAction];
}

-(void)msgAction{
    if (self.obj.resData) {
        FormaterDataObj * fmt = [[FormaterDataObj alloc]initFromData:self.obj.resData];
        VersionMessage * vmsg = (VersionMessage *)fmt.payload;
        super.responseId = vmsg.replyId;
        super.messageId = vmsg.messageId;
        super.payload = fmt.payload;

        vmsg.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
        vmsg.minimum = 1;
        vmsg.replyId = vmsg.messageId;
        vmsg.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
        vmsg.version = 1;
        vmsg.services = 1;
        vmsg.subVer = @"1";
        vmsg.id_p = [NSString stringWithFormat:@"Mobile%@",vmsg.messageId];

        FormaterDataObj * fmtReturn = [[FormaterDataObj alloc]initWithObj:vmsg];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(msgModel:didSendMsg:from:)]) {
            [super.delegate msgModel:self didSendMsg:fmtReturn.resData from:self.host];
        }
    }else{
        
    }
}

@end
