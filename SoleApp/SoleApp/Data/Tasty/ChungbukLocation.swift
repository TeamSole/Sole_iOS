//
//  ChungbukLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum ChungbukLocation: String {
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

    var koreanName: String {
        switch self {
        case .Whole: return "충북 전체"
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
