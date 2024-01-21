//
//  BusanLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum BusanLocation: String, LocationProtocol {

    case Whole = "B00"
    case Gangseo = "B01"
    case Geumjeong = "B02"
    case Gijang = "B03"
    case Nam = "B04"
    case Dong = "B05"
    case Dongnae = "B06"
    case Busanjin = "B07"
    case Buk = "B08"
    case Sasang = "B09"
    case Saha = "B10"
    case Seo = "B11"
    case Suyeong = "B12"
    case Yeonje = "B13"
    case Yeongdo = "B14"
    case Jung = "B15"
    case Haeundae = "B16"
    
    var locationCode: String {
        return self.rawValue
    }
    
    var allCode: [String] {
        return BusanLocation.allCases.map({ $0.rawValue }).filter({ $0 != "B00" })
    }
    
    var mainLocationName: String {
        return "부산"
    }
    
    var isWholeLocation: Bool {
        return self == .Whole
    }
    
    var prefixCode: String {
        return "B"
    }
    

    var koreanName: String {
        switch self {
        case .Whole: return "전체"
        case .Gangseo: return "강서구"
        case .Geumjeong: return "금정구"
        case .Gijang: return "기장군"
        case .Nam: return "남구"
        case .Dong: return "동구"
        case .Dongnae: return "동래구"
        case .Busanjin: return "부산진구"
        case .Buk: return "북구"
        case .Sasang: return "사상구"
        case .Saha: return "사하구"
        case .Seo: return "서구"
        case .Suyeong: return "수영구"
        case .Yeonje: return "연제구"
        case .Yeongdo: return "영도구"
        case .Jung: return "중구"
        case .Haeundae: return "해운대구"
        }
    }
}
