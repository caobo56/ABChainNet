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

/**
 //用户昵称，用户FaceID，用户addressID的用户注册

 @param useInfo useInfo description
 @param scriptBytes scriptBytes description
 @return return value description
 */
+(Transaction *)creatTransactionMessageWithUserInfo:(NSDictionary *)useInfo andScriptBytes:(NSData *)scriptBytes;


/**
 文件交易

 @param fileInfo fileInfo description
 @param scriptBytes scriptBytes description
 @return return value description
 */
+(Transaction *)creatTransactionMessageWithFileInfo:(NSDictionary *)fileInfo andScriptBytes:(NSData *)scriptBytes;


@end
