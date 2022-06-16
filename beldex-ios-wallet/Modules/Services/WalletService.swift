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
            case .recovery(let data, let recover):
                switch recover.from {
                case .seed:
                    
                let seedvaluedefault = UserDefaults.standard.string(forKey: "Key")
                    if let seedStr = seedvaluedefault, let seed = Seed.init(sentence: seedStr)
                    {
                        result_wallet = BDXWalletBuilder(name: data.name, password: data.pwd).fromSeed(seed).generate()
                }
                case .keys:
                    print("case Keys")
                    
            }
        }
    }
}



//["fatal", "pulp", "soprano", "pioneer", "major", "malady", "rowboat", "unmask", "agnostic", "listen", "amidst", "lumber", "nomad", "vivid", "slackens", "mesh", "gopher", "diet", "jaded", "upgrade", "shackles", "nodes", "lava", "lawsuit", "agnostic"]
