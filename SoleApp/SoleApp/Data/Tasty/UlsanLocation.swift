//
//  UlsanLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum UlsanLocation: String {
    case Whole = "U00"
    case Nam = "U01"
    case Dong = "U02"
    case Buk = "U03"
    case Ulju = "U04"
    case Jung = "U05"

    var koreanName: String {
        switch self {
        case .Whole: return "울산 전체"
        case .Nam: return "남구"
        case .Dong: return "동구"
        case .Buk: return "북구"
        case .Ulju: return "울주군"
        case .Jung: return "중구"
        }
    }
}
