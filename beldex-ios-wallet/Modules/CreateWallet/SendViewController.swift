//
//  SendViewController.swift
//  beldex-ios-wallet
//
//  Created by Sanada on 15/12/22.
//

import UIKit

class SendViewController: UIViewController {
    
    @IBOutlet weak var txtaddress:UITextField!
    @IBOutlet weak var txtamount:UITextField!
    
    private var isAllin: Bool = false
  //  private let wallet: BDXWallet
   // private var wallet: BDXWallet
    private var paymentId: String = ""
    
    // MARK: - Properties (Private)
    
//    private let asset: Assets?
   // private let token: TokenWallet
    private var wallet: BDXWallet?
    
    
    private var address: String = ""
    private var amount: String = ""
  //  private var paymentId: String = ""
    
    private var sendValid: Bool {
        return address.count > 0 && amount.count > 0
    }
    
  //  private var isAllin: Bool = false
    
    
    // MARK: - Properties (Lazy)
    
    lazy var sendState = { return Observable<Bool>(false) }()
    lazy var addressState = { return Observable<String>("") }()
    lazy var amountState = { return Observable<String>("") }()
    lazy var paymentIdState = { return Observable<String>("") }()
    lazy var paymentIdLenState = { return Observable<String>("0/16") }()
    
    
    // MARK: - Life Cycle
    
//    init( wallet: BDXWallet) {
////        self.asset = asset
//     //   self.token = asset.wallet ?? TokenWallet()
//        self.wallet = wallet
//        super.init()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtaddress.text = "9u98r2oSvnZ6FZSrfF4YqiejPXVsT4bBPiSm9UcpaEKvdDigDThHWKYYgLz6p36amZ6BPwBnn1gL7B5ZmL6gkKeQ548hnx4"
        
        
    }
    
    @IBAction func BackAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    // Reconnect work
    @IBAction func Send_Action(sender:UIButton){
        print("===================> \(txtaddress.text!)")
        print("===================> \(txtamount.text!)")
        
        guard BeldexWalletWrapper.validAddress(txtaddress.text!) else {
            print("===================> Address Format Error")
            return
        }
    
        
        guard let wallet = self.wallet else { return }
            
        print (" dsfadfsda balance ------> \(wallet.daemonBlockChainHeight)")
        let success = tosend(wallet: wallet )
//        let success = wallet.createPendingTransaction(self.txtaddress.text!, paymentId: "", amount:self.txtamount.text!)
//        print("------------> \(success)")
//        } else {
//            print ("enside iesdjfjiasdjfas")
//        }
        
        
//        DispatchQueue.global().async {
//            let success: Bool
//            if self.isAllin {
//                success = self.wallet.createSweepTransaction(self.txtaddress.text!, paymentId: "")
//            } else {
//                success = self.wallet.createPendingTransaction(self.txtaddress.text!, paymentId: "", amount:self.txtamount.text!)
//            }
//            DispatchQueue.main.async {
//              //  HUD.hideHUD()
//                guard success else {
//                    var errMsg = self.wallet.commitPendingTransactionError()
//                    if errMsg.count == 0 {
//                        errMsg = LocalizedString(key: "send.create.failure", comment: "")
//                    }
//                    print("========errMsg===========> \(errMsg)")
//                    return
//                }
//               // finish?()
//            }
//        }
    }
    func tosend(wallet: BDXWallet){
        let success = wallet.createPendingTransaction(self.txtaddress.text!, paymentId: "", amount:self.txtamount.text!)
        print("------------> \(success)")
    }

   

}
