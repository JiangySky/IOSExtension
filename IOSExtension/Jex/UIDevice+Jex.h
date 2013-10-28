//
//  UIDevice+Jex.h
//  JyExtension
//
//  Created by Jiangy on 12-7-27.
//  Copyright (c) 2012年 V5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JexMacro.h"
#import <AddressBook/AddressBook.h>

#define CURRENT_DEVICE          [UIDevice currentDevice]
#define NETWORK_ENABLE          [UIDevice connectedToNetwork]
#define CAN_CONN_HOST(_host)    [UIDevice canConnectToHost:_host]

enum _DeviceType {
    kDeviceTypeNone,
	kDeviceTypeIPhone1G,
	kDeviceTypeIPhone3G,
	kDeviceTypeIPhone3GS,
	kDeviceTypeIPhone4,
	kDeviceTypeIPhone4S,
	kDeviceTypeIPhone5,
	kDeviceTypeIPad,
	kDeviceTypeIPad2,
    kDeviceTypeIPad3,
	kDeviceTypeIPod1,
	kDeviceTypeIPod2,
	kDeviceTypeIPod3,
	kDeviceTypeIPod4,
    
    kDeviceTypeIMac
};
typedef enum _DeviceType JexDeviceType;

#ifdef PRIVATE_API_ENABLE
extern NSString * CTSettingCopyMyPhoneNumber();
#endif

@interface UIDevice (Jex)

+ (int)reboot;
+ (void)vibrate;
+ (NSString *)osVersion;
+ (NSString *)osMajorVer;
+ (NSString *)osMinorVer;
+ (NSString *)createUUID;
+ (NSString *)deviceVersion;
+ (BOOL)isJailBroken;
+ (NSString *)deviceIP;
+ (NSString *)getWANAddress;
+ (NSString *)getWifiAddress;
+ (NSString *)getIPAddressBy:(NSString *)ifaName;
+ (NSString *)hostname;
+ (NSDate *)bootTime;
+ (NSString *)phoneNumber;

- (NSString *)machine;
- (NSString *)deviceName;
- (JexDeviceType)deviceType;
- (NSString *)uniqueDeviceIdentifier;
- (NSString *)macaddress;
- (NSString *)uniqueGlobalDeviceIdentifier;
- (BOOL)isRetina;
- (BOOL)isHD;
- (BOOL)isSimulator;

+ (NSString *)applicationPath;
+ (NSString *)documentPath;
+ (NSString *)temporaryPath;

- (CGFloat)batteryLeft;
- (NSInteger)batteryPercentage;
- (BOOL)isCharging;

- (NSUInteger)getSysInfo:(uint)typeSpecifier;

- (NSUInteger)cpuFrequency;
- (NSUInteger)busFrequency;
- (NSUInteger)totalMemory;
- (NSUInteger)userMemory;

- (NSNumber *)totalDiskSpace;
- (NSNumber *)freeDiskSpace;

+ (BOOL)connectedToNetwork;
+ (BOOL)canConnectToHost:(NSString *)hostName;

+ (BOOL)isTouch:(UITouch *)touch inRect:(CGRect)rect;

@end

#ifdef PRIVATE_API_ENABLE
@interface UIDevice (IOKitExtensions)

- (NSString *)imei;
- (NSString *)serialnumber;
- (NSString *)backlightlevel;
+ (NSInteger)installIPA:(NSString *)path;
+ (void)installAppZip:(NSString *)path;

@end

@interface UIDevice (AddressBook)

+ (ABAddressBookRef)addressBook;
+ (NSArray *)contactList;
+ (ABRecordRef)getABRecordRefAtIndex:(NSInteger)index inContact:(NSArray *)contact;
+ (ABRecordID)getABRecordIDAtIndex:(NSInteger)index inContact:(NSArray *)contact;
+ (ABRecordID)getABRecordIdWithRecord:(ABRecordRef)record;
+ (NSString *)getCompositeNameAtIndex:(NSInteger)index inContact:(NSArray *)contact;
+ (NSString *)getCompositeNameWithRecord:(ABRecordRef)record;
+ (NSMutableArray *)getPhoneNumbersAtIndex:(NSInteger)index inContact:(NSArray *)contact;
+ (NSMutableArray *)getPhoneNumbersWithRecord:(ABRecordRef)record;
+ (NSString *)getFullNameAtIndex:(NSInteger)index inContact:(NSArray *)contact;
+ (NSString *)getFullNameWithRecord:(ABRecordRef)record;
+ (NSData *)getPersonPhotoImgDataAtIndex:(NSInteger)index inContact:(NSArray *)contact;
+ (NSData *)getPersonPhotoImgDataWithRecord:(ABRecordRef)record;

@end
#endif