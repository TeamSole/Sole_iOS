//
//  RegisterCourseModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/22.
//

import Foundation

struct RegisterCourseModelRequest: Codable {
    var title: String
    var date: String
    var description: String
    var distance: Double
    var placeCategories: [String]
    var transCategories: [String]
    var withCategories: [String]
    var placeRequestDtos: [PlaceRequestDtos]
    
    struct PlaceRequestDtos: Codable {
        var address: String = ""
        var description: String = ""
        var duration: Int = 0
        var placeName: String = ""
        var latitude: Double = 0.0
        var longitude: Double = 0.0
    }
}
