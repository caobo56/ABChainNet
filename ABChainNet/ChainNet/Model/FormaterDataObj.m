//
//  FormaterDataObj.m
//  textDemo
//
//  Created by caobo56 on 2018/3/13.
//  Copyright © 2018年 caobo. All rights reserved.
//

#import "FormaterDataObj.h"
#import "NetEncrypt.h"
#import "NSData+UTF8.h"


@interface FormaterDataObj()

@property(nonatomic,strong)NSDictionary * classMap;

@end

@implementation FormaterDataObj{
    NSData * orgData;
}

- (instancetype)initFromData:(NSData *)data
{
    self = [super init];
    if (self) {
        [self formaterFromData:data];
    }
    return self;
}

-(void)formaterFromData:(NSData *)data{
    
    if (data.length < 24) {
        self.size = (int)data.length;
        return;
    }
    self.resData = data;
    
    NSData * magicData = [[data subdataWithRange:NSMakeRange(0, 4)] copy];
    NSData * ma = [NSData convertHexStrToData:MagicStr];
    if (![magicData isEqualToData:ma]) {
        self.magic = magicData;
        return;
    }
    self.magic = magicData;
    
    NSData * commandData = [[data subdataWithRange:NSMakeRange(4, 12)] copy];
    NSString *command = [commandData utf8String];
    command = [command stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    NSString * className = [self classKindWithCommand:command];
    if (!className) {
        self.command = command;
        return;
    }
    self.command = command;
    
    //    if([self.command isEqualToString:@"transMsg"]){
    //        NSLog(@"Transaction");
    //    }
    
    orgData = [[data subdataWithRange:NSMakeRange(24, data.length-24)] copy];
    self.size = (int)orgData.length;
    
    self.checksum = [NetEncrypt sha256DataTwiceKey:orgData];
    
    NSData * checksum = [[data subdataWithRange:NSMakeRange(20, 4)] copy];
    if (![self.checksum isEqualToData:checksum]) {
        return;
    }else{
        NSError * error;
        Class Class = NSClassFromString(className);
        id  pdMessage = [Class parseFromData:orgData error:&error];
        if (error) {
            return;
        }else{
            self.payload = pdMessage;
        }
    }
}


- (instancetype)initWithObj:(GPBMessage *)msgObj
{
    self = [super init];
    if (self) {
        orgData = [msgObj data];
        self.magic = [NSData convertHexStrToData:MagicStr];
        self.command = [self commandWithclassKind:msgObj];
        
//        if ([self.command isEqualToString:@"discover"]) {
//            NSLog(@"self.command");
//        }
        self.size =  (int)[orgData length];
        self.checksum = [NetEncrypt sha256DataTwiceKey:orgData];
        self.payload = msgObj;
        
        NSMutableData * mData = [NSMutableData dataWithCapacity:1400];
        [mData appendData:self.magic];
        
        [mData appendBytes:[[self.command dataUsingEncoding:NSUTF8StringEncoding] bytes] length:self.command.length];
        
        char byte_chars[9] = {'\0','\0','\0','\0','\0','\0','\0','\0','\0'};
        if (mData.length < 16) {
            [mData appendBytes:byte_chars length:12-self.command.length];
        }
        
        [mData appendData:[NSData int2Nsdata:self.size]];
        NSData * dataChecksum = [[self.checksum subdataWithRange:NSMakeRange(0, 4)] copy];
        [mData appendData:dataChecksum];
        [mData appendData:orgData];
        
        self.resData = (NSData *)mData;
        //        NSLog(@"resData == %@",self.resData);
    }
    
    return self;
}

-(NSString *)commandWithclassKind:(GPBMessage *)msgObj{
    NSString *className = NSStringFromClass([msgObj class]);
    NSString * command = [self.classMap valueForKey:className];
    return command;
}

-(NSString *)classKindWithCommand:(NSString *)command{
    command = [command stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    NSArray * nameArr = [self.classMap allKeysForObject:command];
    NSString * className;
    if (nameArr.count > 0) {
        className = nameArr.firstObject;
    }else{
        className = nil;
    }
    return className;
}

-(NSDictionary *)classMap{
    if (!_classMap) {
        _classMap = @{
                      @"VersionMessage":@"version",
                      @"DiscoverMessage":@"discover",
                      @"DiscoverReplyMessage":@"discReply",
                      @"PingMessage":@"ping",
                      @"PongMessage":@"pong",
                      @"FindMessage":@"find",
                      @"FindAckMessage":@"findack",
                      @"Transaction":@"transMsg"
                      };
    }
    return _classMap;
}

@end
