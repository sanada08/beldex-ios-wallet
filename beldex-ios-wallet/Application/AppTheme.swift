//
//  AppTheme.swift
//  beldex-ios-wallet
//
//  Created by Sanada Yukimura on 6/13/22.
//

import UIKit

// MARK: - Theme

public enum AppThemeStyle: String {
    case dark = "AppThemeStyle.dark"
    case normal = "AppThemeStyle.normal"
}

public struct AppTheme {
    
    struct Color {
        static var main_green: UIColor {return UIColor.init()}
        static var main_blue: UIColor { return UIColor.init() }
        static var main_slogen: UIColor { return UIColor.init() }
        static var navigationBar: UIColor { return UIColor.init() }
        static var navigation_tintColor: UIColor { return UIColor.init() }
        static var navigationTitle: UIColor { return UIColor.init() }
        static var navigationBarShadow: UIColor { return UIColor.init() }
        static var tabBar: UIColor { return UIColor.init() }
        static var tabBar_tintColor: UIColor { return UIColor.init() }
        static var tabBarShadow: UIColor { return UIColor.init() }
        static var searchBar: UIColor { return UIColor.init() }
        static var searchBarText: UIColor { return UIColor.init() }
        static var page_common: UIColor { return UIColor.white }
        static var tableView_bg: UIColor { return UIColor.init() }
        static var alert_textView: UIColor { return UIColor.init() }
        static var text_black: UIColor { return UIColor.init() }
        static var text_darker: UIColor { return UIColor.init() }
        static var text_dark: UIColor { return UIColor.init() }
        static var text_gray: UIColor { return UIColor.init() }
        static var text_light: UIColor { return UIColor.init() }
        static var text_light_M: UIColor { return UIColor.init() }
        static var text_light_H: UIColor { return UIColor.init() }
        static var text_warning: UIColor { return UIColor.init() }
        static var text_click: UIColor { return UIColor.init() }
        static var button_title: UIColor { return UIColor.init() }
        static var button_bg: UIColor { return UIColor.init() }
        static var button_disable: UIColor { return UIColor.init() }
        static var cell_bg: UIColor { return UIColor.init() }
        static var line_broken: UIColor { return UIColor.init() }
        static var cell_line: UIColor { return UIColor.init() }
        static var main_green_light: UIColor { return UIColor.init() }
        static var status_green: UIColor { return UIColor.init() }
        static var status_red: UIColor { return UIColor.init() }
        static var status_blue: UIColor { return UIColor.init() }
        static var words_bg: UIColor { return UIColor.init() }
        static var progress_green: UIColor { return UIColor.init() }
    }
    
    struct Font {
        static var navigationTitle: UIFont { return UIFont.systemFont(ofSize: 18, weight: .medium) }
        static var navigationButtonTitle: UIFont { return UIFont.systemFont(ofSize: 10) }
        static var cellTitle: UIFont { return UIFont.systemFont(ofSize: 1) }
        static var cellSubTitle: UIFont { return UIFont.systemFont(ofSize: 1) }
        static var text_normal: UIFont { return UIFont.systemFont(ofSize: 16) }
        static var text_normal_: UIFont { return UIFont.systemFont(ofSize: 15) }
        static var text_small: UIFont { return UIFont.systemFont(ofSize: 14) }
        static var text_smaller: UIFont { return UIFont.systemFont(ofSize: 12) }
        static var text_smallest: UIFont { return UIFont.systemFont(ofSize: 10) }
        static var text_large: UIFont { return UIFont.boldSystemFont(ofSize: 20) }
        static var text_huge: UIFont { return UIFont.boldSystemFont(ofSize: 25) }
    }
}

