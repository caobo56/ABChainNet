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

/**
 //用户昵称，用户FaceID 的用户注册

 @param useInfo useInfo description
 @param scriptBytes scriptBytes description
 @return return value description
 */
+(Transaction *)creatTransactionMessageWithUseInfo:(NSDictionary *)useInfo andScriptBytes:(NSData *)scriptBytes;


/**
 //用户昵称，用户FaceID，用户addressID的用户注册

 @param useInfo useInfo description
 @param scriptBytes scriptBytes description
 @return return value description
 */
+(Transaction *)creatTransactionMessageWithUserInfo:(NSDictionary *)useInfo andScriptBytes:(NSData *)scriptBytes;

@end
