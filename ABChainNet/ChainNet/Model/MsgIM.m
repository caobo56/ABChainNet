//
//  MsgIM.m
//  ABChainNet
//
//  Created by caobo56 on 2018/10/29.
//  Copyright © 2018 caobo56. All rights reserved.
//

#import "MsgIM.h"
#import "NSDate+Timestamp.h"

#define DoneJson @"{\"recivedType\":\"Done\"}"

@implementation MsgIM

+(IMMessage *)creatIMMessage:(NSString *)msg_json{
    IMMessage * im = [[IMMessage alloc]init];
    im.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    im.minimum = 1;
    im.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
    im.replyId = @"";
    im.version = 1;
    im.services = 1;
    im.subVer = @"1";
    im.id_p = DeviceID;
    im.imjson = msg_json;
    return im;
}

+(IMMessage *)creatFindIMMessage:(NSString *)userAddress{
    IMMessage * im = [[IMMessage alloc]init];
    im.timestamp = (int64_t)[NSDate getDateTimeToMilliSeconds:[NSDate new]];
    im.minimum = 1;
    im.messageId = [NSDate getDateTimeToMilliSecondsStr:[NSDate new]];
    im.replyId = @"";
    im.version = 1;
    im.services = 1;
    im.subVer = @"1";
    im.id_p = DeviceID;
    NSDictionary * json_dict = @{@"userAddress":userAddress,@"FindUserType":@"FindUserAddress"};
    im.imjson = [self convertToJsonData:json_dict];
    return im;
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
    NSLog(@"MsgIM From %@",self.host);
    [self msgAction];
}

-(void)msgAction{
    if (self.obj.resData) {
        FormaterDataObj * fmt = [[FormaterDataObj alloc]initFromData:self.obj.resData];
        IMMessage * vmsg = (IMMessage *)fmt.payload;
        super.responseId = vmsg.replyId;
        super.messageId = vmsg.messageId;
        super.payload = fmt.payload;
    }else{
        
    }
}



+(NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
