//
//  UlsanLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum UlsanLocation: String, LocationProtocol {
    case Whole = "U00"
    case Nam = "U01"
    case Dong = "U02"
    case Buk = "U03"
    case Ulju = "U04"
    case Jung = "U05"
    
    var locationCode: String {
        return self.rawValue
    }
    
    var allCode: [String] {
        return BusanLocation.allCases.map({ $0.rawValue }).filter({ $0 != "U00" })
    }
    
    var mainLocationName: String {
        return "울산"
    }
    
    var isWholeLocation: Bool {
        return self == .Whole
    }
    
    var prefixCode: String {
        return "U"
    }

    var koreanName: String {
        switch self {
        case .Whole: return "전체"
        case .Nam: return "남구"
        case .Dong: return "동구"
        case .Buk: return "북구"
        case .Ulju: return "울주군"
        case .Jung: return "중구"
        }
    }
}
