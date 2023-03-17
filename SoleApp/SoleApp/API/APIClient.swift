//
//  APIClient.swift
//  SoleApp
//
//  Created by SUN on 2023/02/25.
//

import Foundation
import Alamofire

struct K {
    static let baseUrl: String = Bundle.main.object(forInfoDictionaryKey: "Base Url") as! String
}

extension K {
    struct Header {
        static let jsonHeader: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        static let multiplatformHeader: HTTPHeaders = [
            "Content-Type" : "multipart/form-data"
        ]
    }
}

extension K {
    struct Path {
        static let validCheckForNickName: String = "api/members/nickname"
        static let signUpApple: String = "api/members/apple/signup"
        static let signUpKakao: String = "api/members/kakao/signup"
    }
}


final class APIClient {
    
}
