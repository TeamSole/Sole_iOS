//
//  BaseResonse.swift
//  SoleApp
//
//  Created by SUN on 2023/03/19.
//

import Foundation

struct BaseResponse: APIResponse {
    var message: String?
    var code: String?
    let status: Int
    let success: Bool
}
