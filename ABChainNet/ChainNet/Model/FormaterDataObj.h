//
//  FormaterDataObj.h
//  textDemo
//
//  Created by caobo56 on 2018/3/13.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pbmessage.pbobjc.h"
#import "KUNetWorkHeader.h"

/**
 FormaterDataObj 业务层数据分类型，并序列化，
 向KCP发送数据的上层数据
 */
@interface FormaterDataObj : NSObject

@property(strong,nonatomic)NSData * magic;
@property(strong,nonatomic)NSString * command;
@property(assign,nonatomic)int size;
@property(strong,nonatomic)NSData * checksum;
@property(strong,nonatomic)GPBMessage * payload;

@property(strong,nonatomic)NSData * resData;

- (instancetype)initWithObj:(GPBMessage *)msgObj;
- (instancetype)initFromData:(NSData *)data;

@end
