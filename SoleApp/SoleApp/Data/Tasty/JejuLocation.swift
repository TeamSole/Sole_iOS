//
//  JejuLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum JejuLocation: String, LocationProtocol {
    case Whole = "JJ00"
    case Seogwipo = "JJ01"
    case Jeju = "JJ02"
    
    var locationCode: String {
        return self.rawValue
    }
    
    var allCode: [String] {
        return JejuLocation.allCases.map({ $0.rawValue }).filter({ $0 != "JJ00" })
    }
    
    var mainLocationName: String {
        return "제주"
    }
    
    var isWholeLocation: Bool {
        return self == .Whole
    }
    
    var prefixCode: String {
        return "JJ"
    }
    
    var koreanName: String {
        switch self {
        case .Whole: return "전체"
        case .Seogwipo: return "서귀포시"
        case .Jeju: return "제주시"
        }
    }
}

extension JejuLocation {
    func toLocationModel() -> [LocationModel] {
        return JejuLocation.allCases
            .map({ LocationModel(locationName: $0.koreanName,
                                 locationCode: $0.locationCode,
                                 mainLocationName: self.mainLocationName,
                                 mainLocationPrefixCode: self.prefixCode,
                                 isWholeLocation: self.isWholeLocation,
                                 wholeLoactionCode: $0.allCode) })
    }
}

