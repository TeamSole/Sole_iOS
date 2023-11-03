//
//  CourseEditModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/24.
//

import Foundation


struct EditCourseModelRequest: Codable, Equatable {
    var title: String = ""
    var startDate: String = ""
    var description: String = ""
    var placeCategories: [String] = []
    var transCategories: [String] = []
    var withCategories: [String] = []
    var placeUpdateRequestDtos: [PlaceUpdateRequestDtos] = []
    
    struct PlaceUpdateRequestDtos: Codable, Equatable {
        var address: String = ""
        var description: String = ""
        var duration: Int = 0
        var placeId: Int? = nil
        var placeName: String = ""
        var latitude: Double = 0.0
        var longitude: Double = 0.0
        var placeImgUrls: [String] = []
    }
}
