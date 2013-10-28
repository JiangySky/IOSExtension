//
//  NSString+Jex.h
//  CrazyDice
//
//  Created by Jiangy on 12-7-31.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONExtensions.h"

#define NSStringFromInt(_value)                 [NSString stringWithInteger:_value]
#define NSStringFromFloat(_value)               [NSString stringWithFloat:_value]
#define NSStringFromLongLong(_value)            [NSString stringWithLongLong:_value]
#define NSStringFromPercent(_value0, _value1)   [NSString stringWithFormat:@"%i/%i", _value0, _value1]
#define NSStringIsEmpty(_str)                   (!_str || [_str isEqual:NULL_OBJ] || [[_str trim] isEqualToString:@""])

@interface NSString (Jex) <JSONExtensions>

+ (NSString *)stringWithInteger:(NSInteger)value;
+ (NSString *)stringWithFloat:(CGFloat)value;
+ (NSString *)stringWithLongLong:(int64_t)value;
- (NSString *)stringFromMD5;
- (BOOL)isChinese;
- (BOOL)isPunct;
- (BOOL)isNumber;
- (BOOL)isDot;
- (BOOL)isSpace;
- (BOOL)isLetters;
- (NSInteger)firstIndexOfChar:(unichar)ch;
- (NSInteger)lastIndexOfChar:(unichar)ch;
- (NSInteger)firstIndexOfChar:(unichar)ch withAppearCount:(NSInteger)count;
- (NSString *)prefix;
- (NSString *)suffix;
- (NSString *)leftTrim;
- (NSString *)rightTrim;
- (NSString *)trim;

@end

@interface NSMutableString (Jex)

- (void)deleteLastCharacter;

@end
