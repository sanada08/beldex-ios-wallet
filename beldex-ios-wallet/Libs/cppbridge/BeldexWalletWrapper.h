//
//  BeldexWalletWrapper.h
//  beldex-ios-wallet
//
//  Created by Sanada Yukimura on 6/2/22.
//
#import <Foundation/Foundation.h>
#import "BeldexSubAddress.h"
#import "BeldexWalletListener.h"
#import "BeldexTrxHistory.h"
@class BeldexWalletWrapper;

@protocol BeldexWalletDelegate <NSObject>
- (void)beldexWalletRefreshed:(nonnull BeldexWalletWrapper *)wallet;
- (void)beldexWalletNewBlock:(nonnull BeldexWalletWrapper *)wallet currentHeight:(uint64_t)currentHeight;

@end



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
- (BOOL)save;

+ (BeldexWalletWrapper *)generateWithPath:(NSString *)path
                                 password:(NSString *)password
                                 language:(NSString *)language;
+ (BeldexWalletWrapper *)recoverWithSeed:(NSString *)seed
                                    path:(NSString *)path
                                password:(NSString *)password;
- (BOOL)connectToDaemon:(NSString *)daemonAddress delegate:(id<BeldexWalletDelegate>)delegate;
- (BOOL)connectToDaemon:(NSString *)daemonAddress refresh:(BeldexWalletRefreshHandler)refresh newBlock:(BeldexWalletNewBlockHandler)newBlock;

- (NSString *)getSeedString:(NSString *)language;
+ (NSString *)displayAmount:(uint64_t)amount;
- (NSArray<BeldexSubAddress *> *)fetchSubAddressWithAccountIndex:(uint32_t)index;

+ (BeldexWalletWrapper *)openExistingWithPath:(NSString *)path
                                     password:(NSString *)password;

- (int64_t)transactionFee;
- (void)startRefresh;
- (NSArray<BeldexTrxHistory *> *)fetchTransactionHistory;
@end
