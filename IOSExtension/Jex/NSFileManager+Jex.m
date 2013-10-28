//
//  NSFileManager+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-9-6.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "NSFileManager+Jex.h"

@implementation NSFileManager (Jex)

+ (void)createPath:(NSString *)path {
    NSFileManager * fm = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if (![fm fileExistsAtPath:path isDirectory:&isDirectory]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (void)clearPath:(NSString *)path {
    NSFileManager * fm = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if ([fm fileExistsAtPath:path isDirectory:&isDirectory]) {
        [fm removeItemAtPath:path error:nil];
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
//        NSDirectoryEnumerator * dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
//        NSString * fileName;
//        while (fileName = [dirEnum nextObject]) {
//            [fm removeItemAtPath:[NSString stringWithFormat:@"%@%@", path, fileName] error:nil];
//        }
    }
}

+ (void)createFile:(NSString *)fullPath {
    NSFileManager * fm = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (![fm fileExistsAtPath:fullPath isDirectory:&isDirectory]) {
        [fm createFileAtPath:fullPath contents:nil attributes:nil];
    }
}

+ (void)appendContent:(NSString *)content toFile:(NSString *)fullPath {
   [self createFile:fullPath];
    NSFileHandle * fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:fullPath];
    [fileHandler seekToEndOfFile];
    [fileHandler writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (void)deleteFile:(NSString *)fullPath {
    NSFileManager * fm = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if ([fm fileExistsAtPath:fullPath isDirectory:&isDirectory]) {
        [fm removeItemAtPath:fullPath error:nil];
    }
}

+ (BOOL)fileExit:(NSString *)path isDirectory:(BOOL)isDirectory {
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
}

@end
