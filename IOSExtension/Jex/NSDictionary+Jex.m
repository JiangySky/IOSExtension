//
//  NSDictionary+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-8-30.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "NSDictionary+Jex.h"
#import "NSData+Jex.h"

@implementation NSDictionary (Jex)

+ (NSDictionary *)dictionaryWithJSONData:(NSData *)jsonData {
    return [JSON_READ deserializeAsDictionary:jsonData error:nil];
}

- (NSString *)JSONString {
    return [[JSON_WRITE serializeDictionary:self error:nil] UTF8String];
}

- (NSData *)JSONData {
    return [JSON_WRITE serializeDictionary:self error:nil];
}

- (NSData *)data {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

@end
