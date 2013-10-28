//
//  UIApplication+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-8-1.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "UIApplication+Jex.h"
#import "UIDevice+Jex.h"
#import "NSObject+Jex.h"
#import "Jex.h"

@implementation UIApplication (Jex)

+ (void)clearCache {
    [NSFileManager clearPath:[UIDevice documentPath]];
}

+ (void)clearCacheAtPath:(NSString *)path {
    [NSFileManager clearPath:path];
}

- (void)localNotification:(NSString *)info {
    [self localNotification:info withAction:[self name] repeat:NSDayCalendarUnit];
}

- (void)dailyNotification:(NSString *)info withAction:(NSString *)action {
    [self localNotification:info withAction:action repeat:NSDayCalendarUnit];
}

- (void)weeklyNotification:(NSString *)info withAction:(NSString *)action {
    [self localNotification:info withAction:action repeat:NSWeekdayOrdinalCalendarUnit];
}

- (void)localNotification:(NSString *)info withAction:(NSString *)action repeat:(NSCalendarUnit)repeat {
    self.applicationIconBadgeNumber = 0;
    [self cancelAllLocalNotifications];
    
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    if (notification != nil) {
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:86400 * 3]; // 本次开启立即执行的周期
        notification.repeatInterval = repeat; // 循环通知的周期
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = info; // 弹出的提示信息
        notification.applicationIconBadgeNumber = 1; // 应用程序的右上角小数字
        notification.soundName = UILocalNotificationDefaultSoundName; // 本地化通知的声音
        notification.alertAction = action; // 弹出的提示框按钮
        [self scheduleLocalNotification:notification];
    }
}


- (void)sendSMS:(NSString *)msg to:(NSString *)phone {
    if (!msg || [msg isEqualToString:@""]) {
        NSString * url = [NSString stringWithFormat:@"sms://%@", phone];
        [self openUrl:url];
    } else {
#ifdef PRIVATE_API_ENABLE
        Class cls = NSClassFromString(@"CTMessageCenter");
        [[cls sharedMessageCenter] sendSMSWithText:msg serviceCenter:nil toAddress:phone];
#endif
    }
}

- (void)telTo:(NSString *)phone {
    NSString * url = [NSString stringWithFormat:@"tel://%@", phone];
    [self openUrl:url];
}

- (void)openUrl:(NSString *)url {
    [self openURL:[NSURL URLWithString:url]];
}

- (void)openApplication:(NSString *)appSchemes {
    [self openURL:[NSURL URLWithString:appSchemes]];
}

- (void)openApplication:(NSString *)appSchemes inBackground:(BOOL)background {
    [self openURL:[NSURL URLWithString:appSchemes]];
//    if (background) {
//        [self ]
//    }
}

- (void)setHidden:(BOOL)hidden {
//    if (hidden) {
//        [self ]
//    }
}

- (void)createFolderInDocument {
    GET_FILEMANAGER;
    BOOL isDirectory = YES;
    NSString * path = [[UIDevice documentPath] stringByAppendingPathComponent:[self name]];
    if (![fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)createFolderInTemporary {
    GET_FILEMANAGER;
    BOOL isDirectory = YES;
    NSString * path = [[UIDevice temporaryPath] stringByAppendingPathComponent:[self name]];
    if (![fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSString *)appResourcePath:(NSString *)resName {
    NSString * path = [INSTANCE(Update) updateResourceFullPath:resName];
    if (!path || ![NSFileManager fileExit:path isDirectory:NO]) {
        path = [self resourceInBundle:resName];
    }
    return path;
}

- (NSString *)resourceInBundle:(NSString *)resName {
    return [MAIN_BUNDLE pathForResource:resName ofType:nil];
}

- (NSString *)resourceInDocument:(NSString *)resName {
    NSString * fullPath = [UIDevice documentPath];
    fullPath = [fullPath stringByAppendingPathComponent:[self name]];
    return [fullPath stringByAppendingPathComponent:resName];
}

- (NSString *)resourceInTemporary:(NSString *)resName {
    NSString * fullPath = [UIDevice temporaryPath];
    fullPath = [fullPath stringByAppendingPathComponent:[self name]];
    return [fullPath stringByAppendingPathComponent:resName];
}

- (NSString *)name {
    return [APP_INFO objectForKey:(NSString *)kCFBundleNameKey];
}

- (NSString *)displayName {
    return [APP_INFO objectForKey:@"CFBundleDisplayName"];
}

- (NSString *)urlSchemes {
    NSDictionary * schemes = [[APP_INFO objectForKey:@"CFBundleURLTypes"] objectAtIndex:0];
    if (schemes) {
        return [[schemes objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
    }
    return nil;
}

- (NSString *)appDirectory {
    NSMutableString * directory = [NSMutableString stringWithString:[APP_INFO objectForKey:@"NSBundleInitialPath"]];
    NSString * executable = [directory lastPathComponent];
    [directory replaceOccurrencesOfString:executable withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [directory length])];
    return [NSString stringWithString:directory];
}

- (NSString *)documentPath {
    NSString * fullPath = [UIDevice documentPath];
    fullPath = [fullPath stringByAppendingPathComponent:[self name]];
    return fullPath;
}

- (NSString *)temporaryPath {
    NSString * fullPath = [UIDevice temporaryPath];
    fullPath = [fullPath stringByAppendingPathComponent:[self name]];
    return fullPath;
}

- (NSString *)version {
    NSString * versionNumer = [self versionNumber];
    if ([versionNumer compare:@"0.5"] == NSOrderedAscending) {
        return [NSString stringWithFormat:@"α %@", versionNumer];
    } else if ([versionNumer compare:@"1.0"] == NSOrderedAscending) {
        return [NSString stringWithFormat:@"ß %@", versionNumer];
    } else {
        return [NSString stringWithFormat:@"V %@", versionNumer];
    }
}

- (NSString *)versionNumber {
    NSString * appVersion = nil;
    NSString * marketingVersion = [APP_INFO objectForKey:@"CFBundleVersion"];
    NSString * developmentVersion = [APP_INFO objectForKey:@"CFBundleShortVersionString"];
    if (marketingVersion && developmentVersion) {
        if ([marketingVersion isEqualToString:developmentVersion] || [developmentVersion isEqualToString:@"0"]) {
            appVersion = marketingVersion;
        } else {
            appVersion = [NSString stringWithFormat:@"%@%@", marketingVersion, developmentVersion];
        }
    } else {
        appVersion = (marketingVersion ? marketingVersion : developmentVersion);
    }
    return appVersion;
}

- (void)setTouchEnable:(BOOL)enable {
    if ((![self isIgnoringInteractionEvents]) ^ enable) {
        if (enable) {
            [self endIgnoringInteractionEvents];
        } else {
            [self beginIgnoringInteractionEvents];
        }
    }
}
- (void)terminate:(int)exitCode {
#ifdef PRIVATE_API_ENABLE
    exit(exitCode);
#endif
}

- (void)restart {
    [self openUrl:@"http://www.baidu.com"];
//    [self openApplication:[self urlSchemes]];
//    UIApplication * application = [UIApplication s]
//    [self performSelectorInBackground:@selector(openApplication:) withObject:[self urlSchemes]];
//    [NSThread detachNewThreadSelector:@selector(openApplication:) toTarget:self withObject:[self urlSchemes]];
//    exit(0);
}

- (UIImage *)searchImageWithName:(NSString *)name {
    NSString * localPath = [self appResourcePath:[name lastPathComponent]];
    if ([NSFileManager fileExit:localPath isDirectory:YES]) {
        return [UIImage imageWithContentsOfFile:localPath];
    } else {
        [INSTANCE(Update) downloadFile:name];
        return nil;
    }
}

@end
