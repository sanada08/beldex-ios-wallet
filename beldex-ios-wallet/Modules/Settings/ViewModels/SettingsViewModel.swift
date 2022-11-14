//
//  SettingsViewModel.swift


import UIKit

class SettingsViewModel: NSObject {
    
    // MARK: - Properties
    
    private lazy var itemGroup: [[SettingsItemType]] = {
        return [
            [.wallet, .token,],
            [.node, .lang, .markets,],
            [.help, .about,],
        ]
    }()
    
    
    // MARK: - Methods (Private)
    
    private func getItemFor(_ type: SettingsItemType) -> SettingsItem {
        switch type {
        case .wallet:
            return SettingsItem.init(icon: UIImage(named: "settings.wallet"), name: LocalizedString(key: "", comment: "Wallet Management"), text: "")
        case .pin:
            return SettingsItem.init(icon: UIImage(named: "settings.pin"), name: LocalizedString(key: "", comment: "PIN"), text: "")
        case .token:
            return SettingsItem.init(icon: UIImage(named: "settings.token"), name: LocalizedString(key: "", comment: "Address Book"), text: "")
        case .node:
            return SettingsItem.init(icon: UIImage(named: "settings.node"), name: LocalizedString(key: "", comment: "Node"), text: "")
        case .lang:
            let text: String
            switch AppLanguage.manager.current {
            case .en:
                text = "English"
            case .zh:
                text = "简体中文"
            }
            return SettingsItem.init(icon: UIImage(named: "settings.lang"), name: LocalizedString(key: "", comment: "Language"), text: text)
        case .markets:
            return SettingsItem(icon: UIImage(named: "settings.markets"), name: LocalizedString(key: "", comment: "Markets"), text: "")
        case .help:
            return SettingsItem.init(icon: UIImage(named: "settings.help"), name: LocalizedString(key: "", comment: "Contact Us"), text: "")
        case .about:
            return SettingsItem.init(icon: UIImage(named: "settings.about"), name: LocalizedString(key: "", comment: "About WooKey"), text: AppInfo.appVersion)
        }
    }
    
    
    // MARK: - Methods (Public)
    
    public func getDataSource() -> [TableViewSection] {
        return itemGroup.map({
            var sec = TableViewSection.init($0.map({
                return TableViewRow.init(getItemFor($0), cellType: SettingsViewCell.self, rowHeight: 60)
            }))
            sec.footerHeight = 20
            sec.headerHeight = 0.1
            return sec
        })
    }
    
    public func getNextViewController(_ indexPath: IndexPath) -> UIViewController {
        switch itemGroup[indexPath.section][indexPath.row] {
        case .node:
            return NodeSettingsViewController()
        case .token:
            return BaseViewController()
        case .wallet:
            return BaseViewController()
        case .lang:
            return BaseViewController()
        case .markets:
            return BaseViewController()
        case .about:
            return BaseViewController()
        case .help:
            return BaseViewController()
        default:
            return BaseViewController()
        }
    }
}
