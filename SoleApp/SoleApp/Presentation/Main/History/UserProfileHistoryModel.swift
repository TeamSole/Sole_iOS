//
//  UserProfileHistoryModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import Foundation


struct UserProfileHistoryModelResponse: Codable {
    let data: DataModel?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable {
        var totalCourses: Int?
        var nickname: String?
        var totalDate: Int?
        var totalPlaces: Int?
    }
}
