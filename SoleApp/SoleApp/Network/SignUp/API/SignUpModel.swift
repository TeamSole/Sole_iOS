//
//  SignUpModel.swift
//  SoleApp
//
//  Created by SUN on 2023/02/25.
//

import Foundation

struct SignUpModel: Codable, Equatable {
    var infoAccepted: Bool = false
    var marketingAccepted: Bool = false
    var serviceAccepted: Bool = false
    var locationAccepted: Bool = false
    var nickname: String = ""
    var accessToken: String = ""
    var fcmToken: String = ""
    var platform: String = ""
}


struct SignUpModelResponse: Codable, Sendable, Equatable {
    let data: DataClass?
    let status: Int
    let success: Bool
}

// MARK: - DataClass
struct DataClass: Codable, Equatable {
    let accessToken: String?
    let check: Bool?
    let memberId: Int?
    let nickname: String?
    let profileImgUrl: String?
    let refreshToken: String?
    let role: String?
    let social: String?
    let socialId: String?
}
