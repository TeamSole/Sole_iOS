//
//  GyeongsangbukLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum GyeongsangbukLocation: String {
    case Whole = "GB00"
    case Gyeongsan = "GB01"
    case Gyeongju = "GB02"
    case Goryeong = "GB03"
    case Gumi = "GB04"
    case Gunwi = "GB05"
    case Gimcheon = "GB06"
    case Mungyeong = "GB07"
    case Bonghwa = "GB08"
    case Sangju = "GB09"
    case Seongju = "GB10"
    case Andong = "GB11"
    case Yeongdeok = "GB12"
    case Yeongyang = "GB13"
    case Yeongju = "GB14"
    case Yecheon = "GB15"
    case Yeongchon = "GB16"
    case Ulleung = "GB17"
    case Uljin = "GB18"
    case Uiseong = "GB19"
    case Cheongdo = "GB20"
    case Cheongsong = "GB21"
    case Chilgok = "GB22"
    case Pohang = "GB23"
    
    var koreanName: String {
        switch self {
        case .Whole: return "경상북도 전체"
        case .Gyeongsan: return "경산시"
        case .Gyeongju: return "경주시"
        case .Goryeong: return "고령군"
        case .Gumi: return "구미시"
        case .Gunwi: return "군위군"
        case .Gimcheon: return "김천시"
        case .Mungyeong: return "문경시"
        case .Bonghwa: return "봉화군"
        case .Sangju: return "상주시"
        case .Seongju: return "성주군"
        case .Andong: return "안동시"
        case .Yeongdeok: return "영덕군"
        case .Yeongyang: return "영양군"
        case .Yecheon: return "예천군"
        case .Yeongju: return "영주시"
        case .Yeongchon: return "영천군" 
        case .Ulleung: return "울릉군"
        case .Uljin: return "울진군"
        case .Uiseong: return "의성군"
        case .Cheongdo: return "청도군"
        case .Cheongsong: return "청송군"
        case .Chilgok: return "칠곡군"
        case .Pohang: return "포항시"

        }
    }
}
