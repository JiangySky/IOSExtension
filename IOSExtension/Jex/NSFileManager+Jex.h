//
//  NSFileManager+Jex.h
//  CrazyDice
//
//  Created by Jiangy on 12-9-6.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Jex)

+ (void)createPath:(NSString *)path;
+ (void)clearPath:(NSString *)path;
+ (void)createFile:(NSString *)fullPath;
+ (void)appendContent:(NSString *)content toFile:(NSString *)fullPath;
+ (void)deleteFile:(NSString *)fullPath;
+ (BOOL)fileExit:(NSString *)path isDirectory:(BOOL)isDirectory;

@end
