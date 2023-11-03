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
}
