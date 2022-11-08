// Copyright © 2022 Rangeproof Pty Ltd. All rights reserved.

import UIKit

class MyWalletNodeXibCell: UICollectionViewCell {
    static let identifier = "MyWalletNodeXibCell"
    static let nib = UINib(nibName: "MyWalletNodeXibCell", bundle: nil)
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var viewcolour:UIView!
    @IBOutlet weak var lblmyaddress:UILabel!
    @IBOutlet weak var lblmints:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view1.layer.cornerRadius = 6
        viewcolour.layer.cornerRadius = viewcolour.layer.frame.width/2
        viewcolour.layer.borderWidth = 1
        viewcolour.layer.backgroundColor = UIColor.clear.cgColor
        viewcolour.clipsToBounds = true
    }

}
