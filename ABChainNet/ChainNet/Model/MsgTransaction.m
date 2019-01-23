//
//  MsgTransaction.m
//  textDemo
//
//  Created by caobo56 on 2018/6/6.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "MsgTransaction.h"
#import "NSDate+Timestamp.h"

/**
 ID
 FILE
 TOKEN
 */

@interface MsgTransaction()

@end


@implementation MsgTransaction

+(Transaction *)creatTransactionMessageWithUserInfo:(NSDictionary *)useInfo andScriptBytes:(NSData *)scriptBytes{
    Transaction * trans = [[Transaction alloc]init];
    trans.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    trans.minimum = 1;
    trans.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
    trans.replyId = @"";
    trans.version = 1;
    trans.updatedAt = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    
    trans.inputsArray = [NSMutableArray arrayWithCapacity:12];
    
    Transaction_Inputs * type_input = [[Transaction_Inputs alloc]init];
    type_input.inputType = Transaction_Inputs_InputType_IssueType;
    type_input.sequence = trans.timestamp;
    type_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    type_input.issueInput.sourceType = @"_type";
    type_input.issueInput.data_p = [@"ID" dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:type_input];
    
    Transaction_Inputs * faceID_input = [[Transaction_Inputs alloc]init];
    faceID_input.inputType = Transaction_Inputs_InputType_IssueType;
    faceID_input.sequence = trans.timestamp;
    faceID_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    faceID_input.issueInput.sourceType = @"faceID";
    faceID_input.issueInput.data_p = [useInfo[@"faceID"] dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:faceID_input];
    
    Transaction_Inputs * userNick_input = [[Transaction_Inputs alloc]init];
    userNick_input.inputType = Transaction_Inputs_InputType_IssueType;
    userNick_input.sequence = trans.timestamp;
    userNick_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    userNick_input.issueInput.sourceType = @"userNick";
    userNick_input.issueInput.data_p = [useInfo[@"userNick"] dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:userNick_input];
    
    Transaction_Inputs * userAddress_input = [[Transaction_Inputs alloc]init];
    userAddress_input.inputType = Transaction_Inputs_InputType_IssueType;
    userAddress_input.sequence = trans.timestamp;
    userAddress_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    userAddress_input.issueInput.sourceType = @"userAddress";
    userAddress_input.issueInput.data_p = [useInfo[@"userAddress"] dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:userAddress_input];
    
    trans.outputsArray = [NSMutableArray arrayWithCapacity:12];
    
    Transaction_Outputs * output = [[Transaction_Outputs alloc]init];
    output.timestamp = trans.timestamp;
    output.minimum = trans.minimum;
    output.messageId = trans.messageId;
    output.replyId = trans.replyId;
    output.scriptBytes = scriptBytes;
    output.value = [@"{}" dataUsingEncoding:NSUTF8StringEncoding];
    [trans.outputsArray addObject:output];
    
    Transaction_UnlockScripts * unlockScript = [[Transaction_UnlockScripts alloc]init];
    unlockScript.scriptBytes = [[NSData alloc]init];
    unlockScript.sequence = trans.timestamp;
    trans.unlockScriptsArray = [NSMutableArray arrayWithCapacity:12];
    [trans.unlockScriptsArray addObject:unlockScript];
    
    return trans;
}

+(Transaction *)creatTransactionMessageWithUseInfo:(NSDictionary *)useInfo andScriptBytes:(NSData *)scriptBytes{
    Transaction * trans = [[Transaction alloc]init];
    trans.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    trans.minimum = 1;
    trans.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
    trans.replyId = @"";
    trans.version = 1;
    trans.updatedAt = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    
    trans.inputsArray = [NSMutableArray arrayWithCapacity:12];
    
    Transaction_Inputs * type_input = [[Transaction_Inputs alloc]init];
    type_input.inputType = Transaction_Inputs_InputType_IssueType;
    type_input.sequence = trans.timestamp;
    type_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    type_input.issueInput.sourceType = @"_type";
    type_input.issueInput.data_p = [@"ID" dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:type_input];
    
    Transaction_Inputs * faceID_input = [[Transaction_Inputs alloc]init];
    faceID_input.inputType = Transaction_Inputs_InputType_IssueType;
    faceID_input.sequence = trans.timestamp;
    faceID_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    faceID_input.issueInput.sourceType = @"faceID";
    faceID_input.issueInput.data_p = [useInfo[@"faceID"] dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:faceID_input];
    
    Transaction_Inputs * userNick_input = [[Transaction_Inputs alloc]init];
    userNick_input.inputType = Transaction_Inputs_InputType_IssueType;
    userNick_input.sequence = trans.timestamp;
    userNick_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    userNick_input.issueInput.sourceType = @"userNick";
    userNick_input.issueInput.data_p = [useInfo[@"userNick"] dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:userNick_input];
    
    trans.outputsArray = [NSMutableArray arrayWithCapacity:12];
    
    Transaction_Outputs * output = [[Transaction_Outputs alloc]init];
    output.timestamp = trans.timestamp;
    output.minimum = trans.minimum;
    output.messageId = trans.messageId;
    output.replyId = trans.replyId;
    output.scriptBytes = scriptBytes;
    output.value = [@"{}" dataUsingEncoding:NSUTF8StringEncoding];
    [trans.outputsArray addObject:output];
    
    Transaction_UnlockScripts * unlockScript = [[Transaction_UnlockScripts alloc]init];
    unlockScript.scriptBytes = [[NSData alloc]init];
    unlockScript.sequence = trans.timestamp;
    trans.unlockScriptsArray = [NSMutableArray arrayWithCapacity:12];
    [trans.unlockScriptsArray addObject:unlockScript];
    
    return trans;
}

+(Transaction *)creatTransactionMessageWith:(NSString *)faceID andScriptBytes:(NSData *)scriptBytes{
    Transaction * trans = [[Transaction alloc]init];
    trans.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    trans.minimum = 1;
    trans.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
    trans.replyId = @"";
    trans.version = 1;
    trans.updatedAt = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    
    trans.inputsArray = [NSMutableArray arrayWithCapacity:12];
    
    Transaction_Inputs * type_input = [[Transaction_Inputs alloc]init];
    type_input.inputType = Transaction_Inputs_InputType_IssueType;
    type_input.sequence = trans.timestamp;
    type_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    type_input.issueInput.sourceType = @"_type";
    type_input.issueInput.data_p = [@"ID" dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:type_input];
    
    Transaction_Inputs * input = [[Transaction_Inputs alloc]init];
    input.inputType = Transaction_Inputs_InputType_IssueType;
    input.sequence = trans.timestamp;
    input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    input.issueInput.sourceType = @"faceID";
    input.issueInput.data_p = [faceID dataUsingEncoding:NSUTF8StringEncoding];
    
    [trans.inputsArray addObject:input];
    
    trans.outputsArray = [NSMutableArray arrayWithCapacity:12];
    
    Transaction_Outputs * output = [[Transaction_Outputs alloc]init];
    output.timestamp = trans.timestamp;
    output.minimum = trans.minimum;
    output.messageId = trans.messageId;
    output.replyId = trans.replyId;
    output.scriptBytes = scriptBytes;
    output.value = [@"{}" dataUsingEncoding:NSUTF8StringEncoding];
    [trans.outputsArray addObject:output];
    
    Transaction_UnlockScripts * unlockScript = [[Transaction_UnlockScripts alloc]init];
    unlockScript.scriptBytes = [[NSData alloc]init];
    unlockScript.sequence = trans.timestamp;
    trans.unlockScriptsArray = [NSMutableArray arrayWithCapacity:12];
    [trans.unlockScriptsArray addObject:unlockScript];
    
    return trans;
}

+(Transaction *)creatTransactionMessageWithFileInfo:(NSDictionary *)fileInfo andScriptBytes:(NSData *)scriptBytes{
    
    Transaction * trans = [[Transaction alloc]init];
    trans.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    trans.minimum = 1;
    trans.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
    trans.replyId = @"";
    trans.version = 1;
    trans.updatedAt = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    
    trans.inputsArray = [NSMutableArray arrayWithCapacity:12];
    
    Transaction_Inputs * type_input = [[Transaction_Inputs alloc]init];
    type_input.inputType = Transaction_Inputs_InputType_IssueType;
    type_input.sequence = trans.timestamp;
    type_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    type_input.issueInput.sourceType = @"_type";
    type_input.issueInput.data_p = [@"FILE" dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:type_input];
    
    Transaction_Inputs * name_input = [[Transaction_Inputs alloc]init];
    name_input.inputType = Transaction_Inputs_InputType_IssueType;
    name_input.sequence = trans.timestamp;
    name_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    name_input.issueInput.sourceType = @"name";
    name_input.issueInput.data_p = [fileInfo[@"name"] dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:name_input];
    
    Transaction_Inputs * md5_input = [[Transaction_Inputs alloc]init];
    md5_input.inputType = Transaction_Inputs_InputType_IssueType;
    md5_input.sequence = trans.timestamp;
    md5_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    md5_input.issueInput.sourceType = @"md5";
    md5_input.issueInput.data_p = [fileInfo[@"md5"] dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:md5_input];
    
    Transaction_Inputs * path_input = [[Transaction_Inputs alloc]init];
    path_input.inputType = Transaction_Inputs_InputType_IssueType;
    path_input.sequence = trans.timestamp;
    path_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    path_input.issueInput.sourceType = @"path";
    path_input.issueInput.data_p = [fileInfo[@"path"] dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:path_input];
    
    Transaction_Inputs * uploadTime_input = [[Transaction_Inputs alloc]init];
    uploadTime_input.inputType = Transaction_Inputs_InputType_IssueType;
    uploadTime_input.sequence = trans.timestamp;
    uploadTime_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    uploadTime_input.issueInput.sourceType = @"uploadTime";
    uploadTime_input.issueInput.data_p = [fileInfo[@"uploadTime"] dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:uploadTime_input];
    
    Transaction_Inputs * ownerAddress_input = [[Transaction_Inputs alloc]init];
    ownerAddress_input.inputType = Transaction_Inputs_InputType_IssueType;
    ownerAddress_input.sequence = trans.timestamp;
    ownerAddress_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    ownerAddress_input.issueInput.sourceType = @"ownerAddress";
    ownerAddress_input.issueInput.data_p = [fileInfo[@"ownerAddress"] dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:ownerAddress_input];
    
    Transaction_Inputs * torrent_input = [[Transaction_Inputs alloc]init];
    torrent_input.inputType = Transaction_Inputs_InputType_IssueType;
    torrent_input.sequence = trans.timestamp;
    torrent_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    torrent_input.issueInput.sourceType = @"torrent";
    torrent_input.issueInput.data_p = [fileInfo[@"torrent"] dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:torrent_input];
    
    Transaction_Inputs * size_input = [[Transaction_Inputs alloc]init];
    size_input.inputType = Transaction_Inputs_InputType_IssueType;
    size_input.sequence = trans.timestamp;
    size_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    size_input.issueInput.sourceType = @"size";
    size_input.issueInput.data_p = [fileInfo[@"size"] dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:size_input];
    
    Transaction_Inputs * fileType_input = [[Transaction_Inputs alloc]init];
    fileType_input.inputType = Transaction_Inputs_InputType_IssueType;
    fileType_input.sequence = trans.timestamp;
    fileType_input.issueInput = [[Transaction_Inputs_IssueInput alloc]init];
    fileType_input.issueInput.sourceType = @"fileType";
    fileType_input.issueInput.data_p = [fileInfo[@"fileType"] dataUsingEncoding:NSUTF8StringEncoding];
    [trans.inputsArray addObject:fileType_input];
        
    trans.outputsArray = [NSMutableArray arrayWithCapacity:12];
    
    Transaction_Outputs * output = [[Transaction_Outputs alloc]init];
    output.timestamp = trans.timestamp;
    output.minimum = trans.minimum;
    output.messageId = trans.messageId;
    output.replyId = trans.replyId;
    output.scriptBytes = scriptBytes;
    output.value = [@"{}" dataUsingEncoding:NSUTF8StringEncoding];
    [trans.outputsArray addObject:output];
    
    Transaction_UnlockScripts * unlockScript = [[Transaction_UnlockScripts alloc]init];
    unlockScript.scriptBytes = [[NSData alloc]init];
    unlockScript.sequence = trans.timestamp;
    trans.unlockScriptsArray = [NSMutableArray arrayWithCapacity:12];
    [trans.unlockScriptsArray addObject:unlockScript];
    
    return trans;

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
    NSLog(@"MsgTransaction From %@",self.host);
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
}


@end
