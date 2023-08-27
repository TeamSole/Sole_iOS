//
//  APIResponse.swift
//  SoleApp
//
//  Created by SUN on 2023/08/26.
//

import Foundation

protocol APIResponse: Codable, Equatable {
    var status: Int { get }
    var success: Bool { get }
    var message: String? { get }
    var code: String? { get }
}
