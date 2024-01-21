//
//  LocationModel.swift
//  SoleApp
//
//  Created by SUN on 1/20/24.
//

import Foundation

struct LocationModel {
    /// 지역 명
    var locationName: String
    /// 지역 코드
    var locationCode: String
    /// 상위 지역명
    var mainLocationName: String
    /// 전체 지역 코드
    var mainLocationPrefixCode: String
    /// 전체지역인지 확인하는 플래그
    var isWholeLocation: Bool
    /// 전체지역일 경우 사용되는 전체 지역 코드
    var wholeLoactionCode: [String]

    init(locationName: String,
         locationCode: String,
         mainLocationName: String,
         mainLocationPrefixCode: String,
         isWholeLocation: Bool,
         wholeLoactionCode: [String]) {
        self.locationName = locationName
        self.locationCode = locationCode
        self.mainLocationName = mainLocationName
        self.mainLocationPrefixCode = mainLocationPrefixCode
        self.isWholeLocation = isWholeLocation
        self.wholeLoactionCode = wholeLoactionCode
    }
}
