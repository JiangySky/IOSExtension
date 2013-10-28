//
//  NSDate+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-9-4.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "NSDate+Jex.h"

@implementation NSDate (Jex)

+ (NSString *)localeDate {
    char timeNow[20];
    time_t lt;
    struct tm * tp;
    lt = time(NULL);
    tp = localtime(&lt);
    strftime(timeNow, 20, "%Y-%m-%d %T", tp);
    return [NSString stringWithUTF8String:timeNow];
}

- (NSString *)localeDescription {
    return [self descriptionWithLocale:[NSLocale currentLocale]];
}

+ (NSString *)timeStringFromInterval:(NSTimeInterval)interval {
    NSInteger second = (int)interval % 60;
    NSInteger minute = ((int)interval / 60) % 60;
    NSInteger hour = ((int)interval / 3600) % 60;
    NSMutableString * time = [NSMutableString stringWithCapacity:0];
    if (hour > 0) {
        [time appendFormat:@"%i:", hour];
    }
    if (minute > 0) {
        if ([time length] > 0 && minute < 10) {
            [time appendString:@"0"];
        }
        [time appendFormat:@"%i:", minute];
    }
    
    if ([time length] > 0 && second < 10) {
        [time appendString:@"0"];
    }
    [time appendFormat:@"%i", second];
    
    return time;
}

+ (NSString *)minuteTimeFromInterval:(NSTimeInterval)interval  {
    NSInteger second = (int)interval % 60;
    NSInteger minute = ((int)interval / 60) % 60;
    NSInteger hour = ((int)interval / 3600) % 60;
    NSMutableString * time = [NSMutableString stringWithCapacity:0];
    if (hour > 0) {
        [time appendFormat:@"%i:", hour];
    }
    
    if (minute < 10) {
        [time appendString:@"0"];
    }
    [time appendFormat:@"%i:", minute];
    
    if ([time length] > 0 && second < 10) {
        [time appendString:@"0"];
    }
    [time appendFormat:@"%i", second];
    
    return time;
}

+ (NSString *)descriptionLeftTime:(NSInteger)interval {
    NSInteger second = interval % 60;
    NSInteger minute = (interval / 60) % 60;
    NSInteger hour = (interval / 3600) % 60;
    NSInteger day = hour / 24;
    hour %= 24;
    NSMutableString * time = [NSMutableString stringWithCapacity:0];
    if (day > 0) {
        [time appendFormat:@"%i 天 ", day];
    }
    [time appendFormat:@"%i 时 ", hour];
    [time appendFormat:@"%i 分 ", minute];
    if (second > 0) {
        [time appendFormat:@"%i 秒 ", second];
    }
    
    return time;
}

+ (NSString *)descriptionOverTime:(NSInteger)interval {
    return nil;
}

@end
