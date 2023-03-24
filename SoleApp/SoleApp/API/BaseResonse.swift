//
//  BaseResonse.swift
//  SoleApp
//
//  Created by SUN on 2023/03/19.
//

import Foundation

struct BaseResponse: Codable {
    let status: Int
    let success: Bool
    let message: String?
    let code: String?
}
