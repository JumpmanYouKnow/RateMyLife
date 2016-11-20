//
//  AppData.swift
//  RateMyLife
//
//  Created by Monster on 2016-11-19.
//  Copyright © 2016 Monster. All rights reserved.
//

import Foundation
import UIKit

struct AppColor {
    static let lightOrange2 = UIColor(netHex: 0xffc966)
    static let blue2 = UIColor(netHex: 0x80dfff)
    static let lightGreen = UIColor(netHex: 0x66cc00)
    static let lightBlue = UIColor(netHex:  0xb3b3ff)
    static let lightPink = UIColor(netHex: 0xff80d5)
    static let lightRed = UIColor(netHex: 0xff5050)
    static let lightOrange = UIColor(netHex: 0xffa31a)
    static let appBlue = UIColor(netHex: 0x3333FF)
    static let progressLabel = UIColor(netHex: 0x3c9c03)
    static let dividerColor = UIColor(netHex: 0xe9e9e9)
    static let dividerColor2 = UIColor(netHex: 0xf2f2f9)
    static let dividerColor3 = UIColor(netHex: 0xd3d3d3)
    static let menuDividerColor = UIColor(netHex: 0xdbdbdb)
    static let restaurantTextColor = UIColor(netHex: 0x939393)
    static let contactTextColor = UIColor(netHex: 0x7f7f7f)
    static let clickColor = UIColor(netHex: 0x006400)
    static let themeColor = UIColor(red:0.96, green:0.03, blue:0.24, alpha:1.0)
    static let lightThemeColor = UIColor(red:0.96, green:0.03, blue:0.14, alpha:1.0)
    static let themeComplementColor =  UIColor(netHex: 0xffa500)
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

struct defaultsKeys {
    static let keyOne = "firstStringKey"
    static let keyTwo = "secondStringKey"
}
