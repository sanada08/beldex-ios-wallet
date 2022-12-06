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
    @IBOutlet var progressView: UIProgressView!
    
    
    private var address: String = "9u98r2oSvnZ6FZSrfF4YqiejPXVsT4bBPiSm9UcpaEKvdDigDThHWKYYgLz6p36amZ6BPwBnn1gL7B5ZmL6gkKeQ548hnx4"
    private var amount: String = "10"
    private var paymentId: String = ""
    
    private var sendValid: Bool {
        return address.count > 0 && amount.count > 0
    }
    
//    private var isAllin: Bool = false
    
    lazy var statusTextState = { return Observable<String>("") }()
    lazy var sendState = { return Observable<Bool>(false) }()
    lazy var reciveState = { return Observable<Bool>(false) }()
    lazy var refreshState = { return Observable<Bool>(false) }()
    lazy var conncetingState = { return Observable<Bool>(false) }()
    
    private var connecting: Bool { return conncetingState.value}
    private var currentBlockChainHeight: UInt64 = 0
    private var daemonBlockChainHeight: UInt64 = 0
    private var needSynchronized = false {
        didSet {
            guard needSynchronized, !oldValue,
                let wallet = self.wallet else { return }
            wallet.saveOnTerminate()
        }
    }
    private lazy var taskQueue = DispatchQueue(label: "beldex.wallet.task")
    lazy var progressState = { return Observable<CGFloat>(0) }()
    // MARK: - Properties (Private)
    
//    private let pwd: String
//    private let asset: Assets
 //   private let token = TokenWallet()
    private var wallet: BDXWallet?

    private var listening = false
    private var isSyncingUI = false {
        didSet {
            guard oldValue != isSyncingUI else { return }
            if isSyncingUI {
                RunLoop.main.add(timer, forMode: .common)
            } else {
                timer.invalidate()
            }
        }
    }
    private lazy var timer: Timer = {
        Timer.init(timeInterval: 0.5, repeats: true) { [weak self] (_) in
            guard let `self` = self else { return }
            self.updateSyncingProgress()
        }
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let WalletpublicAddress = UserDefaults.standard.string(forKey: "WalletpublicAddress")
        let WalletName = UserDefaults.standard.string(forKey: "WalletName")
        self.lbladdress.text = WalletpublicAddress!
        self.lblnode.text = "\(WalletDefaults.shared.node)"
        if WalletName != nil {
            self.lblname.text = WalletName!
        }
        
        //Node Connect Process
        init_wallet()
        
        
    }
    
    @IBAction func BackAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func SendAction(sender:UIButton){
        guard BeldexWalletWrapper.validAddress(address) else {
//            HUD.showError(LocalizedString(key: "address.validate.fail", comment: ""))
            return
        }
//        HUD.showHUD()
        DispatchQueue.global().async {
//            let success: Bool
//            if self.isAllin {
//                success = self.wallet.createSweepTransaction(self.address, paymentId: self.paymentId)
//            } else {
            var success = ((self.wallet?.createPendingTransaction(self.address, amount: self.amount)) != nil)
            print("success ----> ", success)
//            }
//            DispatchQueue.main.async {
////                HUD.hideHUD()
            if success {
                   let commit_success = self.wallet?.commitPendingTransaction()
                if commit_success == true {
                    self.wallet?.disposeTransaction()}
                }
//                if commit_success {
                   
                    
//                    if errMsg.count == 0 {
//                        errMsg = LocalizedString(key: "send.create.failure", comment: "")
//                    }
//                    HUD.showError(errMsg)
                    return
                }
//                finish?()
//            }
//        }
        
        
    }
    
   
    func init_wallet() {
        sendState.value = false
        reciveState.value = false
        conncetingState.value = true
        lblsync.text = LocalizedString(key: "Connecting, it may take 5 minutes", comment: "Connecting, it may take 5 minutes")
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
                    strongSelf.lblsync.text = LocalizedString(key: "Failed to Connect", comment: "Failed to Connect")
                }
            }
        }
        loadHistoryFromDB()
    }
    
    func connect(wallet: BDXWallet) {
        print("inside connect >>>>>>>>>>>\n")
        print("---Node--->\(WalletDefaults.shared.node)")
        self.reciveState.value = true
        if !connecting {
            self.conncetingState.value = true
            lblsync.text = LocalizedString(key: "Connecting, it may take 5 minutes", comment: "Connecting, it may take 5 minutes")
        }
        wallet.connectToDaemon(address: WalletDefaults.shared.node, delegate: self) { [weak self] (isConnected) in
            guard let `self` = self else { return }
            if isConnected {
                if let wallet = self.wallet {
                    let WalletRestoreHeight = UserDefaults.standard.string(forKey: "WalletRestoreHeight")
                    if let restoreHeight = WalletRestoreHeight{
                        wallet.restoreHeight = UInt64(restoreHeight)!
                    }
                    wallet.start()
                }
                self.listening = true
            } else {
                DispatchQueue.main.async {
                    self.lblsync.text = LocalizedString(key: "Failed to Connect", comment: "Failed to Connect")
                    self.conncetingState.value = false
                    self.refreshState.value = true
                    self.listening = false
                }
            }
        }
    }

    func loadHistoryFromDB() {

    }
    
    private func updateSyncingProgress() {
        taskQueue.async {
            let (current, total) = (self.currentBlockChainHeight, self.daemonBlockChainHeight)
            guard total != current else { return }
            let difference = total.subtractingReportingOverflow(current)
            var progress = CGFloat(current) / CGFloat(total)
            let leftBlocks: String
            if difference.overflow || difference.partialValue <= 1 {
                leftBlocks = "1"
                progress = 1
            } else {
                leftBlocks = String(difference.partialValue)
            }
            
            let statusText = LocalizedString(key: "Syncing, blocks remaining:", comment: "Syncing, blocks remaining:") + leftBlocks
            DispatchQueue.main.async {
                if self.conncetingState.value {
                    self.conncetingState.value = false
                }
                //sree536
              //  self.progressState.update(progress)
              //  self.statusTextState.update(statusText)
                self.progressView.progress = Float(progress)
                self.lblsync.text = statusText
            }
        }
    }
    
    private func synchronizedUI() {
        //progressState.value = 1
        progressView.progress = 1
        sendState.value = true
        self.lblsync.text = LocalizedString(key: "Synced", comment: "Synced")
    }
    

}


extension WalletDetailsViewController: BeldexWalletDelegate {
    func beldexWalletRefreshed(_ wallet: BeldexWalletWrapper) {
        dPrint("Refreshed---------->blockChainHeight-->\(wallet.blockChainHeight) ---------->daemonBlockChainHeight-->, \(wallet.daemonBlockChainHeight)")
        self.isSyncingUI = false
        if self.needSynchronized {
            self.needSynchronized = !wallet.save()
        }
        taskQueue.async {
            guard let wallet = self.wallet else { return }
            let (balance, history) = (wallet.balance, wallet.history)
            print("---------->Balance: \(balance),---------->History: \(history)")
            //sree536
//            self.storeToDB(balance: balance, history: history)
            self.postData(balance: balance, history: history)
        }
        if daemonBlockChainHeight != 0 {
            /// 计算节点区块高度是否与钱包刷新回调的一致，不一致则表示并非同步完成
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
        dPrint("-----------currentHeight ----> \(currentHeight)---DaemonBlockHeight---->\(wallet.daemonBlockChainHeight)")
        self.currentBlockChainHeight = currentHeight
        self.daemonBlockChainHeight = wallet.daemonBlockChainHeight
        self.needSynchronized = true
        self.isSyncingUI = true
    }
    
    private func postData(balance: String, history: TransactionHistory) {
        let balance_modify = Helper.displayDigitsAmount(balance)
        print("---------->balance_modify \(balance_modify)")
        print("---------->All Transation list----------> \(history.all)")
        print("---------->Send list----------> \(history.send)")
        print("---------->Recive list----------> \(history.receive)")
//        /// 数据转换
//        let itemMapToRow = { (item: TransactionItem) -> TableViewRow in
//            let model = Transaction.init(item: item)
//            var row = TransactionListCellFrame.toTableViewRow(model)
//            row.didSelectedAction = {
//                [unowned self] _ in
//                self.pushToTransaction(model)
//            }
//            return row
//        }
//
//        let allData = [TableViewSection(history.all.map(itemMapToRow))]
//        let receiveData = [TableViewSection(history.receive.map(itemMapToRow))]
//        let sendData = [TableViewSection(history.send.map(itemMapToRow))]
//
//        DispatchQueue.main.async {
//            self.balanceState.value = balance_modify
//            self.historyState.newState([allData, receiveData, sendData])
//        }
    }
    
}
