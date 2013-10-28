//
//  NSNumber+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-8-30.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "NSNumber+Jex.h"
#import "NSData+Jex.h"
#import "JSON.h"

@implementation NSNumber (Jex)

+ (NSNumber *)numberWithJSONData:(NSData *)jsonData {
    return (NSNumber *)[JSON_READ deserialize:jsonData error:nil];
}

- (NSString *)JSONString {
    return [[JSON_WRITE serializeNumber:self error:nil] UTF8String];
}

- (NSData *)JSONData {
    return [JSON_WRITE serializeNumber:self error:nil];
}

@end
