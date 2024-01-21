//
//  ChungbukLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum ChungbukLocation: String, LocationProtocol {
    case Whole = "CB00"
    case Goesan = "CB01"
    case Danyang = "CB02"
    case Boeun = "CB03"
    case Yeongdong = "CB04"
    case Okcheon = "CB05"
    case Eumseong = "CB06"
    case Jecheon = "CB07"
    case Jeungpyeong = "CB08"
    case Jincheon = "CB09"
    case Cheongju = "CB10"
    case Chungju = "CB11"
    
    var locationCode: String {
        return self.rawValue
    }
    
    var allCode: [String] {
        return ChungbukLocation.allCases.map({ $0.rawValue }).filter({ $0 != "CB00" })
    }
    
    var mainLocationName: String {
        return "충북"
    }
    
    var isWholeLocation: Bool {
        return self == .Whole
    }
    
    var prefixCode: String {
        return "CB"
    }

    var koreanName: String {
        switch self {
        case .Whole: return "전체"
        case .Goesan: return "괴산군"
        case .Danyang: return "단양군"
        case .Boeun: return "보은군"
        case .Yeongdong: return "영동군"
        case .Okcheon: return "옥천군"
        case .Eumseong: return "음성군"
        case .Jecheon: return "제천시"
        case .Jeungpyeong: return "증평군"
        case .Jincheon: return "진천군"
        case .Cheongju: return "청주시"
        case .Chungju: return "충주시"
        }
    }
}

extension ChungbukLocation {
    static func toLocationModel() -> [LocationModel] {
        return ChungbukLocation.allCases
            .map({ LocationModel(locationName: $0.koreanName,
                                 locationCode: $0.locationCode,
                                 mainLocationName: $0.mainLocationName,
                                 mainLocationPrefixCode: $0.prefixCode,
                                 isWholeLocation: $0.isWholeLocation,
                                 wholeLoactionCode: $0.allCode) })
    }
}
