//
//  SubAddress.swift
//  beldex-ios-wallet
//
//  Created by Sanada Yukimura on 7/18/22.
//

import Foundation

public struct SubAddress: Equatable, Codable {
    var rowId: Int = 0
    var address: String = ""
    var label: String = ""
    
    init() {}
    init(model: BeldexSubAddress) {
        self.rowId = model.rowId
        self.address = model.address
        self.label = model.label
    }
    
    static func primary(address: String) -> SubAddress {
        var model = SubAddress()
        model.rowId = -1
        model.address = address
//        model.label = LocalizedString(key: "primaryAddress", comment: "")
        return model
    }
}
