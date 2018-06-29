//
//  BCNetWorkingHandle.m
//  textDemo
//
//  Created by caobo56 on 2018/3/21.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "BCNetWorkingHandle.h"

@implementation BCNetWorkingHandle

- (instancetype)initWithTimeout:(float)timeout
{
    self = [super init];
    if (self) {
        _type = HandleTypeNO;
        if (timeout > 0) {
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:timeout];
        }
    }
    return self;
}

-(void)delayMethod{
    if (self.timeoutComp && self.type == HandleTypeNO) {
        self.timeoutComp(self.msgID);
    }
}

- (void)dealloc
{
    _comp = nil;
    _timeoutComp = nil;
}

@end
