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
              //  print("----data-----> \(data)")
                
                result_wallet = BDXWalletBuilder(name: data.name, password: data.pwd).fromScratch().generate()
              //  print("----result_wallet-----::::::> \(result_wallet)")
               // let wallet = result_wallet
            
                print("result wallet . walletnae ---->", result_wallet.walletName)
                print("result wallet . publicaddress ---->", result_wallet.publicAddress)
                print("result_wallet . seed ----->", result_wallet.seed!)
            print("result_wallet . sentence ----->", result_wallet.seed?.sentence)
            print("publicviewkey --->\(result_wallet.publicViewKey)")
            print("secretViewKey --->\(result_wallet.secretViewKey)")
            print("publicSpentKey -->\(result_wallet.publicSpendKey)")
            print("secretSpentKey -->\(result_wallet.secretSpendKey)")
            
            
            case .recovery(let data, let recover):
            print(":insdie recovery-------> \(recover) <><><> \(data)")
                switch recover.from {
                case .seed:
                    
                let seedvaluedefault = UserDefaults.standard.string(forKey: "Key")
                    print("-=-=-=-- \(seedvaluedefault!)")
                    
                    print("----data-----> \(data)")
                    print("----recover-----> \(recover)")
                    
                    if let seedStr = seedvaluedefault, let seed = Seed.init(sentence: seedStr)
                    {
                        print("-------> seed ::: \(seed)")
                        result_wallet = BDXWalletBuilder(name: data.name, password: data.pwd).fromSeed(seed).generate()
                        
                        
                        
                        
                        print("seedstr --->\(seedStr)")
                        print("name --->\(result_wallet?.walletName)")
                        print(" address----> \(result_wallet?.publicAddress)")
                        print("recoverseed ----->\(result_wallet?.seed)")
//                        print("publicviewkey --->\(result_wallet.publicViewKey)")
//                        print("secretViewKey --->\(result_wallet.secretViewKey)")
//                        print("publicSpentKey -->\(result_wallet.publicSpendKey)")
//                        print("secretSpentKey -->\(result_wallet.secretSpendKey)")
                }
                case .keys:
                    print("case Keys")
                    
            }
        }
    }
}



//["fatal", "pulp", "soprano", "pioneer", "major", "malady", "rowboat", "unmask", "agnostic", "listen", "amidst", "lumber", "nomad", "vivid", "slackens", "mesh", "gopher", "diet", "jaded", "upgrade", "shackles", "nodes", "lava", "lawsuit", "agnostic"]
