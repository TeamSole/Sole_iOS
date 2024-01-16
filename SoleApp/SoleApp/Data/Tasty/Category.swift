//
//  Category.swift
//  SoleApp
//
//  Created by SUN on 1/16/24.
//

import Foundation

enum Category: String {
    // MARK:
    case TASTY_PLACE = "TASTY_PLACE"
    case CAFE = "CAFE"
    case CULTURE_ART = "CULTURE_ART"
    case ACTIVITY = "ACTIVITY"
    case HEALING = "HEALING"
    case NATURE = "NATURE"
    case NIGHT_VIEW = "NIGHT_VIEW"
    case HISTORY = "HISTORY"
    case THEME_PARK = "THEME_PARK"
    
    case WALK = "WALK"
    case BIKE = "BIKE"
    case CAR = "CAR"
    case PUBLIC_TRANSPORTATION = "PUBLIC_TRANSPORTATION"
    
    case ALONE = "ALONE"
    case FRIEND = "FRIEND"
    case COUPLE = "COUPLE"
    case KID = "KID"
    case PET = "PET"
    
    case none
    
    var title: String {
        switch self {
        case .TASTY_PLACE:
            return "🍚 맛집"
        case .CAFE:
            return "☕️ 카페"
        case .CULTURE_ART:
            return "🖼️ 문화·예술"
        case .ACTIVITY:
            return "🪂 액티비티"
        case .HEALING:
            return "😌 힐링"
        case .NATURE:
            return "🌿 자연"
        case .NIGHT_VIEW:
            return "🌉 야경"
        case .HISTORY:
            return "⏳ 역사"
        case .THEME_PARK:
            return "🎡 테마파크"
        case .WALK:
            return "👟 걸어서"
        case .BIKE:
            return "🚴 자전거로"
        case .CAR:
            return "🚗 자동차로"
        case .PUBLIC_TRANSPORTATION:
            return "🚌 대중교통으로"
        case .ALONE:
            return "🙋‍♀️ 혼자서"
        case .FRIEND:
            return "😎 친구와"
        case .COUPLE:
            return "👩‍❤️‍👨 연인과"
        case .KID:
            return "👶 아이와"
        case .PET:
            return "🐶 반려동물과"
        default:
            return ""
        }
    }
    
    static var placeCategory: [Category] {
        return [.TASTY_PLACE, .CAFE, .CULTURE_ART, .ACTIVITY, .HEALING, .NATURE, .NIGHT_VIEW, .HISTORY, .THEME_PARK]
    }

    static var transCategory: [Category] {
        return [.WALK, .BIKE, .CAR, .PUBLIC_TRANSPORTATION]
        
    }

    static var withCategory: [Category] {
        return [.ALONE, .FRIEND, .COUPLE, .KID, .PET]
    }
}





//PlaceCategory
// TASTY_PLACE : 맛집
// CAFE : 카페
// CULTURE_ART : 문화 예술
// ACTIVITY : 액티비티
// HEALING : 힐링
// NATURE : 자연
// NIGHT_VIEW : 아경
// HISTORY : 역사
// THEME_PARK : 테마파크
// TransCategory
// WALK : 도보
// BIKE : 자전거
// CAR : 자동차
// PUBLIC_TRANSPORTATION : 대중교통
// WithCategory
// ALONE : 혼자
// FRIEND : 친구
// COUPLE : 커플
// KID : 아이와
// PET : 반려동물과
