//
//  WelcomeVC.swift
//  beldex-ios-wallet
//
//  Created by sanada yukimura on 6/2/22.
//

import UIKit
import Alamofire

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func createWalletAction(sender:UIButton){
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateWalletViewController") as! CreateWalletViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func restoreWalletAction(sender:UIButton){
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImportWalletViewController") as! ImportWalletViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func NodeAction(sender:UIButton){
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NodeListViewController") as! NodeListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func TabBarAction(sender:UIButton){
        
    }
    @IBAction func CuurencyarAction(sender:UIButton){
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CurrencyViewController") as! CurrencyViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    @IBAction func Node_validation_Action(sender:UIButton){
           let startTime = CFAbsoluteTimeGetCurrent()
           let url = "http://62.112.10.116:19091/json_rpc"
           let param = ["jsonrpc": "2.0", "id": "0", "method": "getlastblockheader"]
           let dataTask = Session.default.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil)
           dataTask.responseJSON { (response) in
               print("--1--->\(response.result)")
               print("--2--->\(response.data)")
               print("---3-->\(response.value)")
               print("---4---->\(response.response)")
               print("---5--->\(response.request)")
               print("---6---->\(response.description)")
               if let json = response.value as? [String: Any],
                   let result = json["result"] as? [String: Any],
                   let header = result["block_header"] as? [String: Any],
                   let timestamp = header["timestamp"] as? Int,
                   timestamp > 0
               {
                   let endTime = CFAbsoluteTimeGetCurrent()
                 //  callBack?(Int((endTime - startTime) * 1000))
                   print("===============2222=========================")
               } else {
                  // callBack?(nil)
                   print("===============11111=========================")
               }
           }
           DispatchQueue.main.asyncAfter(deadline: .now()+5) {
               dataTask.cancel()
           }
   //=================================================================================================================
//           //let url = "http://" + "127.0.0.1:19091" + "/json_rpc"
//         //  let url = "http://publicnode4.rpcnode.stream:29095/json_rpc"
//         //  let url = "http://explorer.beldex.io:19091/json_rpc"
//           let url = "http://62.112.10.116:19091/json_rpc"
//           let param = ["jsonrpc": "2.0", "id": "0", "method": "get_info"]
//         //  let header: HTTPHeaders = ["Content-Type":"application/json"]
//           AF.request(url,
//                     method: .post,
//                 parameters: param,
//                   encoding: JSONEncoding.default,
//                    headers: nil)
//             .response { (responseData) in
//                 print("--1--->\(responseData)")
//           }
        
        
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
