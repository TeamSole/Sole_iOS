//
//  SignUpModel.swift
//  SoleApp
//
//  Created by SUN on 2023/02/25.
//

import Foundation

struct SignUpModel: Codable {
    var infoAccepted: Bool = false
    var marketingAccepted: Bool = false
    var serviceAccepted: Bool = false
    var nickname: String = ""
    var accessToken: String = ""
    var fcmToken: String = ""
}

struct MemberRequestDto: Codable {
    var infoAccepted: Bool = false
    var marketingAccepted: Bool = false
    var serviceAccepted: Bool = false
    var nickname: String = "gg"
}

struct OauthRequest: Codable {
    var accessToken: String = ""
}


struct SignUpModelResponse: Codable {
    var status: Int
    var success: Bool
    var data: DataModel?
}

struct DataModel: Codable {
    var accessToken: String?
    var email: String?
    var memberId: Int?
    var nickname: String?
    var profileImgUrl: String?
    var refreshToken: String?
    var role: String?
    var social: String?
}
