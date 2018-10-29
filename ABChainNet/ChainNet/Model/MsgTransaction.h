//
//  MsgTransaction.h
//  textDemo
//
//  Created by caobo56 on 2018/6/6.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "BasicMsgModel.h"
#import "Pbmessage.pbobjc.h"

@interface MsgTransaction : BasicMsgModel

+(Transaction *)creatTransactionMessageWith:(NSString *)faceID andScriptBytes:(NSData *)scriptBytes;

+(Transaction *)creatTransactionMessageWithUseInfo:(NSDictionary *)useInfo andScriptBytes:(NSData *)scriptBytes;

@end
