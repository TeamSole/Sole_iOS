//
//  RefreshModel.swift
//  SoleApp
//
//  Created by SUN on 2023/08/26.
//

import Foundation

struct RefreshModel: APIResponse {
    struct DataInfo: Codable {
        let accessToken: String
        let refreshToken: String
    }
    var status: Int
    var success: Bool
    var message: String?
    var code: String?
    var data: DataInfo?
}
