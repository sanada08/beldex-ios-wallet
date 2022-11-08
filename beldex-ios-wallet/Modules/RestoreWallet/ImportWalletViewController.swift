//
//  ImportWalletViewController.swift
//  beldex-ios-wallet
//
//  Created by Mac on 6/2/22.
//


// eldest jogger potato greater erase nail mural western kangaroo alchemy touchy kettle absorb saved virtual kennel hold biology bawled kernels yellow misery swagger tirade tirade

import UIKit

class ImportWalletViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var txtseed:UITextView!
    
    private var data = NewWallet()
    private var recovery_seed = RecoverWallet(from: .seed)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        txtseed.delegate = self
        txtseed.text = "nineteen haunted tirade inkling cupcake tulips nimbly urgent moat haystack sixteen eden cistern agnostic waking puzzled items ripped symptoms ethics umbrella cucumber saxophone shipped eden"
        
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
        data.name = "dede"
//        data.pwd = ""
        WalletService.shared.createWallet(with: .recovery(data: data, recover: recover)) { (result) in
            switch result {
            case .success(let wallet):
                print("sucecs in import")
                print("wallet ---> \(wallet.publicAddress)")
            case .failure(_):
                print("faile in import")
            }
        }
        let WalletpublicAddress = UserDefaults.standard.string(forKey: "WalletpublicAddress")
        let WalletSeed = UserDefaults.standard.string(forKey: "WalletSeed")
        print("--Wallet-publicAddress--> \(WalletpublicAddress!)")
        print("--Wallet-Seed--> \(WalletSeed!)")
    }
    
    
    
    
    

}
