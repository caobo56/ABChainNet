//
//  MsgIM.h
//  ABChainNet
//
//  Created by caobo56 on 2018/10/29.
//  Copyright © 2018 caobo56. All rights reserved.
//

#import "BasicMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MsgIM : BasicMsgModel

+(IMMessage *)creatIMMessage:(NSString *)msg_json;

+(IMMessage *)creatFindIMMessage:(NSString *)userAddress;


+(NSString *)convertToJsonData:(NSDictionary *)dict;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
