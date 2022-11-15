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
    
    lazy var statusTextState = { return Observable<String>("") }()
    lazy var sendState = { return Observable<Bool>(false) }()
    lazy var reciveState = { return Observable<Bool>(false) }()
    lazy var refreshState = { return Observable<Bool>(false) }()
    lazy var conncetingState = { return Observable<Bool>(false) }()
    
    private var connecting: Bool { return conncetingState.value}
    
    // MARK: - Properties (Private)
    
//    private let pwd: String
//    private let asset: Assets
    private let token = TokenWallet()
    private var wallet: BDXWallet?

    private var listening = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let WalletpublicAddress = UserDefaults.standard.string(forKey: "WalletpublicAddress")
        let WalletName = UserDefaults.standard.string(forKey: "WalletName")
        self.lbladdress.text = WalletpublicAddress!
        self.lblnode.text = "\(WalletDefaults.shared.node)"
        self.lblname.text = WalletName!
        
        //Node Connect Process
        init_wallet()
        
    }
    
    @IBAction func BackAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
   
    func init_wallet() {
        sendState.value = false
        reciveState.value = false
        conncetingState.value = true
        lblsync.text = LocalizedString(key: "Connecting, it may take 5 minutes", comment: "")
        WalletService.shared.openWallet("\(UserDefaults.standard.string(forKey: "WalletName")!)", password: "") { [weak self] (result) in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(let wallet):
                    strongSelf.wallet = wallet
                    strongSelf.connect(wallet: wallet)
                case .failure(_):
                    strongSelf.refreshState.value = true
                    strongSelf.conncetingState.value = false
                    strongSelf.lblsync.text = LocalizedString(key: "Failed to Connect", comment: "")
                }
            }
        }
        loadHistoryFromDB()
    }
    
    func connect(wallet: BDXWallet) {
        print("inside connect >>>>>>>>>>>\n")
        self.reciveState.value = true
        if !connecting {
            self.conncetingState.value = true
            self.statusTextState.value = LocalizedString(key: "assets.connect.ing", comment: "")
        }
        print("-----> \(WalletDefaults.shared.node)")
        wallet.connectToDaemon(address: WalletDefaults.shared.node) { [weak self] (isConnected) in
            guard let `self` = self else { return }
            if isConnected {
                if let wallet = self.wallet {
                    if let restoreHeight = self.token.restoreHeight {
                        wallet.restoreHeight = restoreHeight
                    }
                    wallet.start()
                }
                self.listening = true
            } else {
                DispatchQueue.main.async {
                    self.statusTextState.value = LocalizedString(key: "assets.connect.failure", comment: "")
                    self.conncetingState.value = false
                    self.refreshState.value = true
                    self.listening = false
                }
            }
        }

    }

    func loadHistoryFromDB() {

    }
    

}
