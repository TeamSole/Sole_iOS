//
//  JejuLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum JejuLocation: String {
    case Whole = "JJ00"
    case Seogwipo = "JJ01"
    case Jeju = "JJ02"
    
    var koreanName: String {
        switch self {
        case .Whole: return "제주 전체"
        case .Seogwipo: return "서귀포시"
        case .Jeju: return "제주시"
        }
    }
}
