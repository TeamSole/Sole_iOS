//
//  SejongLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum SejongLocation: String, LocationProtocol {
    case Whole = "SGG"
    
    var locationCode: String {
        return self.rawValue
    }
    
    var allCode: [String] {
        return SejongLocation.allCases.map({ $0.rawValue })
    }
    
    var mainLocationName: String {
        return "세종"
    }
    
    var isWholeLocation: Bool {
        return self == .Whole
    }
    
    var prefixCode: String {
        return "SGG"
    }
    
    var koreanName: String {
        switch self {
        case .Whole: return "전체"
        }
    }
}

extension SejongLocation {
    func toLocationModel() -> [LocationModel] {
        return SejongLocation.allCases
            .map({ LocationModel(locationName: $0.koreanName,
                                 locationCode: $0.locationCode,
                                 mainLocationName: self.mainLocationName,
                                 mainLocationPrefixCode: self.prefixCode,
                                 isWholeLocation: self.isWholeLocation,
                                 wholeLoactionCode: $0.allCode) })
    }
}
