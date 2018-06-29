//
//  NetEncrypt.h
//  textDemo
//
//  Created by caobo56 on 2018/6/29.
//  Copyright © 2018年 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetEncrypt : NSObject

+ (NSData*)sha1DataWithData:(NSData *)data;

+ (NSData *)sha256DataTwiceKey:(NSData *)data;


@end
