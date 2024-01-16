//
//  JeonbukLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum JeonbukLocation: String {
    case Whole = "JB00"
    case Gochang = "JB01"
    case Gunsan = "JB02"
    case Gimje = "JB03"
    case Namwon = "JB04"
    case Muju = "JB05"
    case Buan = "JB06"
    case Suncheon = "JB07"
    case Wanju = "JB08"
    case Iksan = "JB09"
    case Imsil = "JB10"
    case Jangsu = "JB11"
    case Jeonju = "JB12"
    case Jeongeup = "JB13"
    case Jinan = "JB14"
    
    var koreanName: String {
        switch self {
        case .Whole: return "전북 전체"
        case .Gochang: return "고창군"
        case .Gunsan: return "군산시"
        case .Gimje: return "김제시"
        case .Namwon: return "남원시"
        case .Muju: return "무주군"
        case .Buan: return "부안군"
        case .Suncheon: return "순창군"
        case .Wanju: return "완주군"
        case .Iksan: return "익산시"
        case .Imsil: return "임실군"
        case .Jangsu: return "장수군"
        case .Jeonju: return "전주시"
        case .Jeongeup: return "정읍시"
        case .Jinan: return "진안군"
        }
    }
}
