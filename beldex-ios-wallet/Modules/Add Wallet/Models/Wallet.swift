//
//  Wallet.swift


import Foundation

public enum CreateWalletStyle {
    case new(data: NewWallet)
}

public struct NewWallet {
    var name: String = ""
    var pwd: String = ""
    var pwdTips: String?
    
    static var empty: NewWallet {
        return NewWallet()
    }
}
