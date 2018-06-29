//
//  NSDate+Timestamp.h
//  textDemo
//
//  Created by caobo56 on 2018/2/27.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Timestamp)

//将时间戳转换为NSDate类型
+(NSDate *)getDateTimeFromMilliSeconds:(long long) miliSeconds;

//将NSDate类型的时间转换为时间戳,从1970/1/1开始
+(long long)getDateTimeToMilliSeconds:(NSDate *)datetime;

//将NSDate类型的时间转换为时间戳Str,从1970/1/1开始
+(NSString *)getDateTimeToMilliSecondsStr:(NSDate *)datetime;
@end
