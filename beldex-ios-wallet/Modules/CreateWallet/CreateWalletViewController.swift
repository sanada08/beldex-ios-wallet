//
//  AddWalletViewController.swift
//  beldex-ios-wallet
//
//  Created by sanada yukimura on 6/2/22.
//

import UIKit

class CreateWalletViewController: UIViewController {
    
    @IBOutlet weak var name:UITextField!
    @IBOutlet weak var pwd:UITextField!
    @IBOutlet weak var lblseed:UILabel!
    @IBOutlet weak var lbladdress:UILabel!
    @IBOutlet weak var lblsync:UILabel!
    
    
    private var data = NewWallet()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    
    @IBAction func BackAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createWalletAction(sender:UIButton){
        data.name = name.text!
       // data.pwd = pwd.text!
        WalletService.shared.createWallet(with: .new(data: data)) { (result) in
            switch result {
            case .success(let wallet):
                let seed = wallet.seed
                print("------seed---- \(seed!)")
            case .failure(_):
                print("in case failyre")
            }
        }
        let WalletpublicAddress = UserDefaults.standard.string(forKey: "WalletpublicAddress")
        let WalletSeed = UserDefaults.standard.string(forKey: "WalletSeed")
        print("--Wallet-publicAddress--> \(WalletpublicAddress!)")
        print("--Wallet-Seed--> \(WalletSeed!)")
        self.lbladdress.text = WalletpublicAddress!
        self.lblseed.text = WalletSeed!
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WalletDetailsViewController") as! WalletDetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
