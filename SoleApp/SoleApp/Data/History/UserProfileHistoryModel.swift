//
//  UserProfileHistoryModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import Foundation


struct UserProfileHistoryModelResponse: APIResponse {
    var message: String?
    var code: String?
    let data: DataModel?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable, Equatable {
        var totalCourses: Int?
        var nickname: String?
        var totalDate: Int?
        var totalPlaces: Int?
    }
}
