//
//  IncheonLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum IncheonLocation: String, LocationProtocol {
    case Whole = "I00"
    case Ganghwa = "I01"
    case Gyeyang = "I02"
    case Namdong = "I03"
    case Dong = "I04"
    case Michuhol = "I05"
    case Bupyeong = "I06"
    case Seo = "I07"
    case Yeonsu = "I08"
    case Ongjin = "I09"
    case Jung = "I10"
    
    var locationCode: String {
        return self.rawValue
    }
    
    var allCode: [String] {
        return IncheonLocation.allCases.map({ $0.rawValue }).filter({ $0 != "I00" })
    }
    
    var mainLocationName: String {
        return "인천"
    }
    
    var isWholeLocation: Bool {
        return self == .Whole
    }
    
    var prefixCode: String {
        return "I"
    }

    var koreanName: String {
        switch self {
        case .Whole: return "인천 전체"
        case .Ganghwa: return "강화군"
        case .Gyeyang: return "계양구"
        case .Namdong: return "남동구"
        case .Dong: return "동구"
        case .Michuhol: return "미추홀구"
        case .Bupyeong: return "부평구"
        case .Seo: return "서구"
        case .Yeonsu: return "연수구"
        case .Ongjin: return "옹진군"
        case .Jung: return "중구"
        }
    }
}
