//
//  UIApplication+Jex.h
//  CrazyDice
//
//  Created by Jiangy on 12-8-1.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP                 [UIApplication sharedApplication]
#define APP_DELEGATE        [APP delegate]
#define MAIN_BUNDLE         [NSBundle mainBundle]
#define APP_INFO            [MAIN_BUNDLE infoDictionary]

#define GET_FILEMANAGER     NSFileManager * fileManager = [NSFileManager defaultManager]

@interface UIApplication (Jex)

+ (void)clearCache;
+ (void)clearCacheAtPath:(NSString *)path;
- (void)localNotification:(NSString *)info;
- (void)dailyNotification:(NSString *)info withAction:(NSString *)action;
- (void)weeklyNotification:(NSString *)info withAction:(NSString *)action;
- (void)localNotification:(NSString *)info withAction:(NSString *)action repeat:(NSCalendarUnit)repeat;

- (void)sendSMS:(NSString *)msg to:(NSString *)phone;
- (void)telTo:(NSString *)phone;
- (void)openUrl:(NSString *)url;
- (void)openApplication:(NSString *)appSchemes;
- (void)openApplication:(NSString *)appSchemes inBackground:(BOOL)background;
- (void)setHidden:(BOOL)hidden;
- (void)createFolderInDocument;
- (void)createFolderInTemporary;
- (NSString *)appResourcePath:(NSString *)resName;
- (NSString *)resourceInBundle:(NSString *)resName;
- (NSString *)resourceInDocument:(NSString *)resName;
- (NSString *)resourceInTemporary:(NSString *)resName;
- (NSString *)name;
- (NSString *)displayName;
- (NSString *)urlSchemes;
- (NSString *)appDirectory;
- (NSString *)documentPath;
- (NSString *)temporaryPath;
- (NSString *)version;
- (NSString *)versionNumber;
- (void)setTouchEnable:(BOOL)enable;
- (void)terminate:(int)exitCode;
- (void)restart;
- (UIImage *)searchImageWithName:(NSString *)name;

@end
