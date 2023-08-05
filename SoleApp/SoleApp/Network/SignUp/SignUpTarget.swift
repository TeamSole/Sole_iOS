//
//  SignUpTarget.swift
//  SoleApp
//
//  Created by SUN on 2023/08/05.
//

import Foundation
import Alamofire

enum SignUpTarget {
    case checkAleardyMember(CheckExistAccountRequest, String)
}

extension SignUpTarget: TargetType {
    var baseURL: String {
        return K.baseUrl
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        switch self {
        case .checkAleardyMember(_, let platform):
            return K.Path.checkExistAccount + "\(platform)"
        }
    }
    
    var headers: HTTPHeaders {
        return K.Header.jsonHeader
    }
    
    var parameters: RequestParams {
        switch self {
        case .checkAleardyMember(let parameter, _):
            return .body(parameter)
        }
    }
    
    
}

