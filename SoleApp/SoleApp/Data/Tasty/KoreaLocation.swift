//
//  KoreaLocation.swift
//  SoleApp
//
//  Created by SUN on 1/17/24.
//

import Foundation

enum KoreaLocation: String {
    case Seoul = "S"
    case Gyeonggi = "K"
    case Incheon = "I"
    case Daejeon = "DJ"
    case Sejong = "SGG"
    case Chungnam = "CN"
    case Chungbuk = "CB"
    case Gwangju = "G"
    case Jeonnam = "JN"
    case Jeonbuk = "JB"
    case Daegu = "D"
    case Gyeongbuk = "GB"
    case Busan = "B"
    case Ulsan = "U"
    case Gyeongnam = "GN"
    case Gangwon = "KW"
    case Jeju = "JJ"
    
    var koreanName: String {
        switch self {
        case .Seoul:
            return "서울"
        case .Gyeonggi:
            return "경기"
        case .Incheon:
            return "인천"
        case .Daejeon:
            return "대전"
        case .Sejong:
            return "세종"
        case .Chungnam:
            return "충남"
        case .Chungbuk:
            return "충북"
        case .Gwangju:
            return "광주"
        case .Jeonnam:
            return "전남"
        case .Jeonbuk:
            return "전북"
        case .Daegu:
            return "대구"
        case .Gyeongbuk:
            return "경북"
        case .Busan:
            return "부산"
        case .Ulsan:
            return "울산"
        case .Gyeongnam:
            return "경남"
        case .Gangwon:
            return "강원"
        case .Jeju:
            return "제주"
        }
    }
    
    func getInnerLocations() -> [LocationModel] {
        switch self {
        case .Seoul:
            return SeoulLocation.toLocationModel()
        case .Gyeonggi:
            return GyeonggiLocation.toLocationModel()
        case .Incheon:
            return IncheonLocation.toLocationModel()
        case .Daejeon:
            return DaejeonLocation.toLocationModel()
        case .Sejong:
            return SejongLocation.toLocationModel()
        case .Chungnam:
            return ChungnamLocation.toLocationModel()
        case .Chungbuk:
            return ChungbukLocation.toLocationModel()
        case .Gwangju:
            return GwangjuLocation.toLocationModel()
        case .Jeonnam:
            return JeonnamLocation.toLocationModel()
        case .Jeonbuk:
            return JeonbukLocation.toLocationModel()
        case .Daegu:
            return DaeguLocation.toLocationModel()
        case .Gyeongbuk:
            return GyeongbukLocation.toLocationModel()
        case .Busan:
            return BusanLocation.toLocationModel()
        case .Ulsan:
            return UlsanLocation.toLocationModel()
        case .Gyeongnam:
            return GyeongnamLocation.toLocationModel()
        case .Gangwon:
            return GangwonLocation.toLocationModel()
        case .Jeju:
            return JejuLocation.toLocationModel()
        }
    }
    
}
