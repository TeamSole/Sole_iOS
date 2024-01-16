//
//  SejongLocation.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum SejongLocation: String {
    case Whole = "SGG"
    
    var koreanName: String {
        switch self {
        case .Whole: return "전체"
        }
    }
}
