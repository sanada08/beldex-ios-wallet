//
//  ImportWalletViewController.swift
//  beldex-ios-wallet
//
//  Created by Mac on 6/2/22.
//


// eldest jogger potato greater erase nail mural western kangaroo alchemy touchy kettle absorb saved virtual kennel hold biology bawled kernels yellow misery swagger tirade tirade

import UIKit

class ImportWalletViewController: UIViewController {

    @IBOutlet weak var txtseed:UITextView!
    
    private let data = NewWallet()
    
    private var recovery_seed = RecoverWallet(from: .seed)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        
    }
    
    @IBAction func BackAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func importAction(sender:UIButton){
        self.createWallet(recover: recovery_seed)
    }
    
    func createWallet(recover:RecoverWallet)  {
        let seedvalue = txtseed.text
        print("---seedvalue----> \(seedvalue!)")
        UserDefaults.standard.set(seedvalue, forKey: "Key")
        
        recovery_seed.seed = seedvalue
        
//        recover.seed = seedvalue
      //  recover.seed = ""

        
        WalletService.shared.createWallet(with: .recovery(data: data, recover: recover)) { (result) in
         
                switch result {
                case .success(let wallet):
                    print("sucecs in import")
                    print("wallet ---> \(wallet.publicAddress)")
                case .failure(_):
                    print("faile in import")
                }
            }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
