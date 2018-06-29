//
//  MsgFind.h
//  textDemo
//
//  Created by caobo56 on 2018/6/5.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicMsgModel.h"

/**
 交易类型枚举

 - FIND_: 交易类型枚举
 */
typedef NS_ENUM(NSInteger, FINDTYPE) {
    FIND_NOTHING = 1,  //默认
    FIND_TRANS,        //查找交易
    FIND_BLOCKBODY,    //查找区块
    FIND_DOWN_TRAN,    //做文件下载
    FIND_TORRENT       //查找种子
};

@interface MsgFind : BasicMsgModel

+(FindMessage *)creatFindMessageWithFaceID:(NSString *)faceID
                                   andPeer:(DiscoverReplyMessage_PeerAddress *)peer;

@end


@interface MsgFindAck : BasicMsgModel

@end
