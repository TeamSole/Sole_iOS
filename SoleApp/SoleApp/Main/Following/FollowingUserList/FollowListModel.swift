//
//  FollowListModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import Foundation


struct FollowListModelResponse: Codable {
    let data: [DataModel]?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable {
        var followId: Int?
        var followStatus: String?
        var followerCount: Int?
        var followingCount: Int?
        var member: Member?
    }
    
    struct Member: Codable {
        var memberId: Int?
        var nickname: String?
        var profileImgUrl: String?
        var socialId: String?
    }
}
