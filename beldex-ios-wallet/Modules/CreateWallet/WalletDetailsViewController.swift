//
//  WalletDetailsViewController.swift
//  beldex-ios-wallet
//
//  Created by San on 11/14/22.
//

import UIKit

class WalletDetailsViewController: UIViewController {
    
    @IBOutlet weak var lbladdress:UILabel!
    @IBOutlet weak var lblnode:UILabel!
    @IBOutlet weak var lblsync:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let WalletpublicAddress = UserDefaults.standard.string(forKey: "WalletpublicAddress")
        print("--Wallet-publicAddress--> \(WalletpublicAddress!)")
        
        self.lbladdress.text = WalletpublicAddress!
        self.lblnode.text = "\(WalletDefaults.shared.node)"
        
    }
    
    @IBAction func BackAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
   
    
    

}
