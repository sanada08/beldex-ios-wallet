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
        DispatchQueuePool.shared["XMRWallet:new"].async {
            var result_wallet: BDXWallet!
            switch style {
            case .new(let data):
                print("name----->\(data.name)")
                result_wallet = BDXWalletBuilder(name: data.name, password: data.pwd).fromScratch().generate()
                if result_wallet != nil {
                    let WalletSeed = result_wallet.seed!
                    UserDefaults.standard.set(result_wallet.publicAddress, forKey: "WalletpublicAddress")
                    UserDefaults.standard.set(WalletSeed.sentence, forKey: "WalletSeed")
                    UserDefaults.standard.set(result_wallet.walletName, forKey: "WalletName")
                } else {
                    
                }
            case .recovery(let data, let recover):
                switch recover.from {
                case .seed:
                    let seedvaluedefault = UserDefaults.standard.string(forKey: "helloKey")
                    if let seedStr = seedvaluedefault, let seed = Seed.init(sentence: seedStr) {
                        result_wallet = BDXWalletBuilder(name: data.name, password: data.pwd).fromSeed(seed).generate()
                        if result_wallet != nil {
                            print("Height ==> \(result_wallet.blockChainHeight)")
                            let WalletSeed = result_wallet.seed!
                            UserDefaults.standard.set(result_wallet.publicAddress, forKey: "WalletpublicAddress")
                            UserDefaults.standard.set(WalletSeed.sentence, forKey: "WalletSeed")
                            UserDefaults.standard.set(result_wallet.walletName, forKey: "WalletName")
                        } else {
                            
                        }
                    }
                case .keys:
                    print("case Keys")
                }
            }
        }
    }
    
    
    
    public func openWallet(_ name: String, password: String, result: GetWalletHandler?) {
        DispatchQueuePool.shared["BDXWallet:" + name].async {
            if let wallet = BDXWalletBuilder(name: name, password: password).openExisting() {
                result?(.success(wallet))
            } else {
                result?(.failure(.openFailed))
            }
        }
    }
    
    
}
