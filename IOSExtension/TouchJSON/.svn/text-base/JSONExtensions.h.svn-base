//
//  JSONExtensions.h
//  CrazyDice
//
//  Created by Jiangy on 12-8-30.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@protocol JSONExtensions <NSObject>

@optional
+ (id)objectWithJSONData:(NSData *)jsonData;
+ (NSData *)dataWithJSONData:(NSData *)jsonData;
+ (NSDictionary *)dictionaryWithJSONData:(NSData *)jsonData;
+ (NSArray *)arrayWithJSONData:(NSData *)jsonData;
+ (NSString *)stringWithJSONData:(NSData *)jsonData;
+ (NSNumber *)numberWithJSONData:(NSData *)jsonData;
+ (NSNull *)nullWithJSONData:(NSData *)jsonData;

@required
- (NSData *)JSONData;
- (NSString *)JSONString;

@end
