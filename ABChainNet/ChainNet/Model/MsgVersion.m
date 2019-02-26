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

+(VersionMessage *)creatVersionMessageWithOpCode:(NSString *)opCode{
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
    versionMessage.opcode = opCode;
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
        VersionMessage * recive_vmsg = (VersionMessage *)fmt.payload;
        super.responseId = recive_vmsg.replyId;
        super.messageId = recive_vmsg.messageId;
        super.payload = fmt.payload;

        VersionMessage * vmsg = [[VersionMessage alloc]init];
        vmsg.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
        vmsg.minimum = 1;
        vmsg.replyId = vmsg.messageId;
        vmsg.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
        vmsg.version = 1;
        vmsg.services = 1;
        vmsg.subVer = @"1";
        vmsg.id_p = DeviceID;
        if ([recive_vmsg.opcode isEqualToString:@"VER-1"]) {
            vmsg.opcode = @"VER-2";
            FormaterDataObj * fmtReturn = [[FormaterDataObj alloc]initWithObj:vmsg];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(msgModel:didSendMsg:from:)]) {
                [super.delegate msgModel:self didSendMsg:fmtReturn.resData from:self.host];
            }
        }

        
    }else{
        
    }
}

@end
