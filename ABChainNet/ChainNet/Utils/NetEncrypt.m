//
//  NetEncrypt.m
//  textDemo
//
//  Created by caobo56 on 2018/6/29.
//  Copyright © 2018年 dahua. All rights reserved.
//

#import "NetEncrypt.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+UTF8.h"

@implementation NetEncrypt

+ (NSData*)sha1DataWithData:(NSData *)data{
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    NSData *outData = [output dataUsingEncoding:NSUTF8StringEncoding];
    return outData;
}

+ (NSString *)sha256StringWithData:(NSData *)data{
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (int)data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

+ (NSData *)sha256DataTwiceKey:(NSData *)data{
    NSString * firstkey = [NetEncrypt sha256StringWithData:data];
    
    NSData * firstData = [NSData convertHexStrToData:firstkey];
    
    NSString * secondKey = [NetEncrypt sha256StringWithData:firstData];
    NSData * secondData = [NSData convertHexStrToData:secondKey];
    
    return [secondData subdataWithRange:NSMakeRange(0, 4)];
}


@end
