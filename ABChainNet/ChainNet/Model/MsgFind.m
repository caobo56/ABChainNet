//
//  MsgFind.m
//  textDemo
//
//  Created by caobo56 on 2018/6/5.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "MsgFind.h"

#import "MsgTransaction.h"

#import "NSDate+Timestamp.h"
#import "NSData+UTF8.h"
#import <NSBencodeSerialization.h>

@interface MsgFind()

@end

@implementation MsgFind

+(FindMessage *)creatFindMessageWithFaceID:(NSString *)faceID
                                   andPeer:(DiscoverReplyMessage_PeerAddress *)peer{
    FindMessage * find = [[FindMessage alloc]init];
    find.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    find.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
    find.replyId = @"";
    
    FindMessage_ReqAddress * reqAddress = [[FindMessage_ReqAddress alloc]init];
    NSUserDefaults * us = [NSUserDefaults standardUserDefaults];
    reqAddress.ip = [us valueForKey:@"divice_host"];
    reqAddress.port = [[us valueForKey:@"divice_port"] intValue];
    find.reqAddress = reqAddress;
    
    find.reqId = [us valueForKey:@"divice_ID"];
    
    FindMessage_AimAddress * aimAddress = [[FindMessage_AimAddress alloc]init];
    aimAddress.ip = peer.ip;
    aimAddress.port = peer.port;
    find.aimAddress = aimAddress;
    
    find.resourceType = GetFINDTYPE(FIND_TRANS);
    
    NSDictionary * dict = @{
                            @"faceID":faceID,
                            @"_type":@"ID"
                            };
    
    NSError * error;
    find.condition = [NSBencodeSerialization dataWithBencodedObject:dict error:&error];
    if (error) {
        return nil;
    }
    return find;
}



+(FindMessage *)creatFindMessageWithUserAddress:(NSString *)userAddress
                                   andPeer:(DiscoverReplyMessage_PeerAddress *)peer{
    FindMessage * find = [[FindMessage alloc]init];
    find.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    find.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
    find.replyId = @"";
    
    FindMessage_ReqAddress * reqAddress = [[FindMessage_ReqAddress alloc]init];
    NSUserDefaults * us = [NSUserDefaults standardUserDefaults];
    reqAddress.ip = [us valueForKey:@"divice_host"];
    reqAddress.port = [[us valueForKey:@"divice_port"] intValue];
    find.reqAddress = reqAddress;
    
    find.reqId = [us valueForKey:@"divice_ID"];
    
    FindMessage_AimAddress * aimAddress = [[FindMessage_AimAddress alloc]init];
    aimAddress.ip = peer.ip;
    aimAddress.port = peer.port;
    find.aimAddress = aimAddress;
    
    find.resourceType = GetFINDTYPE(FIND_TRANS);
    
    NSDictionary * dict = @{
                            @"userAddress":userAddress,
                            @"_type":@"ID"
                            };
    
    NSError * error;
    find.condition = [NSBencodeSerialization dataWithBencodedObject:dict error:&error];
    if (error) {
        return nil;
    }
    return find;
}


+(FindMessage *)creatFindFileWithUserAddress:(NSString *)userAddress
                                     andPeer:(DiscoverReplyMessage_PeerAddress *)peer{
    FindMessage * find = [[FindMessage alloc]init];
    find.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    find.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
    find.replyId = @"";
    
    FindMessage_ReqAddress * reqAddress = [[FindMessage_ReqAddress alloc]init];
    NSUserDefaults * us = [NSUserDefaults standardUserDefaults];
    reqAddress.ip = [us valueForKey:@"divice_host"];
    reqAddress.port = [[us valueForKey:@"divice_port"] intValue];
    find.reqAddress = reqAddress;
    
    find.reqId = [us valueForKey:@"divice_ID"];
    
    FindMessage_AimAddress * aimAddress = [[FindMessage_AimAddress alloc]init];
    aimAddress.ip = peer.ip;
    aimAddress.port = peer.port;
    find.aimAddress = aimAddress;
    
    find.resourceType = GetFINDTYPE(FIND_TRANS);
    
    NSDictionary * dict = @{
                            @"ownerAddress":userAddress,
                            @"_type":@"FILE"
                            };
    
    NSError * error;
    find.condition = [NSBencodeSerialization dataWithBencodedObject:dict error:&error];
    if (error) {
        return nil;
    }
    return find;
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
    NSLog(@"MsgFind From %@",self.host);
    [self msgAction];
}

-(void)msgAction{
    if (self.obj.resData) {
        FormaterDataObj * fmt = [[FormaterDataObj alloc]initFromData:self.obj.resData];
        FindMessage * vmsg = (FindMessage *)fmt.payload;
        super.responseId = vmsg.replyId;
        super.messageId = vmsg.messageId;
        super.payload = fmt.payload;
    }
    NSLog(@"payload == %@",self.payload);
    FindAckMessage * findack = (FindAckMessage *)super.payload;
    
    FormaterDataObj * fmtReturn = [[FormaterDataObj alloc]initWithObj:findack];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(msgModel:didSendMsg:from:)]) {
        [super.delegate msgModel:self didSendMsg:fmtReturn.resData from:self.host];
    }
    
}

NSString *GetFINDTYPE(FINDTYPE status) {
    switch (status) {
        case FIND_NOTHING:
            return @"默认";
        case FIND_TRANS:
            return @"TRANS";
        case FIND_BLOCKBODY:
            return @"BLOCKBODY";
        case FIND_DOWN_TRAN:
            return @"DOWN_TRAN";
        case FIND_TORRENT:
            return @"TORRENT";
        default:
            return @"";
    }
}
@end

@implementation MsgFindAck

- (instancetype)initWith:(FormaterDataObj *)obj andDelegate:(id)delegate
{
    self = [super initWith:obj andDelegate:delegate];
    if (self) {
    }
    return self;
}

-(void)setHost:(NSString *)host{
    super.host = host;
    NSLog(@"MsgFindAck From %@",self.host);
    [self msgAction];
}

-(void)msgAction{
    if (self.obj.resData) {
        FormaterDataObj * fmt = [[FormaterDataObj alloc]initFromData:self.obj.resData];
        DiscoverReplyMessage * msg = (DiscoverReplyMessage *)fmt.payload;
        super.responseId = msg.replyId;
        super.messageId = msg.messageId;
        super.payload = fmt.payload;
        
//#warning objectFromEncodedData
//        FindAckMessage * findack = (FindAckMessage *)super.payload;
//
//        NSArray * arr = [NSBencodeSerialization objectFromEncodedData:findack.result.data_p];
//
//        NSLog(@"arr = %@",arr);
//        
//        for (NSData * dat in arr) {
//            FormaterDataObj * obj = [[FormaterDataObj alloc]initFromData:dat];
//
//            NSLog(@"tran = %@",obj.payload);
//        }
    }
}
@end


















