//
//  FollowTarget.swift
//  SoleApp
//
//  Created by SUN on 2023/09/17.
//

import Alamofire

enum FollowTarget {
    case getCoursesOfFollowers
}

extension FollowTarget: TargetType {
    var baseURL: String {
        return K.baseUrl
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getCoursesOfFollowers:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getCoursesOfFollowers:
            return K.Path.boardList
        }
    }
    
    var headers: Alamofire.HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
    }
    
    var parameters: RequestParams {
        switch self {
        case .getCoursesOfFollowers:
            return .body(nil)
        }
    }
    
    
}
