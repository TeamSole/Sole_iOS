//
//  SearchCourseRequest.swift
//  SoleApp
//
//  Created by SUN on 2023/09/24.
//

import Foundation

struct SearchCourseRequest: Codable {
    var searchWord: String = ""
    var courseId: Int?
    var placeCategories: String?
    var withCategories: String?
    var transCategories: String?
    var regions: String?
}
