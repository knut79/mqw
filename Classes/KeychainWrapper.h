//Third Party Code
//from http://www.raywenderlich.com/6475/basic-security-in-ios-5-tutorial-part-1


#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonHMAC.h>

#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

// Used for saving to NSUserDefaults that a PIN has been set, and is the unique identifier for the Keychain.
#define PIN_SAVED @"hasSavedPIN"

// Used for saving the user's name to NSUserDefaults.
#define USERNAME @"username"

// Used to help secure the PIN.
// Ideally, this is randomly generated, but to avoid the unnecessary complexity and overhead of storing the Salt separately, we will standardize on this key.
// !!KEEP IT A SECRET!!
#define SALT_HASH @"YOURMADEUPSALTHASHB8TQRygHaS2B1pgfy02wqGndj7PLHD2G3fxaZz4oGA3RsKdN2pxdAopXYgzzzz"

@interface KeychainWrapper : NSObject

// Generic exposed method to search the keychain for a given value. Limit one result per search.
+ (NSData *)searchKeychainCopyMatchingIdentifier:(NSString *)identifier;

// Calls searchKeychainCopyMatchingIdentifier: and converts to a string value.
+ (NSString *)keychainStringFromMatchingIdentifier:(NSString *)identifier;

// Simple method to compare a passed in hash value with what is stored in the keychain.
// Optionally, we could adjust this method to take in the keychain key to look up the value.
+ (BOOL)compareKeychainValueForMatchingPIN:(NSUInteger)pinHash;

// Default initializer to store a value in the keychain.
// Associated properties are handled for you - setting Data Protection Access, Company Identifer (to uniquely identify string, etc).
+ (BOOL)createKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;

// Updates a value in the keychain. If you try to set the value with createKeychainValue: and it already exists,
// this method is called instead to update the value in place.
+ (BOOL)updateKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;

// Delete a value in the keychain.
+ (void)deleteItemFromKeychainWithIdentifier:(NSString *)identifier;

// Generates an SHA256 (much more secure than MD5) hash.
+ (NSString *)securedSHA256DigestHashForPIN:(NSUInteger)pinHash;
+ (NSString*)computeSHA256DigestForString:(NSString*)input;

@end
