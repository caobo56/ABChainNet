//
//  MsgDiscover.h
//  textDemo
//
//  Created by caobo56 on 2018/3/15.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicMsgModel.h"

@interface MsgDiscover : BasicMsgModel

+(DiscoverMessage *)creatDiscoverMessage;

@end

@interface MsgDiscReply : BasicMsgModel

@end
