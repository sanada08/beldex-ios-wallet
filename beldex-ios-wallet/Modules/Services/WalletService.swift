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
        var result_wallet: BDXWallet?
        switch style {
            case .new(let data):
                print("----data-----> \(data)")
                
                result_wallet = BDXWalletBuilder(name: data.name, password: data.pwd).fromScratch().generate()
            
                
                
                print("----result_wallet-----::::::> \(result_wallet)")
            }
        let wallet = result_wallet
        print("result wallet . walletnae ---->", wallet?.walletName)
        print("result wallet . publicaddress ---->", wallet?.publicAddress)
        print("result_wallet . seed ----->", wallet?.seed)
    }
    
}
