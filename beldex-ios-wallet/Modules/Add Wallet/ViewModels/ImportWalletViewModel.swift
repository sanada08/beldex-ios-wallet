//
//  ImportWalletViewModel.swift
//  beldex-ios-wallet
//
//  Created by Mac on 6/2/22.
//

import UIKit

class ImportWalletViewModel: NSObject {
    
    private let data: NewWallet
    private var recovery_seed = RecoverWallet(from: .seed)
    
    init(data: NewWallet) {
        self.data = data
        super.init()
    }
    
    public func seedInput(text: String) {
        recovery_seed.seed = text
    }

}
