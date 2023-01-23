//
//  TrXibCell.swift
//  beldex-ios-wallet
//
//  Created by Sanada on 06/12/22.
//

import UIKit

class TrXibCell: UICollectionViewCell {
    static let identifier = "TrXibCell"
    static let nib = UINib(nibName: "TrXibCell", bundle: nil)
    
    @IBOutlet weak var lblname:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
