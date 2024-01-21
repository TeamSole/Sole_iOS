//
//  JeonnamLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum JeonnamLocation: String, LocationProtocol {
    case Whole = "JN00"
    case Gangjin = "JN01"
    case Goheung = "JN02"
    case Gokseong = "JN03"
    case Gwangyang = "JN04"
    case Gurye = "JN05"
    case Naju = "JN06"
    case Damyang = "JN07"
    case Mokpo = "JN08"
    case Muan = "JN09"
    case Boseong = "JN10"
    case Suncheon = "JN11"
    case Sinan = "JN12"
    case Yeosu = "JN13"
    case Yeonggwang = "JN14"
    case Yeongam = "JN15"
    case Wando = "JN16"
    case Jangseong = "JN17"
    case Jangheung = "JN18"
    case Jindo = "JN19"
    case Hampyeong = "JN20"
    case Haenam = "JN21"
    case Hwasun = "JN22"
    
    var locationCode: String {
        return self.rawValue
    }
    
    var allCode: [String] {
        return JeonnamLocation.allCases.map({ $0.rawValue }).filter({ $0 !=  "JN00" })
    }
    
    var mainLocationName: String {
        return "전남"
    }
    
    var isWholeLocation: Bool {
        return self == .Whole
    }
    
    var prefixCode: String {
        return "JN"
    }
    
    var koreanName: String {
        switch self {
        case .Whole: return "전체"
        case .Gangjin: return "강진군"
        case .Goheung: return "고흥군"
        case .Gokseong: return "곡성군"
        case .Gwangyang: return "광양시"
        case .Gurye: return "구례군"
        case .Naju: return "나주시"
        case .Damyang: return "담양군"
        case .Mokpo: return "목포시"
        case .Muan: return "무안군"
        case .Boseong: return "보성군"
        case .Suncheon: return "순천시"
        case .Sinan: return "신안군"
        case .Yeosu: return "여수시"
        case .Yeonggwang: return "영광군"
        case .Yeongam: return "영암군"
        case .Wando: return "완도군"
        case .Jangseong: return "장성군"
        case .Jangheung: return "장흥군"
        case .Jindo: return "진도군"
        case .Hampyeong: return "함평군"
        case .Haenam: return "해남군"
        case .Hwasun: return "화순군"
        }
    }
}
