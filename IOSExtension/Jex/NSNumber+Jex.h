//
//  NSNumber+Jex.h
//  CrazyDice
//
//  Created by Jiangy on 12-8-30.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONExtensions.h"

#define NSNumberFromBool(_value)                [NSNumber numberWithBool:_value]
#define NSNumberFromInt(_value)                 [NSNumber numberWithInteger:_value]
#define NSNumberFromLongLong(_value)            [NSNumber numberWithLongLong:_value]

@interface NSNumber (Jex) <JSONExtensions>

@end
