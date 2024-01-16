//
//  DaejeonLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum DaejeonLocation: String {
    case Whole = "DJ00"
    case Daedeok = "DJ01"
    case Dong = "DJ02"
    case Seo = "DJ03"
    case Yuseong = "DJ04"
    case Jung = "DJ05"

    var koreanName: String {
        switch self {
        case .Whole: return "대전 전체"
        case .Daedeok: return "대덕구"
        case .Dong: return "동구"
        case .Seo: return "서구"
        case .Yuseong: return "유성구"
        case .Jung: return "중구"
        }
    }
}
