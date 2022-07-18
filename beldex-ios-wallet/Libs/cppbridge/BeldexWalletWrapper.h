//
//  BeldexWalletWrapper.h
//  beldex-ios-wallet
//
//  Created by Sanada Yukimura on 6/2/22.
//
#import <Foundation/Foundation.h>
#import "BeldexSubAddress.h"

@class BeldexWalletWrapper;


@interface BeldexWalletWrapper : NSObject
@property (nonatomic, copy, readonly) NSString * name;


@property (nonatomic, assign, readonly) BOOL isSynchronized;
@property (nonatomic, assign, readonly) int status;
@property (nonatomic, copy, readonly) NSString * errorMessage;

@property (nonatomic, copy, readonly) NSString * publicViewKey;
@property (nonatomic, copy, readonly) NSString * publicSpendKey;
@property (nonatomic, copy, readonly) NSString * secretViewKey;
@property (nonatomic, copy, readonly) NSString * secretSpendKey;
@property (nonatomic, copy, readonly) NSString * publicAddress;

@property (nonatomic, assign, readonly) uint64_t balance;
@property (nonatomic, assign, readonly) uint64_t unlockedBalance;
@property (nonatomic, assign, readonly) uint64_t blockChainHeight;
@property (nonatomic, assign, readonly) uint64_t daemonBlockChainHeight;
@property (nonatomic, assign, readwrite) uint64_t restoreHeight;


+ (BeldexWalletWrapper *)generateWithPath:(NSString *)path
                                 password:(NSString *)password
                                 language:(NSString *)language;
+ (BeldexWalletWrapper *)recoverWithSeed:(NSString *)seed
                                    path:(NSString *)path
                                password:(NSString *)password;
+ (BeldexWalletWrapper *)recoverFromKeysWithPath:(NSString *)path
                                        password:(NSString *)password
                                        language:(NSString *)language
                                   restoreHeight:(uint64_t)restoreHeight
                                        address:(NSString *)address
                                        viewKey:(NSString *)viewKey
                                        spendKey:(NSString *)spendKey;
- (BOOL)connectToDaemon:(NSString *)daemonAddress;

- (NSString *)getSeedString:(NSString *)language;
+ (NSString *)displayAmount:(uint64_t)amount;
+ (NSString *)generatePaymentId;
+ (NSString *)paymentIdFromAddress:(NSString *)address;


- (NSString *)getSeedString:(NSString *)language;
- (BOOL)setNewPassword:(NSString *)password;
- (NSString *)generateIntegartedAddress:(NSString *)paymentId;

//- (void)setDelegate:(id<BeldexWalletDelegate>)delegate;

- (BOOL)addSubAddress:(NSString *)label accountIndex:(uint32_t)index;
- (BOOL)setSubAddress:(NSString *)label addressIndex:(uint32_t)addressIndex accountIndex:(uint32_t)accountIndex;
- (NSArray<BeldexSubAddress *> *)fetchSubAddressWithAccountIndex:(uint32_t)index;

@end
