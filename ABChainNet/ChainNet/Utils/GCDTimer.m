//
//  GCDTimer.m
//  textDemo
//
//  Created by caobo56 on 2018/3/21.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer()

@property (nonatomic, strong) dispatch_block_t block;

@property (nonatomic, strong) dispatch_source_t source;

@end

@implementation GCDTimer

+(GCDTimer *)repeatingTimerWithTimeInterval:(NSTimeInterval)seconds block:(dispatch_block_t)block {
    GCDTimer *timer = [[self alloc] init];
    timer.block = block;
    timer.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue()); // 首先，创建一个定时器分派源并绑定到主分派队列上，这使得定时器总是在主线程上触发
    uint64_t nsec = (uint64_t)(seconds * NSEC_PER_SEC);
    dispatch_source_set_timer(timer.source, dispatch_time(DISPATCH_TIME_NOW, nsec), nsec, 0);//设置定时器
    dispatch_source_set_event_handler(timer.source, block);//设置事件处理程序
    dispatch_resume(timer.source);//打开定时器（分派源通常都是需要配置的，所以它们创建的时候处于暂停状态，只有resume之后才会开始发送事件）
    return timer;
}

-(void)invalidate {
    if (self.source) {
        dispatch_source_cancel(self.source);
        self.source = nil;
    }
    self.block = nil;
}

-(void)dealloc {
    [self invalidate];//销毁时将定时器设置为无效
}

@end

