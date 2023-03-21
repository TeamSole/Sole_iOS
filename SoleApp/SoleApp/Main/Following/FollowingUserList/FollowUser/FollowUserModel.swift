//
//  FollowUserModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/21.
//

import Foundation

struct FollowUserModelResponse: Codable {
    
    let data: DataModel?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable {
        var followId: Int?
        var followStatus: String?
        var followerCount: Int?
        var followingCount: Int?
        var memberId: Int?
        var description: String?
        var nickname: String?
        var profileImg: String?
        var popularCourse: Place?
        var recentCourses: [Place]?
    }
    
    struct Place: Codable {
        var courseId: Int?
        var address: String?
        var categories: [String]?
        var thumbnailImg: String?
        var distance: Double?
        var duration: Int?
        var finalPage: Bool?
        var like: Bool?
        var title: String?
    }
    
}

extension FollowUserModelResponse.DataModel {
    var isFollowing: Bool {
        return followStatus == "FOLLOWING"
    }
}

extension FollowUserModelResponse.Place{
    var isScrapped: Bool {
        return like == true
    }
    
    var cateogoryTitles: [String] {
        guard let categories = categories,
              categories.isEmpty == false else { return [] }
        return categories.map { Category(rawValue: $0)?.title ?? "" }
    }
    
    var scaledDistance: String {
        guard let distance = distance else { return "" }
        return String(format: "%.2fkm", distance)
    }
}
