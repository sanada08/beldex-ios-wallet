//
//  AddWalletViewController.swift
//  beldex-ios-wallet
//
//  Created by Mac on 6/2/22.
//

import UIKit

class AddWalletViewController: UIViewController {
    
    @IBOutlet weak var name:UITextField!
    @IBOutlet weak var pwd:UITextField!
    
    
    private var data = NewWallet()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func BackAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createWalletAction(sender:UIButton){
        
        
        data.name = name.text!
        data.pwd = pwd.text!
        
        WalletService.shared.createWallet(with: .new(data: data)) { (result) in
           print("------createWalletresult------ \(result)")
            switch result {
            case .success(let wallet):
                print("------resul.successt----> \(result)")
                print("------result.publicsh----> \(result.publisher)")
                print("----wallet-----> \(wallet)")

                let seed = wallet.seed
                print("------seed---- \(seed!)")
                
            case .failure(_):
                print("in case failyre")
            }
        }
        
    }

}
