//
//  MsgVersion.h
//  textDemo
//
//  Created by caobo56 on 2018/3/15.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicMsgModel.h"

@interface MsgVersion : BasicMsgModel

+(VersionMessage *)creatVersionMessageWithOpCode:(NSString *)opCode;

@end
