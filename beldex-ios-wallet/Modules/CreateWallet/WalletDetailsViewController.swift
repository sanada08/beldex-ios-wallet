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
    @IBOutlet weak var lblname:UILabel!
    
    lazy var sendState = { return Observable<Bool>(false) }()
    lazy var reciveState = { return Observable<Bool>(false) }()
    lazy var refreshState = { return Observable<Bool>(false) }()
    lazy var conncetingState = { return Observable<Bool>(false) }()
    
    // MARK: - Properties (Private)
    
//    private let pwd: String
//    private let asset: Assets
//    private let token: TokenWallet
//    private var wallet: BDXWallet?
    
    
//    var pwd: String = ""
//    var asset: Assets
//    var token: TokenWallet
//    var wallet: BDXWallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let WalletpublicAddress = UserDefaults.standard.string(forKey: "WalletpublicAddress")
        let WalletName = UserDefaults.standard.string(forKey: "WalletName")
        self.lbladdress.text = WalletpublicAddress!
        self.lblnode.text = "\(WalletDefaults.shared.node)"
        self.lblname.text = WalletName!
        
        //Node Connect Process
       // init_wallet()
        
    }
    
    @IBAction func BackAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
   
//    func init_wallet() {
//        sendState.value = false
//        reciveState.value = false
//        conncetingState.value = true
//        lblsync.text = LocalizedString(key: "Connecting, it may take 5 minutes", comment: "")
//        WalletService.shared.openWallet(token.label, password: pwd) { [weak self] (result) in
//            DispatchQueue.main.async {
//                guard let strongSelf = self else { return }
//                switch result {
//                case .success(let wallet):
//                    strongSelf.wallet = wallet
//                    strongSelf.connect(wallet: wallet)
//                case .failure(_):
//                    strongSelf.refreshState.value = true
//                    strongSelf.conncetingState.value = false
//                    strongSelf.lblsync.text = LocalizedString(key: "Failed to Connect", comment: "")
//                }
//            }
//        }
//        loadHistoryFromDB()
//    }
    
//    func connect(wallet: BDXWallet) {
//
//    }
//
//    func loadHistoryFromDB() {
//
//    }
    

}
