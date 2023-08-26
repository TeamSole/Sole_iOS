//
//  CommonAuthenticationCredential.swift
//  SoleApp
//
//  Created by SUN on 2023/08/26.
//

import Alamofire
import Foundation

struct CommonAuthenticationCredential: AuthenticationCredential {
    let accessToken: String
    let refreshToken: String
    let expiredAt: Date
    
    var requiresRefresh: Bool { Date(timeIntervalSinceNow: 60 * 10) > expiredAt }
}
