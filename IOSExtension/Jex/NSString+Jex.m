//
//  NSString+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-7-31.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "NSString+Jex.h"
#import <CommonCrypto/CommonDigest.h>
#import "JSON.h"
#import "NSData+Jex.h"
#include <ctype.h>

@implementation NSString (Jex)

+ (NSString *)stringWithJSONData:(NSData *)jsonData {
    return (NSString *)[JSON_READ deserialize:jsonData error:nil];
}

- (NSString *)JSONString {
    return [[JSON_WRITE serializeString:self error:nil] UTF8String];
}

- (NSData *)JSONData {
    return [JSON_WRITE serializeString:self error:nil];
}

+ (NSString *)stringWithInteger:(NSInteger)value {
    return [NSString stringWithFormat:@"%i", value];
}

+ (NSString *)stringWithFloat:(CGFloat)value {
    return [NSString stringWithFormat:@"%f", value];
}

+ (NSString *)stringWithLongLong:(int64_t)value {
    return [NSString stringWithFormat:@"%llu", value];
}

- (NSString *)stringFromMD5 {
    if(self == nil || [self length] == 0) {
        return nil;
    }
    
    const char * value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString * outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString autorelease];
}

- (BOOL)isChinese {
    const char * ch = [self cStringUsingEncoding:NSUnicodeStringEncoding];
    return sizeof(ch) > 1 && ch[1] != 0;
}

- (BOOL)isPunct {
    const char * value = [self UTF8String];
    return ispunct((int)value) != 0;
}

- (BOOL)isNumber {
    NSScanner * scanner = [NSScanner scannerWithString:self];
    int val;
    return [scanner scanInt:&val] && [scanner isAtEnd];
}

- (BOOL)isDot {
    return [self isEqualToString:@"."];
}

- (BOOL)isSpace {
    return [self isEqualToString:@" "];
}

- (BOOL)isLetters {
    const char * value = [self UTF8String];
    return isalpha((int)value) != 0;
}

- (NSInteger)firstIndexOfChar:(unichar)ch {
	return [self firstIndexOfChar:ch withAppearCount:1];
}

- (NSInteger)lastIndexOfChar:(unichar)ch {
	for(NSInteger i = self.length - 1; i >= 0; i--) {
		if(ch == [self characterAtIndex:i]) {
			return i;
		}
	}
	
	return -1;
}

- (NSInteger)firstIndexOfChar:(unichar)ch withAppearCount:(NSInteger)count {
	NSInteger appearCount = 0;
	
	for(NSInteger i = 0; i < self.length; i++) {
		if(ch == [self characterAtIndex:i]) {
			appearCount++;
			if(appearCount == count) {
				return i;
			}
		}
	}
	
	return -1;
}

- (NSString *)prefix {
    NSInteger index = [self firstIndexOfChar:'.'];
    if (index >= 0) {
        return [self substringToIndex:index];
    }
    return self;
}

- (NSString *)suffix {
    NSInteger index = [self lastIndexOfChar:'.'];
    if (index >= 0) {
        return [self substringFromIndex:(index + 1)];
    }
    return self;
}

- (NSString *)leftTrim {
    NSInteger length = [self length];
    for (int i = 0; i < length; i++) {
        if ([self characterAtIndex:i] != ' ') {
            return [self substringFromIndex:i];
        }
    }
    return self;
}

- (NSString *)rightTrim {
    for (int i = [self length] - 1; i >= 0; i--) {
        if ([self characterAtIndex:i] != ' ') {
            return [self substringToIndex:(i + 1)];
        }
    }
    return self;
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end

@implementation NSMutableString (Jex)

- (void)deleteLastCharacter {
    if ([self length] > 0) {
        [self replaceCharactersInRange:NSMakeRange([self length] - 1, 1) withString:@""];
    }
}

@end
