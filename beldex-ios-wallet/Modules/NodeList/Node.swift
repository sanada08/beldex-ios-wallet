//
//  Node.swift


import UIKit

struct NodeDefaults {
    
    struct Beldex {
        static let default_en = "38.242.196.72:19095"
        static let default0 = "publicnode2.rpcnode.stream:29095"
//        static let default_zh = "124.160.224.28:18081"
        static let default1 = "explorer.beldex.io:19091"
        static let default2 = "38.242.196.72:19095"
        
        static var `default`: String {
            switch AppLanguage.manager.current {
            case .en:
                return default_en
            case .zh:
                return default_en
            }
        }
        
        static var defaultList: [String] {
            switch AppLanguage.manager.current {
            case .en:
                return [default_en, default0, default1, default2]
            case .zh:
                return [default_en, default0, default1, default2]
            }
        }
    }
}

struct TokenNodeModel {
    var tokenImage: UIImage?
    var tokenName: String = ""
    var tokenNode: String = ""
}

struct NodeOption {
    var node: String
    var fps: Int?
    var isSelected: Bool = false
}
