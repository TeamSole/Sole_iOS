//
//  MyPageViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/02/28.
//

import SwiftUI

enum MyPageCell: CaseIterable {
    case setPush
    case notice
    case faq
    case inquiry
    case terms
    case privacyPolicy
    case version
    
    var leftTitle: String {
        switch self {
        case .setPush:
            return "알림 설정"
        case .notice:
            return "공지사항"
        case .faq:
            return "FAQ"
        case .inquiry:
            return "문의하기"
        case .terms:
            return "이용약관"
        case .privacyPolicy:
            return "개인정보 처리방침"
        case .version:
            return "버전"
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

final class MyPageViewModel: ObservableObject {
    var myPageViewCellData = MyPageCell.allCases
    
}
