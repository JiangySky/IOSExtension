//
//  NSData+Jex.h
//  CrazyDice
//
//  Created by Jiangy on 12-8-30.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONExtensions.h"

@interface NSData (Jex) <JSONExtensions>

- (NSString *)UTF8String;
- (NSString *)stringWithEncode:(NSStringEncoding)encoding;
- (NSData *)gzipInflate;
- (NSData *)gzipData;

@end

@interface NSMutableData (Jex)

- (void)clear;

@end
