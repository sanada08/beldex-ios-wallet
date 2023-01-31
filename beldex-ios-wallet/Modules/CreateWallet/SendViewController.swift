//
//  SendViewController.swift
//  beldex-ios-wallet
//
//

import UIKit

class SendViewController: UIViewController {
    
    @IBOutlet weak var txtaddress:UITextField!
    @IBOutlet weak var txtamount:UITextField!
    
    // MARK: - Life Cycle
    private var wallet: BDXWallet?
    private lazy var taskQueue = DispatchQueue(label: "beldex.wallet.task")
    private var currentBlockChainHeight: UInt64 = 0
    private var daemonBlockChainHeight: UInt64 = 0
    lazy var conncetingState = { return Observable<Bool>(false) }()
    private var needSynchronized = false {
        didSet {
            guard needSynchronized, !oldValue,
                let wallet = self.wallet else { return }
            wallet.saveOnTerminate()
        }
    }
    var sendflag = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtaddress.text = "9u98r2oSvnZ6FZSrfF4YqiejPXVsT4bBPiSm9UcpaEKvdDigDThHWKYYgLz6p36amZ6BPwBnn1gL7B5ZmL6gkKeQ548hnx4"
        //Node Connect Process
        sendflag = false
        sendTransation_wallet()
        
        
    }
    
    @IBAction func BackAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Send_Action(sender:UIButton){
        sendflag = true
        guard BeldexWalletWrapper.validAddress(txtaddress.text!) else {
            let alert = UIAlertController(title: "My Title", message: "Address Format Error", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if txtamount.text?.count == 0 {
            let alert = UIAlertController(title: "My Title", message: "Pls Enter amount", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else {
            sendTransation_wallet()
        }
    }
    
    
    func sendTransation_wallet() {
        WalletService.shared.openWallet("\(UserDefaults.standard.string(forKey: "WalletName")!)", password: "") { [weak self] (result) in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(let wallet):
                    strongSelf.wallet = wallet
                    strongSelf.connect(wallet: wallet)
                case .failure(_):
                    print("===================> Failed to Connect")
                }
            }
        }
    }
    func connect(wallet: BDXWallet) {
        print("---Node--->\(WalletDefaults.shared.node)")
        wallet.connectToDaemon(address: "38.242.196.72:19095", delegate: self) { [weak self] (isConnected) in
            guard let `self` = self else { return }
            if isConnected {
                if let wallet = self.wallet {
                    let WalletRestoreHeight = UserDefaults.standard.string(forKey: "WalletRestoreHeight")
                    if let restoreHeight = WalletRestoreHeight{
                        wallet.restoreHeight = UInt64(restoreHeight) ?? 0
                    }
                    wallet.start()
                }
            } else {
                DispatchQueue.main.async {
                    print("===================> Failed to Connect")
                }
            }
        }
        if sendflag == true{
           // HUD.showHUD()
            DispatchQueue.global().async {
                let createPendingTransaction = wallet.createPendingTransaction(self.txtaddress.text!, paymentId: "", amount: self.txtamount.text!)
                print("---createPendingTransaction result----> \(createPendingTransaction)")
                let commitPendingTransaction = wallet.commitPendingTransaction()
                print("---commitPendingTransaction result----\(commitPendingTransaction)")
                DispatchQueue.main.async {
                   // HUD.hideHUD()
                    if createPendingTransaction == true {
                        if commitPendingTransaction == true {
                            print("Send Successfully")
                            let alert = UIAlertController(title: "My Title", message: "Send Successfully", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else {
                        var errMsg = wallet.commitPendingTransactionError()
                        if errMsg.count == 0 {
                            print("Failed to Package")
                            let alert = UIAlertController(title: "My Title", message: "Failed to Package", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }else {
            
        }
    }
    
    private func synchronizedUI() {
        print("===================> Synced")
       // self.lblsync.text = LocalizedString(key: "Synced", comment: "Synced")
    }
    
    
}
    
  

extension SendViewController: BeldexWalletDelegate {
    func beldexWalletRefreshed(_ wallet: BeldexWalletWrapper) {
//        dPrint("Refreshed---------->blockChainHeight-->\(wallet.blockChainHeight) ---------->daemonBlockChainHeight-->, \(wallet.daemonBlockChainHeight)")
        if self.needSynchronized {
            self.needSynchronized = !wallet.save()
        }
        taskQueue.async {
            guard let wallet = self.wallet else { return }
            let (balance, history) = (wallet.balance, wallet.history)
            self.postData(balance: balance, history: history)
        }
        if daemonBlockChainHeight != 0 {
            let difference = wallet.daemonBlockChainHeight.subtractingReportingOverflow(daemonBlockChainHeight)
            guard !difference.overflow else { return }
        }
        DispatchQueue.main.async {
            if self.conncetingState.value {
                self.conncetingState.value = false
            }
            self.synchronizedUI()
        }
    }
    func beldexWalletNewBlock(_ wallet: BeldexWalletWrapper, currentHeight: UInt64) {
//        dPrint("-----------currentHeight ----> \(currentHeight)---DaemonBlockHeight---->\(wallet.daemonBlockChainHeight)")
        self.currentBlockChainHeight = currentHeight
        self.daemonBlockChainHeight = wallet.daemonBlockChainHeight
    }
    
    private func postData(balance: String, history: TransactionHistory) {
        let balance_modify = Helper.displayDigitsAmount(balance)
        print("---------->balance_modify \(balance_modify)")
        print("---------->All Transation list----------> \(history.all)")
        print("---------->Send list----------> \(history.send)")
        print("---------->Recive list----------> \(history.receive)")
        print("---------->Send list count----------> \(history.send.count)")
        DispatchQueue.main.async {
          //  self.lblbalance.text = balance_modify
        }
    }
    
}
