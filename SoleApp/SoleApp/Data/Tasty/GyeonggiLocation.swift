//
//  GyeonggiLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum GyeonggiLocation: String, LocationProtocol {
    case Whole = "K00"
    case Gapyeong = "K01"
    case Goyang = "K02"
    case Gwacheon = "K03"
    case Gwangmyeong = "K04"
    case Gwangju = "K05"
    case Guri = "K06"
    case Gunpo = "K07"
    case Gimpo = "K08"
    case Namyangju = "K09"
    case Dongducheon = "K10"
    case Bucheon = "K11"
    case Seongnam = "K12"
    case Suwon = "K13"
    case Siheung = "K14"
    case Ansan = "K15"
    case Anseong = "K16"
    case Anyang = "K17"
    case Yangju = "K18"
    case Yangpyeong = "K19"
    case Yeoju = "K20"
    case Yeoncheon = "K21"
    case Osan = "K22"
    case Yongin = "K23"
    case Uiwang = "K24"
    case Uijeongbu = "K25"
    case Icheon = "K26"
    case Paju = "K27"
    case Pyeongtaek = "K28"
    case Pocheon = "K29"
    case Hanam = "K30"
    case Hwaseong = "K31"
    
    var locationCode: String {
        return self.rawValue
    }
    
    var allCode: [String] {
        return GyeonggiLocation.allCases.map({ $0.rawValue }).filter({ $0 != "K00" })
    }
    
    var mainLocationName: String {
        return "경기"
    }
    
    var isWholeLocation: Bool {
        return self == .Whole
    }
    
    var prefixCode: String {
        return "K"
    }

    var koreanName: String {
        switch self {
        case .Whole: return "전체"
        case .Gapyeong: return "가평군"
        case .Goyang: return "고양시"
        case .Gwacheon: return "과천시"
        case .Gwangmyeong: return "광명시"
        case .Gwangju: return "광주시"
        case .Guri: return "구리시"
        case .Gunpo: return "군포시"
        case .Gimpo: return "김포시"
        case .Namyangju: return "남양주시"
        case .Dongducheon: return "동두천시"
        case .Bucheon: return "부천시"
        case .Seongnam: return "성남시"
        case .Suwon: return "수원시"
        case .Siheung: return "시흥시"
        case .Ansan: return "안산시"
        case .Anseong: return "안성시"
        case .Anyang: return "안양시"
        case .Yangju: return "양주시"
        case .Yangpyeong: return "양평군"
        case .Yeoju: return "여주시"
        case .Yeoncheon: return "연천군"
        case .Osan: return "오산시"
        case .Yongin: return "용인시"
        case .Uiwang: return "의왕시"
        case .Uijeongbu: return "의정부시"
        case .Icheon: return "이천시"
        case .Paju: return "파주시"
        case .Pyeongtaek: return "평택시"
        case .Pocheon: return "포천시"
        case .Hanam: return "하남시"
        case .Hwaseong: return "화성시"
        }
    }
}
