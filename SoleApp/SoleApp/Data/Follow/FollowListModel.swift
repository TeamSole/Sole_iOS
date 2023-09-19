//
//  FollowListModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import Foundation


struct FollowListModelResponse: APIResponse {
    var message: String?
    var code: String?
    let data: [DataModel]?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable, Equatable {
        var followId: Int?
        var followStatus: String?
        var followerCount: Int?
        var followingCount: Int?
        var member: Member?
    }
    
    struct Member: Codable, Equatable {
        var memberId: Int?
        var nickname: String?
        var profileImgUrl: String?
        var socialId: String?
    }
}
