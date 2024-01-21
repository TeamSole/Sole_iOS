//
//  GwangjuLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum GwangjuLocation: String, LocationProtocol {
    case Whole = "G00"
    case Gwangsan = "G01"
    case Nam = "G02"
    case Dong = "G03"
    case Buk = "G04"
    case Seo = "G05"
    
    var locationCode: String {
        return self.rawValue
    }
    
    var allCode: [String] {
        return GwangjuLocation.allCases.map({ $0.rawValue }).filter({ $0 != "G00" })
    }
    
    var mainLocationName: String {
        return "광주"
    }
    
    var isWholeLocation: Bool {
        return self == .Whole
    }
    
    var prefixCode: String {
        return "G"
    }

    var koreanName: String {
        switch self {
        case .Whole: return "전체"
        case .Gwangsan: return "광산구"
        case .Nam: return "남구"
        case .Dong: return "동구"
        case .Buk: return "북구"
        case .Seo: return "서구"
        }
    }
}

extension GwangjuLocation {
    static func toLocationModel() -> [LocationModel] {
        return GwangjuLocation.allCases
            .map({ LocationModel(locationName: $0.koreanName,
                                 locationCode: $0.locationCode,
                                 mainLocationName: $0.mainLocationName,
                                 mainLocationPrefixCode: $0.prefixCode,
                                 isWholeLocation: $0.isWholeLocation,
                                 wholeLoactionCode: $0.allCode) })
    }
}
