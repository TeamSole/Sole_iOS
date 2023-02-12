//
//  UIColor.swift
//  SoleApp
//
//  Created by SUN on 2023/02/09.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    static let yellow_FBE520 = UIColor(hex: 0xFBE520)
    
    
    static let gray_D6D6D6 = UIColor(hex: 0xD6D6D6)
    static let gray_F2F2F2 = UIColor(hex: 0xF2F2F2)

}
