//
//  FollowBoardModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import Foundation

struct FollowBoardModelResponse: APIResponse {
    var message: String?
    var code: String?
    let data: [DataModel]?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable, Equatable {
        var courseId: Int?
        var description: String?
        var like: Bool?
        var nickname: String?
        var profileImg: String?
        var thumbnailImg: String?
        var title: String?
    }
}
