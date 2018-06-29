//
//  BasicMsgModel.h
//  textDemo
//
//  Created by caobo56 on 2018/3/15.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormaterDataObj.h"

@class BasicMsgModel;

@protocol BasicMsgModelDelegate <NSObject>

-(void)msgModel:(BasicMsgModel *)msgModel didSendMsg:(NSData *)data from:(NSString *)host;

@end

@interface BasicMsgModel : NSObject

+(instancetype)creatWith:(FormaterDataObj *)obj andHost:(NSString *)host andDelegate:(id)delegate;

- (instancetype)initWith:(FormaterDataObj *)obj andDelegate:(id)delegate;

@property(weak,nonatomic)id<BasicMsgModelDelegate> delegate;

@property(strong,nonatomic)NSString * host;

@property(strong,nonatomic)GPBMessage * payload;

@property(strong,nonatomic)NSString * responseId;
@property(strong,nonatomic)NSString * messageId;

@property(strong,nonatomic)FormaterDataObj * obj;

@end
