//
//  MoneroWalletWrapper.m
//  beldex-ios-wallet
//
//  Created by Sanada Yukimura on 5/18/22.
//

#import <Foundation/Foundation.h>
#import "BeldexWalletWrapper.h"
#import "BeldexConfig.h"

using namespace std;
#pragma mark - Data

@interface BeldexWalletWrapper ()
{
    Wallet::Wallet* beldex_wallet;
    
}
@end

@implementation BeldexWalletWrapper

- (instancetype)init {
    if (self = [super init]) {
        beldex_wallet = nullptr;
    }
    return self;
}

+ (BeldexWalletWrapper *)init_beldex_wallet:(Wallet::Wallet *)beldex_wallet {
    auto stat = beldex_wallet->status();
    
    if (stat.first != Wallet::Wallet::Status_Ok) return NULL;
#if DEBUG
    Wallet::WalletManagerFactory::setLogLevel(Wallet::WalletManagerFactory::LogLevel_Max);
#endif
    BeldexWalletWrapper *walletWrapper = [[BeldexWalletWrapper alloc] init];
    walletWrapper->beldex_wallet = beldex_wallet;
    cout<<"beldex_wallet<><> init_Wallet---->"<< &beldex_wallet<< endl;
    return walletWrapper;
}

+ (BeldexWalletWrapper *)generateWithPath:(NSString *)path
                                 password:(NSString *)password
                                 language:(NSString *)language {
    struct Wallet::WalletManagerBase *walletManager = Wallet::WalletManagerFactory::getWalletManager();
    string utf8Path = [path UTF8String];
    string utf8Pwd = [password UTF8String];
    string utf8Lg = [language UTF8String];
    Wallet::Wallet* beldex_wallet = walletManager->createWallet(utf8Path, utf8Pwd, utf8Lg, netType);
    cout<<"beldex_wallet---->"<< &beldex_wallet << endl;
    return [self init_beldex_wallet:beldex_wallet];
}

+ (BeldexWalletWrapper *)recoverWithSeed:(NSString *)seed
                                    path:(NSString *)path
                                password:(NSString *)password {
    struct Wallet::WalletManagerBase *walletManager = Wallet::WalletManagerFactory::getWalletManager();
    string utf8Path = [path UTF8String];
    string utf8Pwd = [password UTF8String];
    string utf8Seed = [seed UTF8String];
    Wallet::Wallet* beldex_wallet = walletManager->recoveryWallet(utf8Path, utf8Pwd, utf8Seed, netType, 0, 1);
    return [self init_beldex_wallet:beldex_wallet];
}

+ (BeldexWalletWrapper *)recoverFromKeysWithPath:(NSString *)path
                                        password:(NSString *)password
                                        language:(NSString *)language
                                   restoreHeight:(uint64_t)restoreHeight
                                         address:(NSString *)address
                                         viewKey:(NSString *)viewKey
                                        spendKey:(NSString *)spendKey {
    struct Wallet::WalletManagerBase *walletManager = Wallet::WalletManagerFactory::getWalletManager();
    string utf8Path = [path UTF8String];
    string utf8Pwd = [password UTF8String];
    string utf8Language = [language UTF8String];
    string utf8Address = [address UTF8String];
    string utf8ViewKey = [viewKey UTF8String];
    string utf8SpendKey = [spendKey UTF8String];
    Wallet::Wallet* beldex_wallet = walletManager->createWalletFromKeys(utf8Path, utf8Pwd, utf8Language, netType, restoreHeight, utf8Address, utf8ViewKey, utf8SpendKey);
    return [self init_beldex_wallet:beldex_wallet];
}

+ (BeldexWalletWrapper *)openExistingWithPath:(NSString *)path
                                     password:(NSString *)password {
    struct Wallet::WalletManagerBase *walletManager = Wallet::WalletManagerFactory::getWalletManager();
    string utf8Path = [path UTF8String];
    string utf8Pwd = [password UTF8String];
    Wallet::Wallet* beldex_wallet = walletManager->openWallet(utf8Path, utf8Pwd, netType);
    return [self init_beldex_wallet:beldex_wallet];
}

- (BOOL)connectToDaemon:(NSString *)daemonAddress {
    
    if (!beldex_wallet) return NO;
    return beldex_wallet->init([daemonAddress UTF8String]);
}

- (NSString *)getSeedString:(NSString *)language {
    string seed = "";
    if (beldex_wallet) {
        beldex_wallet->setSeedLanguage([language UTF8String]);
        seed = beldex_wallet->seed();
    }
    return objc_str_dup(seed);
}

- (NSString *)name {
    NSString *name = @"";
    if (beldex_wallet) {
        NSString *filename = objc_str_dup(beldex_wallet->filename());
        NSString *lastItem = [[filename componentsSeparatedByString:@"/"] lastObject];
        if (lastItem) {
            name = lastItem;
        }
    }
    return name;
}

- (void)startRefresh {
    if (beldex_wallet) {
        beldex_wallet->startRefresh();
    }
}

- (void)pauseRefresh {
    if (beldex_wallet) {
        beldex_wallet->pauseRefresh();
    }
}

- (NSString *)publicAddress {
    string address  = "";
    if (beldex_wallet) {
        address = beldex_wallet->address();
    }
    return objc_str_dup(address);
}

- (NSString *)publicViewKey {
    string key  = "";
    if (beldex_wallet) {
        key = beldex_wallet->publicViewKey();
    }
    return objc_str_dup(key);
}

- (NSString *)publicSpendKey {
    string key  = "";
    if (beldex_wallet) {
        key = beldex_wallet->publicSpendKey();
    }
    return objc_str_dup(key);
}
- (NSString *)secretViewKey {
    string key  = "";
    if (beldex_wallet) {
        key = beldex_wallet->secretViewKey();
    }
    return objc_str_dup(key);
}
- (NSString *)secretSpendKey {
    string key  = "";
    if (beldex_wallet) {
        key = beldex_wallet->secretSpendKey();
    }
    return objc_str_dup(key);
}

- (uint64_t)balance {
    if (beldex_wallet) {
        return beldex_wallet->balance();
    }
    return 0;
}

+ (NSString *)displayAmount:(uint64_t)amount {
    string amountStr = Wallet::Wallet::displayAmount(amount);
    return objc_str_dup(amountStr);
}

+ (NSString *)generatePaymentId {
    string payment_id = Wallet::Wallet::genPaymentId();
    return objc_str_dup(payment_id);
}

+ (NSString *)paymentIdFromAddress:(NSString *)address {
    string utf8Address = [address UTF8String];
    string payment_id = Wallet::Wallet::paymentIdFromAddress(utf8Address, netType);
    return objc_str_dup(payment_id);
}

- (BOOL)setNewPassword:(NSString *)password {
    if (beldex_wallet) {
        return beldex_wallet->setPassword([password UTF8String]);
    }
    return NO;
}
- (NSString *)generateIntegartedAddress:(NSString *)paymentId {
    string integratedAddress = "";
    if (beldex_wallet) {
        integratedAddress = beldex_wallet->integratedAddress([paymentId UTF8String]);
    }
    return objc_str_dup(integratedAddress);
}

#pragma mark - SubAddress

- (BOOL)addSubAddress:(NSString *)label accountIndex:(uint32_t)index {
    if (beldex_wallet) {
        beldex_wallet->addSubaddress(index, [label UTF8String]);
        return YES;
    }
    return NO;
}
- (BOOL)setSubAddress:(NSString *)label addressIndex:(uint32_t)addressIndex accountIndex:(uint32_t)accountIndex {
    if (beldex_wallet) {
        beldex_wallet->setSubaddressLabel(accountIndex, addressIndex, [label UTF8String]);
        return YES;
    }
    return NO;
}
@end
