//
//  NodeListViewController.swift
//  beldex-ios-wallet
//
//  Created by Blockhash on 03/11/22.
//

import UIKit
import Alamofire

class NodeListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(MyWalletNodeXibCell.nib, forCellWithReuseIdentifier: MyWalletNodeXibCell.identifier)
        }
    }
    
    var arrlist = ["node.imonero.org:18081","node.moneroworld.com:18089","opennode.xmr-tw.org:18089","uwillrunanodesoon.moneroworld.com:18089"]
    private var selectedIndex: Int?
    private var fpsCaches = [String: Int]()
    private var nodeList = [NodeOption](){
        didSet {
           // postDataSource()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //depending upon direction of collection view
        self.collectionView?.setCollectionViewLayout(layout, animated: true)
     
        
        
    }
//    private func postDataSource() {
//        DispatchQueue.global().async {
//             let sections = [self.nodeList.map({
//                var model = $0
//                model.fps = self.fpsCaches[$0.node]
//                self.pingNode($0.node)
//                return
//            })]
//            DispatchQueue.main.async {
//               // self.dataSourceOb.newState(sections)
//            }
//        }
//    }
//    private func pingNode(_ url: String) {
//
//    }
    
    
    @IBAction func Plus_Action(sender:UIButton){
        let alertController = UIAlertController(title: "Add Node", message: "", preferredStyle: UIAlertController.Style.alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print("------> \(firstTextField.text!)")
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Pls Enter"
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func BackAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension NodeListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return arrlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyWalletNodeXibCell.identifier, for: indexPath) as! MyWalletNodeXibCell
        
        cell.lblmyaddress.text = arrlist[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MyWalletNodeXibCell {
            cell.viewcolour.layer.backgroundColor = UIColor.green.cgColor
            cell.viewcolour.layer.borderColor = UIColor.white.cgColor
            

        }
        
//        guard indexPath.item != selectedIndex else {
//            return
//        }
//        var nodeList = self.nodeList
//        nodeList[indexPath.item].isSelected = true
//        if let index = selectedIndex {
//            nodeList[index].isSelected = false
//            if index >= arrlist.count {
//                print("--IOS--> \(index)")
//            }
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MyWalletNodeXibCell {
            cell.viewcolour.layer.backgroundColor = UIColor.clear.cgColor
            cell.viewcolour.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    
}

