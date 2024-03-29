//
//  Common.swift


import Foundation

// MARK: - 

public enum Token: String {
    case xmr = "BDX"
    case dash = "Dash"
    case zcash = "Zcash"
    case eth = "ETH"
}

public enum WooKeyURL: String {
    
    case serviceBook = "https://wallet.beldex.io/service-docs/app.html"
    case moreNodes = "https://wallet.beldex.io/beldex-nodes/app.html"
    
    var url: URL {
        return URL(string: rawValue)!
    }
}
