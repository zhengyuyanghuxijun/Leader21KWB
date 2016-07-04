//
//  TFDeviceInfo.m
//  LediKWB
//
//  Created by ChunGuo on 15/12/11.
//  Copyright © 2016年 huxijun. All rights reserved.
//

#import "HBDeviceInfo.h"
#import <sys/mount.h>
#import <Foundation/NSProcessInfo.h>
#import <mach/mach.h>
#import <sys/stat.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <sys/utsname.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <CoreLocation/CLLocationManager.h>
#import <AddressBook/AddressBook.h>

@implementation TFDeviceInfo

+ (NSString *)getDeviceName
{
    UIDevice* device = [UIDevice currentDevice];
    return device.name;
}

+ (NSString *)getDeviceModel
{
    UIDevice* device = [UIDevice currentDevice];
    return device.model;
}

+ (NSString *)getDeviceGeneration
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone_6s_Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone_6s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone_6_Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone_6";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone_5s";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone_5s";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone_5c";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone_5c";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone_5";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone_5";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone_4S";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone_4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone_4";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone_4";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone_3GS";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone_3G";
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone";
    
    //iPad
    if ([platform isEqualToString:@"iPad6,4"]) return @"iPad_Pro";
    if ([platform isEqualToString:@"iPad6,3"]) return @"iPad_Pro";
    if ([platform isEqualToString:@"iPad6,8"]) return @"iPad_Pro";
    if ([platform isEqualToString:@"iPad6,7"]) return @"iPad_Pro";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad_Air_2";
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad_Air_2";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad_Air";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad_Air";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad_Air";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad_4";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad_4";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad_4";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad_3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad_3";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad_3";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad_2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad_2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad_2";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad_2";
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    
    //iPad mini
    if ([platform isEqualToString:@"iPad5,2"]) return @"iPad_mini_4";
    if ([platform isEqualToString:@"iPad5,1"]) return @"iPad_mini_4";
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPad_mini_3";
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPad_mini_3";
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPad_mini_3";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad_mini_2";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad_mini_2";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad_mini_2";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad_mini";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad_mini";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad_mini";
    
    //iPod touch
    if ([platform isEqualToString:@"iPod7,1"]) return @"iPod_touch_6G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod_touch_5G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod_touch_4G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod_touch_3G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod_touch_2G";
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod_touch";
    
    //Apple Watch
    if ([platform isEqualToString:@"Watch1,2"]) return @"Apple_Watch";
    if ([platform isEqualToString:@"Watch1,1"]) return @"Apple_Watch";
    
    //Apple TV
    if ([platform isEqualToString:@"AppleTV5,3"]) return @"Apple_TV_4G";
    if ([platform isEqualToString:@"AppleTV3,2"]) return @"Apple_TV_3G";
    if ([platform isEqualToString:@"AppleTV3,1"]) return @"Apple_TV_3G";
    if ([platform isEqualToString:@"AppleTV2,1"]) return @"Apple_TV_2G";
    
    //模拟器
    if ([platform isEqualToString:@"i386"])     return @"iPhone_Simulator";
    if ([platform isEqualToString:@"x86_64"])   return @"iPhone_Simulator";
    
    return platform;
}

+ (NSString *)getDeviceLocalizedModel
{
    UIDevice* device = [UIDevice currentDevice];
    return device.localizedModel;
}

+ (NSString *)getDeviceSystemName
{
    UIDevice* device = [UIDevice currentDevice];
    return device.systemName;
}

+ (NSString *)getDeviceSystemVersion
{
    UIDevice* device = [UIDevice currentDevice];
    return device.systemVersion;
}

+ (NSString *)getDeviceUUID
{
    UIDevice* device = [UIDevice currentDevice];
    return [device.identifierForVendor UUIDString];
}

+ (NSString *)getDeviceBatteryLevel
{
    UIDevice* device = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"%f%%",device.batteryLevel*100];
}

+ (NSString *)getDeviceBatteryState
{
    UIDevice* device = [UIDevice currentDevice];
    return [self batteryStateToString:device.batteryState];
}

+ (NSString*)batteryStateToString:(UIDeviceBatteryState)state
{
    switch ( state ) {
        case UIDeviceBatteryStateUnplugged:{
            return @"UIDeviceBatteryStateUnplugged";
        }
        case UIDeviceBatteryStateCharging: {
            return @"UIDeviceBatteryStateCharging";
        }
        case UIDeviceBatteryStateFull: {
            return @"UIDeviceBatteryStateFull";
        }
        default:{
            return @"UIDeviceBatteryStateUnknown";
        }
    }
}

+ (NSString *)getDeviceTotalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:@"/private/var" error:nil];
    NSString *totalSpace = fattributes[@"NSFileSystemSize"];
    unsigned long long totalSpaceNum = [totalSpace longLongValue];
    totalSpace = [NSString stringWithFormat:@"%llu",totalSpaceNum];
    
    return [self convertUnitToFit:totalSpace];
}

+ (NSString *)getDeviceFreeDiskSpace
{
    
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:@"/private/var" error:nil];
    NSString *freeSpace = fattributes[@"NSFileSystemFreeSize"];
    unsigned long long freeSpaceNum = [freeSpace longLongValue];
    freeSpace = [NSString stringWithFormat:@"%llu",freeSpaceNum];
    
    return [self convertUnitToFit:freeSpace];
}

+ (NSString *)getDeviceTotalMemory
{
    unsigned long long deviceMemory_number = [[NSProcessInfo processInfo] physicalMemory];
    NSString *deviceMemory = [NSString stringWithFormat:@"%llu",deviceMemory_number];
    
    return [self convertUnitToFit:deviceMemory];
    
}

+ (NSString *)getDeviceFreeMemory
{
    NSString *freeMemory = @"";
    vm_statistics_data_t vmStats;
    if (memoryInfo(&vmStats)) {
        unsigned long free_count_size  = vmStats.free_count * vm_page_size;
        freeMemory = [self convertUnitToFit:[NSString stringWithFormat:@"%lu",free_count_size]];
    }
    
    return freeMemory;
    
}

+ (NSString *)convertUnitToFit:(NSString *)ByteStringValue
{
    unsigned long long minValue = 1024*1024;
    unsigned long long maxValue = 1024*1024*1024;
    unsigned long long ByteNumber = [ByteStringValue longLongValue];
    
    if (minValue < ByteNumber && ByteNumber< maxValue ) {
        return [self convertUnitToMB:ByteStringValue];
    }
    else if (ByteNumber >= maxValue){
        return [self convertUnitToGB:ByteStringValue];
    }
    
    return [NSString stringWithFormat:@"%@KB",ByteStringValue];
    
}

+ (NSString *)convertUnitToMB:(NSString *)ByteStringValue
{
    NSDecimalNumber *decimalNum = [NSDecimalNumber decimalNumberWithString:ByteStringValue];
    NSDecimal changeDecimal = [[NSNumber numberWithLong:1024*1024] decimalValue];
    decimalNum = [decimalNum decimalNumberByDividingBy:
                  [NSDecimalNumber decimalNumberWithDecimal:changeDecimal]];
    NSString *mbStringValue = [decimalNum stringValue];
    NSRange range = [mbStringValue rangeOfString:@"."];
    if (range.length) {
        mbStringValue =  [NSString stringWithFormat:@"%@",[mbStringValue substringToIndex:range.location+3]];
    }
    
    return [NSString stringWithFormat:@"%@MB",mbStringValue];
    
}

+ (NSString *)convertUnitToGB:(NSString *)ByteStringValue
{
    NSDecimalNumber *decimalNum = [NSDecimalNumber decimalNumberWithString:ByteStringValue];
    NSDecimal changeDecimal = [[NSNumber numberWithLongLong:1024*1024*1024] decimalValue];
    decimalNum = [decimalNum decimalNumberByDividingBy:
                  [NSDecimalNumber decimalNumberWithDecimal:changeDecimal]];
    NSString *gbStringValue = [decimalNum stringValue];
    NSRange range = [gbStringValue rangeOfString:@"."];
    if (range.length) {
        gbStringValue =  [NSString stringWithFormat:@"%@",[gbStringValue substringToIndex:range.location+3]];
        
    }
    
    return [NSString stringWithFormat:@"%@GB",gbStringValue];
}

+ (NSString *)getDeviceMacAddress
{
    if ([[self getDeviceSystemVersion] compare:@"7.0"] == NSOrderedDescending || [[self getDeviceSystemVersion] compare:@"7.0"] == NSOrderedSame) {
        NSLog(@"You can not get the MAC address in iOS7 or later");
        return nil;
    }
    int                   mib[6];
    size_t                len;
    char                  *buf;
    unsigned char         *ptr;
    struct if_msghdr      *ifm;
    struct sockaddr_dl    *sdl;
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}

+ (BOOL)isJailBreak
{
    int res = access("/var/mobile/Library/AddressBook/AddressBook.sqlitedb", F_OK);
    if (res != 0){
        return NO;
    }
    
    return YES;
}

BOOL memoryInfo(vm_statistics_data_t *vmStats)
{
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)vmStats, &infoCount);
    
    return kernReturn == KERN_SUCCESS;
}

+ (BOOL)isNotificationAuth
{
    if (IOS8_Later) {
        
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (setting.types != UIUserNotificationTypeNone) {
            
            return YES;
        }
        
    } else {
        
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (type != UIRemoteNotificationTypeNone) {
            
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isPhotoAuth
{
    if (IOS8_Later) {
        
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
        if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied) {
            
            return NO;
        }
        
    }else{
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
            
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isCameraAuth
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        return NO;
    }
    return YES;
}

+ (BOOL)isLocationAuth
{
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus == kCLAuthorizationStatusRestricted ||
        authStatus == kCLAuthorizationStatusDenied) {
        
        return NO;
    }
    return YES;
}

+ (BOOL)isAddressBookAuth
{
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus == kABAuthorizationStatusRestricted || authStatus == kABAuthorizationStatusDenied) {
        
        return NO;
    }
    return YES;
}

@end
