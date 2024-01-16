//
//  ChungnamLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum ChungnamLocation: String {
    case Whole = "CN00"
    case Gyeoryeong = "CN01"
    case Gongju = "CN02"
    case Geumsan = "CN03"
    case Nonsan = "CN04"
    case Dangjin = "CN05"
    case Boryeong = "CN06"
    case Buyeo = "CN07"
    case Seosan = "CN08"
    case Seocheon = "CN09"
    case Asan = "CN10"
    case Yesan = "CN11"
    case Cheonan = "CN12"
    case Cheongyang = "CN13"
    case Taean = "CN14"
    case Hongseong = "CN15"

    var koreanName: String {
        switch self {
        case .Whole: return "충남 전체"
        case .Gyeoryeong: return "계룡시"
        case .Gongju: return "공주시"
        case .Geumsan: return "금산군"
        case .Nonsan: return "논산시"
        case .Dangjin: return "당진시"
        case .Boryeong: return "보령시"
        case .Buyeo: return "부여군"
        case .Seosan: return "서산시"
        case .Seocheon: return "서천군"
        case .Asan: return "아산시"
        case .Yesan: return "예산군"
        case .Cheonan: return "천안시"
        case .Cheongyang: return "청양군"
        case .Taean: return "태안군"
        case .Hongseong: return "홍성군"
        }
    }
}
