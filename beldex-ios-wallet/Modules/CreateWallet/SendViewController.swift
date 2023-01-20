//
//  SendViewController.swift
//  beldex-ios-wallet
//
//  Created by Blockhash on 15/12/22.
//

import UIKit

class SendViewController: UIViewController {
    
    @IBOutlet weak var txtaddress:UITextField!
    @IBOutlet weak var txtamount:UITextField!
    
    private var isAllin: Bool = false
  //  private let wallet: BDXWallet
    private var wallet: BDXWallet?
    private var paymentId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func BackAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    // Reconnect work
    @IBAction func Send_Action(sender:UIButton){
        print("===================> \(txtaddress.text!)")
        print("===================> \(txtamount.text!)")
        
        guard BeldexWalletWrapper.validAddress(txtaddress.text!) else {
            print("===================> Address Format Error")
            return
        }
        
        DispatchQueue.global().async {
            let success: Bool
            if self.isAllin {
                success = self.wallet!.createSweepTransaction(self.txtaddress.text!, paymentId: "")
            } else {
                success = self.wallet!.createPendingTransaction(self.txtaddress.text!, paymentId: "", amount:self.txtamount.text!)
            }
            DispatchQueue.main.async {
              //  HUD.hideHUD()
                guard success else {
                    var errMsg = self.wallet!.commitPendingTransactionError()
                    if errMsg.count == 0 {
                        errMsg = LocalizedString(key: "send.create.failure", comment: "")
                    }
                    print("========errMsg===========> \(errMsg)")
                    return
                }
               // finish?()
            }
        }
    }

   

}
