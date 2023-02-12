//
//  UIFont.swift
//  SoleApp
//
//  Created by SUN on 2023/02/10.
//

import UIKit

extension UIFont {
    static func pretendardBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func pretendardMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func pretendardRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func pretendardLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Light", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func pretendardThin(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Thin", size: size) ?? .systemFont(ofSize: size)
    }
}
