//
//  MsgTransaction.m
//  textDemo
//
//  Created by caobo56 on 2018/6/6.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "MsgTransaction.h"
#import "NSDate+Timestamp.h"

@interface MsgTransaction()

@end


@implementation MsgTransaction

+(Transaction *)creatTransactionMessageWithUseInfo:(NSDictionary *)useInfo andScriptBytes:(NSData *)scriptBytes{
    Transaction * trans = [[Transaction alloc]init];
    trans.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    trans.minimum = 1;
    trans.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
    trans.replyId = @"";
    trans.version = 1;
    trans.updatedAt = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    
    trans.inputsArray = [NSMutableArray arrayWithCapacity:12];
    
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
