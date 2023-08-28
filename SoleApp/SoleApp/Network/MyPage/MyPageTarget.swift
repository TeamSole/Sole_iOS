//
//  MyPageTarget.swift
//  SoleApp
//
//  Created by SUN on 2023/08/27.
//

import Foundation
import Alamofire

enum MyPageTarget {
    case accountInfo
    case logOut
    case withdrawal
}

extension MyPageTarget: TargetType {
    var baseURL: String {
        return K.baseUrl
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .accountInfo:
            return .get
            
        case .logOut:
            return .patch
            
        case .withdrawal:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .accountInfo:
            return K.Path.myAccountInfo
            
        case .logOut:
            return K.Path.logout
            
        case .withdrawal:
            return K.Path.withdrawal
        }
    }
    
    var headers: Alamofire.HTTPHeaders {
        return [
        ]
    }
    
    var parameters: RequestParams {
        return .body(nil)
    }
    
    
}
