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
    
    public func recoveryFromSeed() {
        self.alertWarningIfNeed(recovery_seed)
    }
    
    private func alertWarningIfNeed(_ recover: RecoverWallet) {
        guard recover.date == nil &&
                recover.block == nil
        else {
            self.createWallet(recover)
            return
        }
        
        //        let alert = UIAlertController(title: LocalizedString(key: "wallet.import.blockTips.msg", comment: ""),
        //                                      message: "",
        //                                      preferredStyle: .alert)
        //
        //        let cancelAction = UIAlertAction(title: LocalizedString(key: "wallet.import.blockTips.cancel", comment: ""), style: .cancel, handler: nil)
        //
        //        let confirmAction = UIAlertAction(title: LocalizedString(key: "wallet.import.blockTips.confirm", comment: ""), style: .destructive) {
        //        [unowned self] (_) in
        //            self.createWallet(recover)
        //        }
        //
        //        alert.addAction(confirmAction)
        //        alert.addAction(cancelAction)
        
        //        showAlertState.newState(alert)
    }
    
    func createWallet(_ recover : RecoverWallet){
        print("in create wallet function")
    }
    
}
