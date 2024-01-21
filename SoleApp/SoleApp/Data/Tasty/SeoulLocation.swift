//
//  SeoulLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum SeoulLocation: String, LocationProtocol {
    
    case Whole = "S00"
    case Gangnam = "S01"
    case Gangdong = "S02"
    case Gangbuk = "S03"
    case Gangseo = "S04"
    case Gwanak = "S05"
    case Gwangjin = "S06"
    case Guro = "S07"
    case Geumcheon = "S08"
    case Nowon = "S09"
    case Dobong = "S10"
    case Dongdaemun = "S11"
    case Dongjak = "S12"
    case Mapo = "S13"
    case Seodaemun = "S14"
    case Seocho = "S15"
    case Seongdong = "S16"
    case Seongbuk = "S17"
    case Songpa = "S18"
    case Yangcheon = "S19"
    case Yeongdeungpo = "S20"
    case Yongsan = "S21"
    case Eunpyeong = "S22"
    case Jongno = "S23"
    case Jung = "S24"
    case Jungnang = "S25"
    
    var locationCode: String {
        return self.rawValue
    }
    
    var allCode: [String] {
        return SeoulLocation.allCases.map({ $0.rawValue }).filter({ $0 != "S00" })
    }
    
    var mainLocationName: String {
        return "서울"
    }
    
    var isWholeLocation: Bool {
        return self == .Whole
    }
    
    var prefixCode: String {
        return "S"
    }
    
    
    var koreanName: String {
        switch self {
        case .Whole: return "전체"
        case .Gangnam: return "강남구"
        case .Gangdong: return "강동구"
        case .Gangbuk: return "강북구"
        case .Gangseo: return "강서구"
        case .Gwanak: return "관악구"
        case .Gwangjin: return "광진구"
        case .Guro: return "구로구"
        case .Geumcheon: return "금천구"
        case .Nowon: return "노원구"
        case .Dobong: return "도봉구"
        case .Dongdaemun: return "동대문구"
        case .Dongjak: return "동작구"
        case .Mapo: return "마포구"
        case .Seodaemun: return "서대문구"
        case .Seocho: return "서초구"
        case .Seongdong: return "성동구"
        case .Seongbuk: return "성북구"
        case .Songpa: return "송파구"
        case .Yangcheon: return "양천구"
        case .Yeongdeungpo: return "영등포구"
        case .Yongsan: return "용산구"
        case .Eunpyeong: return "은평구"
        case .Jongno: return "종로구"
        case .Jung: return "중구"
        case .Jungnang: return "중랑구"
        }
    }
}

extension SeoulLocation {
    static func toLocationModel() -> [LocationModel] {
        return SeoulLocation.allCases
            .map({ LocationModel(locationName: $0.koreanName,
                                 locationCode: $0.locationCode,
                                 mainLocationName: $0.mainLocationName,
                                 mainLocationPrefixCode: $0.prefixCode,
                                 isWholeLocation: $0.isWholeLocation,
                                 wholeLoactionCode: $0.allCode) })
    }
}
