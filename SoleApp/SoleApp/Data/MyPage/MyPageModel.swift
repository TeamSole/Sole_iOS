//
//  MyPageModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/18.
//

import Foundation

struct MyPageResponse: APIResponse {
    var message: String?
    var code: String?
    let data: DataModel?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable, Equatable {
        var description: String? = ""
        var follower: Int?
        var following: Int?
        var nickname: String? = ""
        var profileImgUrl: String?
        var social: String?
        var socialId: String?
    }
}
