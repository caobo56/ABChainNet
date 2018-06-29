//
//  GCDTimer.h
//  textDemo
//
//  Created by caobo56 on 2018/3/21.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDTimer : NSObject

+(GCDTimer *)repeatingTimerWithTimeInterval:(NSTimeInterval)seconds block:(dispatch_block_t)block;

@end
