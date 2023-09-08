//
//  MyPageCellData.swift
//  SoleApp
//
//  Created by SUN on 2023/08/27.
//

import Foundation

enum MyPageCellData: CaseIterable {
//    case setPush
//    case notice
//    case faq
//    case inquiry
    case terms
    case privacyPolicy
    case version
    
    var leftTitle: String {
        switch self {
//        case .setPush:
//            return "알림 설정"
//        case .notice:
//            return "공지사항"
//        case .faq:
//            return "FAQ"
//        case .inquiry:
//            return "문의하기"
        case .terms:
            return StringConstant.termsForUse
        case .privacyPolicy:
            return StringConstant.privacyPolicy
        case .version:
            return StringConstant.version
        }
    }
    
    var rightTitle: String {
        switch self {
        case .version:
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        default:
            return ""
        }
    }
}
