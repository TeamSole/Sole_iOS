//
//  GangwonLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum GangwonLocation: String {
    case Whole = "KW00"
    case Gangneung = "KW01"
    case Goseong = "KW02"
    case Donghae = "KW03"
    case Samcheok = "KW04"
    case Sokcho = "KW05"
    case Yanggu = "KW06"
    case Yangyang = "KW07"
    case Yeongwol = "KW08"
    case Wonju = "KW09"
    case Inje = "KW10"
    case Jeongseon = "KW11"
    case Cheorwon = "KW12"
    case Chuncheon = "KW13"
    case Taebaek = "KW14"
    case Pyeongchang = "KW15"
    case Hongcheon = "KW16"
    case Hwacheon = "KW17"
    case Hoengseong = "KW18"

    var koreanName: String {
        switch self {
        case .Whole: return "강원 전체"
        case .Gangneung: return "강릉시"
        case .Goseong: return "고성군"
        case .Donghae: return "동해시"
        case .Samcheok: return "삼척시"
        case .Sokcho: return "속초시"
        case .Yanggu: return "양구군"
        case .Yangyang: return "양양군"
        case .Yeongwol: return "영월군"
        case .Wonju: return "원주시"
        case .Inje: return "인제군"
        case .Jeongseon: return "정선군"
        case .Cheorwon: return "철원군"
        case .Chuncheon: return "춘천시"
        case .Taebaek: return "태백시"
        case .Pyeongchang: return "평창군"
        case .Hongcheon: return "홍천군"
        case .Hwacheon: return "화천군"
        case .Hoengseong: return "횡성군"
        }
    }
}
