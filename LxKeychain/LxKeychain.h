//
//  DeveloperLx
//  LxKeychain.h
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#define LX_UNAVAILABLE(msg) __attribute__((unavailable(msg)))

/*
 *  Can be customed by yourself. Default use md5.
 */
static NSString * (^const LxKeychainEncryptionBlock)(NSString *) = ^(NSString * string) {
    const char * cPlaintext = string.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cPlaintext, (CC_LONG)strlen(cPlaintext), result);
    NSMutableString * hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [NSString stringWithString:hash.lowercaseString];
};

@interface LxKeychain : NSObject

+ (OSStatus)insertOrUpdatePairsOfUsername:(NSString *)username password:(NSString *)password;
+ (OSStatus)cleanPasswordForUsername:(NSString *)username;
+ (OSStatus)deletePairsByUsername:(NSString *)username;
+ (NSString *)passwordForUsername:(NSString *)username;
+ (BOOL)password:(NSString *)password isCorrectToUsername:(NSString *)username;
+ (NSArray *)savedUsernameArray;
+ (NSString *)lastestUpdatedUsername;

+ (OSStatus)saveData:(id)data forService:(NSString *)service;
+ (id)fetchDataOfService:(NSString *)service;
+ (OSStatus)deleteService:(NSString *)service;

#pragma mark - Unavailable

- (instancetype)init LX_UNAVAILABLE("LxKeychain cannot be initialized!");
- (instancetype)initWithCoder:(NSCoder *)aDecoder LX_UNAVAILABLE("LxKeychain cannot be initialized!");

@end
