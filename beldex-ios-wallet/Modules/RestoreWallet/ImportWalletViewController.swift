//
//  ImportWalletViewController.swift
//  beldex-ios-wallet
//
//  Created by Mac on 6/2/22.
//


// eldest jogger potato greater erase nail mural western kangaroo alchemy touchy kettle absorb saved virtual kennel hold biology bawled kernels yellow misery swagger tirade tirade

import UIKit
import Foundation

class ImportWalletViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var txtseed:UITextView!
    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var txtHeight:UITextField!
    
    private var data = NewWallet()
    private var recovery_seed = RecoverWallet(from: .seed)
    
    
    // MARK: - Life Cycles
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        txtseed.delegate = self
        txtseed.text = "spout cobra moisture wallets hippo academy tawny ulcers mammal tudor jive reunion buckets lids react kidneys geometry claim vipers zodiac ignore gnome silk stacking kidneys"
//        txtName.text = "eedd"
//        txtHeight.text = "7563"
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    // MARK: General
    @objc private func dismissKeyboard() {
        txtseed.resignFirstResponder()
    }
   
    
    @IBAction func BackAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func importAction(sender:UIButton){
        self.createWallet(recover: recovery_seed)
    }
  
    func createWallet(recover:RecoverWallet)  {
        let seedvalue = txtseed.text!.lowercased()
        UserDefaults.standard.set(seedvalue, forKey: "helloKey")
        recovery_seed.seed = seedvalue
        recovery_seed.block = txtHeight.text!
        data.name = txtName.text!
//        data.pwd = ""
        WalletService.shared.createWallet(with: .recovery(data: data, recover: recover)) { (result) in
            switch result {
            case .success(let wallet):
                wallet.close()
                print("sucecs in import")
                print("wallet ---> \(wallet.publicAddress)")
            case .failure(_):
                print("faile in import")
            }
        }
        let WalletpublicAddress = UserDefaults.standard.string(forKey: "WalletpublicAddress")
        let WalletSeed = UserDefaults.standard.string(forKey: "WalletSeed")
        let WalletName = UserDefaults.standard.string(forKey: "WalletName")
        print("--Wallet-publicAddress--> \(WalletpublicAddress!)")
        print("--Wallet-Seed--> \(WalletSeed!)")
        print("--Wallet-Name--> \(WalletName!)")
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WalletDetailsViewController") as! WalletDetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
