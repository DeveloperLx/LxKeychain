//
//  DeveloperLx
//  LxKeychain.m
//

#import "LxKeychain.h"
#import <Security/Security.h>
#import <UIKit/UIDevice.h>

static NSString * const LX_USERNAME_ARRAY_SERVICE = @"LX_USERNAME_ARRAY_SERVICE";
static NSString * const LX_USERNAME_KEY = @"LX_USERNAME_KEY";
static NSString * const LX_PASSWORD_KEY = @"LX_PASSWORD_KEY";

static NSString * const LX_DEVICE_UNIQUE_IDENTIFIER = @"LX_DEVICE_UNIQUE_IDENTIFIER";

@implementation LxKeychain

+ (NSString *)generateServiceByUsername:(NSString *)username
{
    return LxKeychainEncryptionBlock(username);
}

+ (OSStatus)insertOrUpdatePairsOfUsername:(NSString *)username password:(NSString *)password
{
    NSString * service = [self generateServiceByUsername:username];
    OSStatus status = noErr;
    status = [self deleteService:service];
    status = [self saveData:password forService:service];
    
    NSString * usernameArrayService = LxKeychainEncryptionBlock(LX_USERNAME_ARRAY_SERVICE);
    NSMutableArray * savedUsernameArray = [NSMutableArray arrayWithArray:[self savedUsernameArray]];
    if ([savedUsernameArray containsObject:username]) {
        [savedUsernameArray removeObject:username];
    }
    [savedUsernameArray addObject:username];
    status = [self deleteService:usernameArrayService];
    status = [self saveData:[NSArray arrayWithArray:savedUsernameArray] forService:usernameArrayService];
    
    return status;
}

+ (OSStatus)cleanPasswordForUsername:(NSString *)username
{
    NSString * service = [self generateServiceByUsername:username];
    OSStatus status = noErr;
    status = [self deleteService:service];
    status = [self saveData:nil forService:service];
    return status;
}

+ (OSStatus)deletePairsByUsername:(NSString *)username
{
    NSString * service = [self generateServiceByUsername:username];
    OSStatus status = noErr;
    status = [self deleteService:service];
    
    NSString * usernameArrayService = LxKeychainEncryptionBlock(LX_USERNAME_ARRAY_SERVICE);
    NSMutableArray * savedUsernameArray = [NSMutableArray arrayWithArray:[self savedUsernameArray]];
    if ([savedUsernameArray containsObject:username]) {
        [savedUsernameArray removeObject:username];
    }
    status = [self deleteService:usernameArrayService];
    status = [self saveData:[NSArray arrayWithArray:savedUsernameArray] forService:usernameArrayService];
    
    return status;
}

+ (NSString *)passwordForUsername:(NSString *)username
{
    NSString * service = [self generateServiceByUsername:username];
    return (NSString *)[self fetchDataOfService:service];
}

+ (BOOL)password:(NSString *)password isCorrectToUsername:(NSString *)username
{
    if (password.length == 0) {
        return NO;
    }
    else {
        return [password isEqualToString:[self passwordForUsername:username]];
    }
}

+ (NSArray *)savedUsernameArray
{
    NSString * usernameArrayService = LxKeychainEncryptionBlock(LX_USERNAME_ARRAY_SERVICE);
    return (NSArray *)[self fetchDataOfService:usernameArrayService];
}

+ (NSString *)lastestUpdatedUsername
{
    return (NSString *)([self savedUsernameArray].lastObject);
}

+ (NSMutableDictionary *)generateQueryMutableDictionaryOfService:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock, (__bridge id)kSecAttrAccessible,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            nil];
}

+ (OSStatus)saveData:(id<NSCoding>)data forService:(NSString *)service
{    
    NSAssert([(NSObject *)data conformsToProtocol:@protocol(NSCoding)] || data == nil, @"data must conforms protocol NSCoding or NSSecureCoding!");    //
    
    NSMutableDictionary * keychainQuery = [self generateQueryMutableDictionaryOfService:service];
    OSStatus status = noErr;
    status = SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    [keychainQuery setValue:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    CFTypeRef result = 0;
    status = SecItemAdd((__bridge CFDictionaryRef)keychainQuery, &result);
    
    return status;
}

+ (id<NSCoding>)fetchDataOfService:(NSString *)service
{
    NSMutableDictionary * keychainQuery = [self generateQueryMutableDictionaryOfService:service];
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    OSStatus status = noErr;
    
    CFDataRef archivedData = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&archivedData);
    
    if (status == noErr) {
        id data = nil;
        @try {
            data = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)archivedData];
        }
        @catch (NSException * exception) {
            NSLog(@"Unarchive of %@ failed: %@", service, exception);
        }
        @finally {
            if (archivedData) {
                CFRelease(archivedData);
            }
            return data;
        }
    }
    else {
        return nil;
    }
}

+ (OSStatus)deleteService:(NSString *)service
{
    NSMutableDictionary * keychainQuery = [self generateQueryMutableDictionaryOfService:service];
    return SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

+ (NSString *)deviceUniqueIdentifer
{
    NSString * deviceUniqueIdentifer = (NSString *)[self fetchDataOfService:LX_DEVICE_UNIQUE_IDENTIFIER];
    
    if (!deviceUniqueIdentifer) {
        
        deviceUniqueIdentifer = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [self saveData:deviceUniqueIdentifer forService:LX_DEVICE_UNIQUE_IDENTIFIER];
    }
    
    return deviceUniqueIdentifer;
}

@end
