//
//  FontExtension.swift
//  SoleApp
//
//  Created by SUN on 2023/03/12.
//

import SwiftUI

extension Font {
    enum Pretendard {
            case bold
            case medium
            case reguler
            case custom(String)
            
            var value: String {
                switch self {
                case .bold:
                    return "Pretendard-Bold"
                case .medium:
                    return "Pretendard-Medium"
                case .reguler:
                    return "Pretendard-Regular"
                case .custom(let name):
                    return name
                }
            }
        }

        static func pretendard(_ type: Pretendard, size: CGFloat) -> Font {
            return .custom(type.value, size: size)
        }
}

