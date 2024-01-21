//
//  DaeguLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum DaeguLocation: String, LocationProtocol {
    case Whole = "D00"
    case Nam = "D01"
    case Dalseo = "D02"
    case Dalseong = "D03"
    case Dong = "D04"
    case Buk = "D05"
    case Seo = "D06"
    case Suseong = "D07"
    case Jung = "D08"
    
    
    var locationCode: String {
        return self.rawValue
    }
    
    var allCode: [String] {
        return DaeguLocation.allCases.map({ $0.rawValue }).filter({ $0 != "D00" })
    }
    
    var mainLocationName: String {
        return "대구"
    }
    
    var isWholeLocation: Bool {
        return self == .Whole
    }
    
    var prefixCode: String {
        return "D"
    }
    

    var koreanName: String {
        switch self {
        case .Whole: return "전체"
        case .Nam: return "남구"
        case .Dalseo: return "달서구"
        case .Dalseong: return "달성군"
        case .Dong: return "동구"
        case .Buk: return "북구"
        case .Seo: return "서구"
        case .Suseong: return "수성구"
        case .Jung: return "중구"
        }
    }
}

extension DaeguLocation {
    static func toLocationModel() -> [LocationModel] {
        return DaeguLocation.allCases
            .map({ LocationModel(locationName: $0.koreanName,
                                 locationCode: $0.locationCode,
                                 mainLocationName: $0.mainLocationName,
                                 mainLocationPrefixCode: $0.prefixCode,
                                 isWholeLocation: $0.isWholeLocation,
                                 wholeLoactionCode: $0.allCode) })
    }
}

