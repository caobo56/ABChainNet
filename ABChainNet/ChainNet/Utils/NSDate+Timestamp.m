//
//  NSDate+Timestamp.m
//  textDemo
//
//  Created by caobo56 on 2018/2/27.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "NSDate+Timestamp.h"

@implementation NSDate(Timestamp)

//将时间戳转换为NSDate类型

+(NSDate *)getDateTimeFromMilliSeconds:(long long) miliSeconds
{
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;//这里的.0一定要加上，不然除下来的数据会被截断导致时间不一致
//    NSLog(@"传入的时间戳=%f",seconds);
    return [NSDate dateWithTimeIntervalSince1970:seconds];
}

//将NSDate类型的时间转换为时间戳,从1970/1/1开始
+(long long)getDateTimeToMilliSeconds:(NSDate *)datetime
{
    NSTimeInterval interval = [datetime timeIntervalSince1970];
//    NSLog(@"转换的时间戳=%f",interval);
    long long totalMilliseconds = interval*1000 ;
//    NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
    return totalMilliseconds;
}

+(NSString *)getDateTimeToMilliSecondsStr:(NSDate *)datetime
{
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    //    NSLog(@"转换的时间戳=%f",interval);
    long long totalMilliseconds = interval*1000 ;
    //    NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
    return [NSString stringWithFormat:@"%lld",totalMilliseconds];
}

@end
