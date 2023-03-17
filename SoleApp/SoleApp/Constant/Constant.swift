//
//  Constant.swift
//  Release
//
//  Created by SUN on 2023/02/19.
//

import Foundation

struct Constant {
    static let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "Kakao App Key") as! String
    static let nmfClientId = Bundle.main.object(forInfoDictionaryKey: "NMFClientId") as! String
    
    static let token: String = "token"
    static let loginPlatform: String = "loginPlatform"
}
