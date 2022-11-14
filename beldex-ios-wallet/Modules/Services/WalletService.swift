//
//  WalletService.swift


import Foundation

public enum WalletError: Error {
    case noWalletName
    case noSeed
    case createFailed
    case openFailed
}

class WalletService {
    
    typealias GetWalletHandler = (Result<BDXWallet, WalletError>) -> Void
    
    // MARK: - Properties (static)
    
    static let shared = { WalletService() }()
    
    public func createWallet(with style: CreateWalletStyle, result: GetWalletHandler?) {
        var result_wallet: BDXWallet!
        switch style {
        case .new(let data):
            result_wallet = BDXWalletBuilder(name: data.name, password: data.pwd).fromScratch().generate()
            
            if result_wallet != nil {
//                print("walletName ==> \(result_wallet.walletName)")
//                print("publicAddress ==> \(result_wallet.publicAddress)")
                let WalletSeed = result_wallet.seed!
//                print("Seed sentence ==> \(WalletSeed.sentence)")
                
                UserDefaults.standard.set(result_wallet.publicAddress, forKey: "WalletpublicAddress")
                UserDefaults.standard.set(WalletSeed.sentence, forKey: "WalletSeed")
            }else {
                
            }
        case .recovery(let data, let recover):
            switch recover.from {
            case .seed:
                let seedvaluedefault = UserDefaults.standard.string(forKey: "helloKey")
                if let seedStr = seedvaluedefault, let seed = Seed.init(sentence: seedStr) {
                    
                    result_wallet = BDXWalletBuilder(name: data.name, password: data.pwd).fromSeed(seed).generate()
                    
                    if result_wallet != nil {
//                        print("walletName ==> \(result_wallet.walletName)")
//                        print("Recovery Seed Address publicAddress ==> \(result_wallet.publicAddress)")
                        
                        let WalletSeed = result_wallet.seed!
                      //  print("Wallet publicAddress ==> \(result_wallet.publicAddress)")
                        
                        UserDefaults.standard.set(result_wallet.publicAddress, forKey: "WalletpublicAddress")
                        UserDefaults.standard.set(WalletSeed.sentence, forKey: "WalletSeed")
                    }else {
                        
                    }
                }
            case .keys:
                print("case Keys")
                
            }
        }
    }
}
