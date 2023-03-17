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


struct SignUpModelResponse: Codable {
    let data: DataClass?
    let status: Int
    let success: Bool
}

// MARK: - DataClass
struct DataClass: Codable {
    let accessToken: String?
    let check: Bool?
    let memberId: Int?
    let nickname: String
    let profileImgURL: String?
    let refreshToken: String?
    let role: String?
    let social: String?
    let socialId: String?
}
