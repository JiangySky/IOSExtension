//
//  UIDevice+Jex.m
//  JyExtension
//
//  Created by Jiangy on 12-7-27.
//  Copyright (c) 2012年 V5. All rights reserved.
//

#import "UIDevice+Jex.h"
#import "NSString+Jex.h"
#import "NSFileManager+Jex.h"
#import "UIApplication+Jex.h"
#import "NSObject+Jex.h"
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <mach/mach_host.h>
#import <netdb.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <netinet/in.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>
#import <sys/socket.h>
#import <AudioToolbox/AudioToolbox.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <dlfcn.h>
#import "SSZipArchive.h"
#ifdef REACHABLILITY_ENABLE
#import "Reachability.h"
#endif

@implementation UIDevice (Jex)

+ (int)reboot {
#ifdef PRIVATE_API_ENABLE
	system("echo alpine | su root");
	return system("reboot");
#else
    return -1;
#endif
}

+ (void)vibrate {
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (NSString *)osVersion {
    return [CURRENT_DEVICE systemVersion];
}

+ (NSString *)osMajorVer {
    NSString * osVer = [UIDevice osVersion];
    if(osVer == nil) {
        return nil;
    }
	NSInteger index = [osVer firstIndexOfChar:'.'];
	if(index < 0) {
		return osVer;
	}
    if(index == 0) {
		return @"";
	}
    return [osVer substringToIndex:index];
}

+ (NSString *)osMinorVer {
    return [[UIDevice osVersion] suffix];
}

+ (NSString *)createUUID {
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef guid = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString * uuidString = [((NSString *)guid) stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(guid);
	
	return uuidString;
}

+ (BOOL)isJailBroken {
	return [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"];
}

+ (NSString *)deviceVersion {
	struct utsname u;
	uname(&u);
	return [NSString stringWithUTF8String:u.machine];
}

+ (NSString *)deviceIP {
#ifdef REACHABLILITY_ENABLE
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi) {
        return [UIDevice getWifiAddress];
    }
#endif
    return [UIDevice getWANAddress];
}

+ (NSString *)getWANAddress {
    return [self getIPAddressBy:@"pdp_ip0"];
}

+ (NSString *)getWifiAddress {
    return [self getIPAddressBy:@"en0"];
}

+ (NSString *)getIPAddressBy:(NSString *)ifaName {
    struct ifaddrs *addrs;
    struct ifaddrs *cur;
    
    if (!getifaddrs(&addrs)) {
        cur = addrs;
        while (cur != NULL) {
			if (cur->ifa_addr->sa_family == AF_INET) {
                if (!strcmp(cur->ifa_name, [ifaName UTF8String])) {
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cur->ifa_addr)->sin_addr)];
                }
			}
            cur = cur->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}

+ (NSString *)hostname {
    char tempHostName[256];
    int success = gethostname(tempHostName, 255);
    if (success != 0) {
		return nil;
    }
    tempHostName[255] = '\0';
    
    if ([CURRENT_DEVICE isSimulator]) {
        return [NSString stringWithFormat:@"%s", tempHostName];
    } else {
        return [NSString stringWithFormat:@"%s.local", tempHostName];
    }
}

+ (NSDate *)bootTime {
    size_t size = sizeof(struct timeval);
    struct timeval * time = malloc(sizeof(struct timeval));
    if(time == NULL) {
		return nil;
    }
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    sysctl(mib, 2, time, &size, NULL, 0);
	
    NSDate * bootTm = [NSDate dateWithTimeIntervalSince1970:time->tv_sec];
    free(time);
    return  bootTm;
}

+ (NSString *)phoneNumber {
    if ([CURRENT_DEVICE isSimulator]) {
        return @"13800138000";
    }
#ifdef PRIVATE_API_ENABLE
    NSString * myPhone = CTSettingCopyMyPhoneNumber();
#else
    NSString * myPhone = [[NSUserDefaults standardUserDefaults] valueForKey:@"SBFormattedPhoneNumber"];
#endif
    if (NSStringIsEmpty(myPhone)) {
        return NSLocalizedString(@"获取失败", @"");
    } else {
        NSMutableString * tempPhoneKey = [NSMutableString stringWithString:myPhone];
        [tempPhoneKey replaceOccurrencesOfString:@"(" withString:@"" options:NSBackwardsSearch
                                           range:NSMakeRange(0, [tempPhoneKey length])];
        [tempPhoneKey replaceOccurrencesOfString:@")" withString:@"" options:NSBackwardsSearch
                                           range:NSMakeRange(0, [tempPhoneKey length])];
        [tempPhoneKey replaceOccurrencesOfString:@"-" withString:@"" options:NSBackwardsSearch
                                           range:NSMakeRange(0, [tempPhoneKey length])];
        [tempPhoneKey replaceOccurrencesOfString:@" " withString:@"" options:NSBackwardsSearch
                                           range:NSMakeRange(0, [tempPhoneKey length])];
        [tempPhoneKey replaceOccurrencesOfString:@"+86" withString:@"" options:NSBackwardsSearch
                                           range:NSMakeRange(0, [tempPhoneKey length])];
        return [NSString stringWithString:tempPhoneKey];
    }
}

#pragma mark -

- (NSString *)machine {
    size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char * name = (char *)malloc(size);
	sysctlbyname("hw.machine", name, &size, NULL, 0);
	NSString * machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
	free(name);
	return machine;
}

- (NSString *)deviceName {
    NSString * deviceType = [CURRENT_DEVICE machine];
    if ([deviceType isEqualToString:@"i386"]) {
        return @"iPhoneSim";
    }
    if ([deviceType isEqualToString:@"iPhone1,1"]) {
        return @"iPhone1";
    }
    if ([deviceType isEqualToString:@"iPhone1,2"]) {
        return @"iPhone3G";
    }
    if ([deviceType isEqualToString:@"iPhone2,1"]) {
        return @"iPhone3GS";
    }
    if ([deviceType isEqualToString:@"iPhone3,1"]) {
        return @"iPhone4";
    }
    if ([deviceType isEqualToString:@"iPhone3,3"]) {
        return @"iPhone4(vz)";
    }
    if ([deviceType isEqualToString:@"iPod1,1"]) {
        return @"iPod Touch1";
    }
    if ([deviceType isEqualToString:@"iPod2,1"]) {
        return @"iPod Touch2";
    }
    if ([deviceType isEqualToString:@"iPod3,1"]) {
        return @"iPod Touch3";
    }
    if ([deviceType isEqualToString:@"iPod4,1"]) {
        return @"iPod Touch4";
    }
    if ([deviceType isEqualToString:@"iPad1,1"]) {
        return @"iPad";
    }
    if ([deviceType isEqualToString:@"iPad2,1"]) {
        return @"iPad2Wifi";
    }
    if ([deviceType isEqualToString:@"iPad2,2"]) {
        return @"iPad2GSM3G";
    }
    if ([deviceType isEqualToString:@"iPad2,3"]) {
        return @"iPad2CDMA3G";
    }
    if ([deviceType isEqualToString:@"AppleTV2,1"]) {
        return @"AppleTV(2G)";
    }
    
    return @"unknow";
}

- (JexDeviceType)deviceType {
    static JexDeviceType deviceType = kDeviceTypeNone;
    if (deviceType == kDeviceTypeNone) {
        struct utsname u;
        if (0 == uname(&u)) {
            if (strstr(u.machine, "iPhone1,1")) {
                deviceType = kDeviceTypeIPhone1G;
            } else if (strstr(u.machine, "iPhone1,2")) {
                deviceType = kDeviceTypeIPhone3G;	
            } else if (strstr(u.machine, "iPhone2,1")) {
                deviceType = kDeviceTypeIPhone3GS;	
            } else if (strstr(u.machine, "iPhone3,1")) {
                deviceType = kDeviceTypeIPhone4;	
            } else if (strstr(u.machine, "iPhone4,1")) {
                deviceType = kDeviceTypeIPhone4S;
            } else if (strstr(u.machine, "iPhone5,1")) {
                deviceType = kDeviceTypeIPhone5;
            } else if (strstr(u.machine, "iPad1,1")) {
                deviceType = kDeviceTypeIPad;	
            } else if (strstr(u.machine, "iPad2,1")) {
                deviceType = kDeviceTypeIPad2;
            } else if (strstr(u.machine, "iPad3,1")) {
                deviceType = kDeviceTypeIPad3;
            } else if (strstr(u.machine, "iPod1,1")) {
                deviceType = kDeviceTypeIPod1;	
            } else if (strstr(u.machine, "iPod2,1")) {
                deviceType = kDeviceTypeIPod2;	
            } else if (strstr(u.machine, "iPod3,1")) {
                deviceType = kDeviceTypeIPod3;	
            } else if (strstr(u.machine, "iPod4,1")) {
                deviceType = kDeviceTypeIPod4;	
            } else {
                deviceType = kDeviceTypeIMac;
                CGSize screenSize = [UIScreen mainScreen].currentMode.size;
                if (CGSizeEqualToSize(screenSize, CGSizeMake(1536, 2048))) {
                    deviceType = kDeviceTypeIPad3;
                } else if (CGSizeEqualToSize(screenSize, CGSizeMake(640, 1136))) {
                    deviceType = kDeviceTypeIPhone5;
                }
            }
        }
    }
    return deviceType;
}

- (NSString *)uniqueDeviceIdentifier{
#if kUniqueIdentifierOpen
    return [self uniqueIdentifier];
#else
    if ([self respondsToSelector:@selector(uniqueIdentifier)]) {
        return [self uniqueIdentifier];
    }
    NSString * macaddress = [self macaddress];
    NSString * bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];    
    NSString * stringToHash = [NSString stringWithFormat:@"%@%@", macaddress, bundleIdentifier];
    NSString * uniqueIdentifier = [stringToHash stringFromMD5];     
    return uniqueIdentifier;
#endif
}

- (NSString *)macaddress{    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

- (NSString *)uniqueGlobalDeviceIdentifier{
    NSString * macaddress = [CURRENT_DEVICE macaddress];
    NSString * uniqueIdentifier = [macaddress stringFromMD5];
    
    return uniqueIdentifier;
}

- (BOOL)isRetina {
    JexDeviceType deviceType = [self deviceType];
    if (deviceType == kDeviceTypeIPhone4 || deviceType == kDeviceTypeIPhone4S || deviceType == kDeviceTypeIPod4 
        || deviceType == kDeviceTypeIPhone5 || deviceType == kDeviceTypeIPad3) {
        return YES;
    } else if (deviceType == kDeviceTypeIMac) {
        CGSize mainScreenSize = [[UIScreen mainScreen] currentMode].size;
        if (FLOAT_EQUAL(mainScreenSize.width, 640) || FLOAT_EQUAL(mainScreenSize.width, 960)
            || FLOAT_EQUAL(mainScreenSize.width, 1536) || FLOAT_EQUAL(mainScreenSize.width, 2048)) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isHD {
    JexDeviceType deviceType = [self deviceType];
    if (deviceType == kDeviceTypeIPad || deviceType == kDeviceTypeIPad2 || deviceType == kDeviceTypeIPad3) {
        return YES;
    } else if (deviceType == kDeviceTypeIMac) {
        CGSize mainScreenSize = [[UIScreen mainScreen] currentMode].size;
        if (FLOAT_EQUAL(mainScreenSize.width, 768) || FLOAT_EQUAL(mainScreenSize.width, 1024)
            || FLOAT_EQUAL(mainScreenSize.width, 1536) || FLOAT_EQUAL(mainScreenSize.width, 2048)) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isSimulator {
    return [self deviceType] == kDeviceTypeIMac;
}

#pragma mark -

+ (NSString *)applicationPath {
    NSArray * searchPaths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return (NSString *)[searchPaths objectAtIndex:0];
}

+ (NSString *)documentPath {
    NSArray * searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return (NSString *)[searchPaths objectAtIndex:0];
}

+ (NSString *)temporaryPath {
    return NSTemporaryDirectory();
}

#pragma mark -

- (CGFloat)batteryLeft {
    [self setBatteryMonitoringEnabled:YES];
    return [self batteryLevel];
}

- (NSInteger)batteryPercentage {
    [self setBatteryMonitoringEnabled:YES];
    return (int)([self batteryLevel] * 100);
}

- (BOOL)isCharging {
    [self setBatteryMonitoringEnabled:YES];
    return [self batteryState] == UIDeviceBatteryStateCharging;
}

#pragma mark -

- (NSUInteger)getSysInfo:(uint)typeSpecifier {
	size_t size = sizeof(int);
	int results;
	int mib[2] = {CTL_HW, typeSpecifier};
	sysctl(mib, 2, &results, &size, NULL, 0);
	return (NSUInteger)results;
}

- (NSUInteger)cpuFrequency {
	return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger)busFrequency {
	return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger)totalMemory {
	return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger)userMemory {
	return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger)maxSocketBufferSize {
	return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark -

- (NSNumber *) totalDiskSpace {
	NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace {
	NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark -

+ (BOOL)connectedToNetwork {
#ifdef REACHABLILITY_ENABLE
    return [[Reachability reachabilityForInternetConnection] isReachable];
#else
    // Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags) {
		printf("Error. Could not recover network reachability flags\n");
		return 0;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	return (isReachable && !needsConnection) ? YES : NO;
#endif
}

+ (BOOL)canConnectToHost:(NSString *)hostName {
    if (NSStringIsEmpty(hostName)) {
        return [UIDevice connectedToNetwork];
    }
#ifdef REACHABLILITY_ENABLE
    return [[Reachability reachabilityWithHostName:hostName] isReachable];
#else
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
	if(reachability != NULL) {
		SCNetworkReachabilityFlags flags;
		if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            CFRelease(reachability);
			if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
				return NO;
			}
			if((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect)) {
				return [self hostAvailable:hostName];	// NOTE: WiFi enable
			}
			if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
				return [self hostAvailable:hostName];	// NOTE: WiFi enable
			}
			if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
				 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
				if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
					return [self hostAvailable:hostName];	// NOTE: WiFi enable
				}
			}
			if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
				return [self hostAvailable:hostName];	// NOTE: ViaWWAN enable
			}
		}
	}
	
	return NO;
#endif
}

+ (BOOL)hostAvailable:(NSString *)theHost {
	NSString * addressString = [self getIPAddressForHost:theHost];
	if (!addressString)
	{
		printf("Error recovering IP address from host name\n");
		return NO;
	}
	
	struct sockaddr_in address;
	BOOL gotAddress = [self addressFromString:addressString address:&address];
	
	if (!gotAddress) {
		printf("Error recovering sockaddr address from %s\n", [addressString UTF8String]);
		return NO;
	}
	
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags) {
		printf("Error. Could not recover network reachability flags\n");
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	return isReachable ? YES : NO;;
}

+ (NSString *)getIPAddressForHost:(NSString *)theHost {
	struct hostent * host = gethostbyname([theHost UTF8String]);
	
    if (host == NULL) {
        herror("resolv");
		return NULL;
	}
	
	struct in_addr ** list = (struct in_addr **)host->h_addr_list;
	NSString * addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
	return addressString;
}

+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address {
	if (!IPAddress || ![IPAddress length]) {
		return NO;
	}
	
	memset((char *)address, sizeof(struct sockaddr_in), 0);
	address->sin_family = AF_INET;
	address->sin_len = sizeof(struct sockaddr_in);
	
	int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
	if (conversionResult == 0) {
		NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
		return NO;
	}
	
	return YES;
}

+ (BOOL)isTouch:(UITouch *)touch inRect:(CGRect)rect {
    CGPoint touchLocation = [touch locationInView:touch.view];
    touchLocation.y = touch.view.frame.size.height - touchLocation.y;
    return CGRectContainsPoint(rect, touchLocation);
}

@end

#ifdef PRIVATE_API_ENABLE
#pragma mark -

@implementation UIDevice (IOKitExtensions)

#define kIODeviceTreePlane		"IODeviceTree"

enum {
    kIORegistryIterateRecursively	= 0x00000001,
    kIORegistryIterateParents		= 0x00000002
};

typedef mach_port_t	io_object_t;
typedef io_object_t	io_registry_entry_t;
typedef char		io_name_t[128];
typedef UInt32		IOOptionBits;

CFTypeRef
IORegistryEntrySearchCFProperty(
								io_registry_entry_t	entry,
								const io_name_t		plane,
								CFStringRef		key,
								CFAllocatorRef		allocator,
								IOOptionBits		options );

kern_return_t
IOMasterPort( mach_port_t	bootstrapPort,
			 mach_port_t *	masterPort );

io_registry_entry_t
IORegistryGetRootEntry(
					   mach_port_t	masterPort );

CFTypeRef
IORegistryEntrySearchCFProperty(
								io_registry_entry_t	entry,
								const io_name_t		plane,
								CFStringRef		key,
								CFAllocatorRef		allocator,
								IOOptionBits		options );

kern_return_t   mach_port_deallocate
(ipc_space_t                               task,
 mach_port_name_t                          name);

NSArray * getValue(NSString *iosearch) {
    mach_port_t          masterPort;
    CFTypeID             propID = (CFTypeID) NULL;
    unsigned int         bufSize;
	
    kern_return_t kr = IOMasterPort(MACH_PORT_NULL, &masterPort);
    if (kr != noErr) return nil;
	
    io_registry_entry_t entry = IORegistryGetRootEntry(masterPort);
    if (entry == MACH_PORT_NULL) return nil;
	
    CFTypeRef prop = IORegistryEntrySearchCFProperty(entry, kIODeviceTreePlane, (CFStringRef) iosearch, nil, kIORegistryIterateRecursively);
    if (!prop) return nil;
	
	propID = CFGetTypeID(prop);
    if (!(propID == CFDataGetTypeID()))
	{
		mach_port_deallocate(mach_task_self(), masterPort);
		return nil;
	}
	
    CFDataRef propData = (CFDataRef) prop;
    if (!propData) return nil;
	
    bufSize = CFDataGetLength(propData);
    if (!bufSize) return nil;
	
    NSString * p1 = [[[NSString alloc] initWithBytes:CFDataGetBytePtr(propData) length:bufSize encoding:1] autorelease];
    mach_port_deallocate(mach_task_self(), masterPort);
    return [p1 componentsSeparatedByString:@"\0"];
}

- (NSString *)imei {
	NSArray * results = getValue(@"device-imei");
	return (results ? [results objectAtIndex:0] : nil);
}

- (NSString *)serialnumber {
	NSArray * results = getValue(@"serial-number");
	return (results ? [results objectAtIndex:0] : nil);
}

- (NSString *)backlightlevel {
	NSArray * results = getValue(@"backlight-level");
	return (results ? [results objectAtIndex:0] : nil);
}

typedef int (* MobileInstallationInstall)(NSString * path, NSDictionary * dict, void * na, NSString * path2_equal_path_maybe_no_use);

+ (NSInteger)installIPA:(NSString *)path {
    if (![NSFileManager fileExit:path isDirectory:NO]) {
        return -1;
    }
    void * lib = dlopen("/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation", RTLD_LAZY);
    if (lib) {
        MobileInstallationInstall pMobileInstallationInstall = (MobileInstallationInstall)dlsym(lib, "MobileInstallationInstall");
        if (pMobileInstallationInstall) {
            return (int)pMobileInstallationInstall(path, [NSDictionary dictionaryWithObject:@"User" forKey:@"ApplicationType"], 0, path);
        }
    }
    return -1;
}

+ (void)installAppZip:(NSString *)path {
    [SSZipArchive unzipFileAtPath:path
                    toDestination:[APP appDirectory] overwrite:YES password:NULL error:NULL];
    [NSFileManager deleteFile:path];
}

@end

#pragma mark -

@implementation UIDevice (AddressBook)

+ (ABAddressBookRef)addressBook {
    return ABAddressBookCreate();
}

+ (NSArray *)contactList {
    return (NSArray *)ABAddressBookCopyArrayOfAllPeople([UIDevice addressBook]);
}

+ (ABRecordRef)getABRecordRefAtIndex:(NSInteger)index inContact:(NSArray *)contact {
    return [contact objectAtIndex:index];
}

+ (ABRecordID)getABRecordIDAtIndex:(NSInteger)index inContact:(NSArray *)contact {
    return ABRecordGetRecordID([contact objectAtIndex:index]);
}
+ (ABRecordID)getABRecordIdWithRecord:(ABRecordRef)record {
    return ABRecordGetRecordID(record);
}

+ (NSString *)getCompositeNameAtIndex:(NSInteger)index inContact:(NSArray *)contact {
    return [(NSString *)ABRecordCopyCompositeName([contact objectAtIndex:index]) autorelease];
}
+ (NSString *)getCompositeNameWithRecord:(ABRecordRef)record {
    return [(NSString *)ABRecordCopyCompositeName(record) autorelease];
}

+ (NSMutableArray *)getPhoneNumbersAtIndex:(NSInteger)index inContact:(NSArray *)contact {
    return [UIDevice getPhoneNumbersWithRecord:[contact objectAtIndex:index]];
}
+ (NSMutableArray *)getPhoneNumbersWithRecord:(ABRecordRef)record {
    ABMultiValueRef tempArray = (ABMultiValueRef)ABRecordCopyValue(record, kABPersonPhoneProperty);
	if(!tempArray) {
		return nil;
	}
    NSMutableArray * phoneArray  = [NSMutableArray new];
	for(int i = 0; i < ABMultiValueGetCount(tempArray); ++i) {
		NSString * phoneNumber = (NSString *)ABMultiValueCopyValueAtIndex(tempArray, i);
		[phoneArray addObject:phoneNumber];
		CFRelease(phoneNumber);
	}
	CFRelease(tempArray);
    
	return [phoneArray autorelease];
}

+ (NSString *)getFullNameAtIndex:(NSInteger)index inContact:(NSArray *)contact {
    return [UIDevice getFullNameWithRecord:[contact objectAtIndex:index]];
}
+ (NSString *)getFullNameWithRecord:(ABRecordRef)record {
    NSString * firstName = (NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
    NSString * midName = (NSString *)ABRecordCopyValue(record, kABPersonMiddleNameProperty);
	NSString * lastName = (NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
    if (!firstName) {
		firstName = @"";
    }
    if (!midName) {
		midName = @"";
    }
	if (!lastName) {
		lastName = @"";
	}
	CFRelease(firstName);
	CFRelease(lastName);
    NSArray * languages = [NSLocale preferredLanguages];
    NSString * langName = [languages objectAtIndex:0];
	if([langName isEqualToString:@"en"]) {
        return [NSString stringWithFormat:@"%@ %@", firstName, lastName]; 
    } else if([langName isEqualToString:@"zh-Hans"]) {
        return [NSString stringWithFormat:@"%@%@", lastName, firstName]; 
    } else {
        return [NSString stringWithFormat:@"%@%@%@", firstName, midName, lastName];
    }
}

+ (NSData *)getPersonPhotoImgDataAtIndex:(NSInteger)index inContact:(NSArray *)contact {
    return [UIDevice getPersonPhotoImgDataWithRecord:[contact objectAtIndex:index]];
}
+ (NSData *)getPersonPhotoImgDataWithRecord:(ABRecordRef)record {
    return (NSData *)ABPersonCopyImageData(record);
}

@end
#endif