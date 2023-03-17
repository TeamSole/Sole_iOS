//
//  ColorExtension.swift
//  SoleApp
//
//  Created by SUN on 2023/03/13.
//

import SwiftUI

extension Color {
    
    static let mainBlackColor = Color.black_151515
    
    static let blue_4708FA = Color(hex: "4708FA")
    static let blue_0996F6 = Color(hex: "0996F6")
    
    static let yellow_FBE520 = Color(hex: "FBE520")
    static let yellow_E9FF4B = Color(hex: "E9FF4B")

    
    static let gray_D6D6D6 = Color(hex: "D6D6D6")
    static let gray_EDEDED = Color(hex: "EDEDED")
    static let gray_F2F2F2 = Color(hex: "F2F2F2")
    static let gray_D3D4D5 = Color(hex: "D3D4D5")
    static let gray_999999 = Color(hex: "999999")
    static let gray_404040 = Color(hex: "404040")
    static let gray_383838 = Color(hex: "383838")
    
    static let green_8BDEB5 = Color(hex: "8BDEB5")

    
    static let black_151515 = Color(hex: "151515")
    
    
    static let red_FF717D = Color(hex: "FF717D")

    
    
    init(hex: String){
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .displayP3,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
