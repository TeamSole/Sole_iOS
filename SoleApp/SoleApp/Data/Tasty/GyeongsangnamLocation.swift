//
//  GyeongsangnamLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum GyeongsangnamLocation: String {
    case Whole = "GN00"
    case Geoje = "GN01"
    case Geochang = "GN02"
    case Goseong = "GN03"
    case Gimhae = "GN04"
    case Namhae = "GN05"
    case Miryang = "GN06"
    case Sacheon = "GN07"
    case Sancheong = "GN08"
    case Yangsan = "GN09"
    case Uiryeong = "GN10"
    case Jinju = "GN11"
    case Changnyeong = "GN12"
    case Changwon = "GN13"
    case Tongyeong = "GN14"
    case Hadong = "GN15"
    case Haman = "GN16"
    case Hamyang = "GN17"
    case Hapcheon = "GN18"
    
    var koreanName: String {
        switch self {
        case .Whole: return "경상남도 전체"
        case .Geoje: return "거제시"
        case .Geochang: return "거창군"
        case .Goseong: return "고성군"
        case .Gimhae: return "김해시"
        case .Namhae: return "남해군"
        case .Miryang: return "밀양시"
        case .Sacheon: return "사천시"
        case .Sancheong: return "산청군"
        case .Yangsan: return "양산시"
        case .Uiryeong: return "의령군"
        case .Jinju: return "진주시"
        case .Changnyeong: return "창녕군"
        case .Changwon: return "창원시"
        case .Tongyeong: return "통영시"
        case .Hadong: return "하동군"
        case .Haman: return "함안군"
        case .Hamyang: return "함양군"
        case .Hapcheon: return "합천군"
        }
    }
}
