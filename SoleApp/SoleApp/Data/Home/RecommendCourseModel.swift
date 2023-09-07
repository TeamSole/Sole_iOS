//
//  RecommendCourseModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/21.
//

import Foundation

struct RecommendCourseModel: APIResponse {
    var message: String?
    var code: String?
    let data: [DataModel]?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable, Equatable {
        var courseId: Int?
        var courseName: String?
        var thumbnailImg: String?
    }
}
