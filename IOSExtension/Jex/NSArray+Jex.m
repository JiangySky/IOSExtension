//
//  NSArray+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-8-30.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "NSArray+Jex.h"
#import "NSData+Jex.h"
#import "JSON.h"

@implementation NSArray (Jex)

+ (NSArray *)arrayWithJSONData:(NSData *)jsonData {
    return [JSON_READ deserializeAsArray:jsonData error:nil];
}

- (NSString *)JSONString {
    return [[JSON_WRITE serializeArray:self error:nil] UTF8String];
}

- (NSData *)JSONData {
    return [JSON_WRITE serializeArray:self error:nil];
}

@end
