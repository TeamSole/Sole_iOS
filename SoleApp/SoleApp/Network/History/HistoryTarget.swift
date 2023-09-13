//
//  HistoryTarget.swift
//  SoleApp
//
//  Created by SUN on 2023/09/13.
//

import Alamofire

enum HistoryTarget {
    case getUserHistory
}

extension HistoryTarget: TargetType {
    var baseURL: String {
        return K.baseUrl
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getUserHistory:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getUserHistory:
            return K.Path.userProfileInHistory
        }
    }
    
    var headers: Alamofire.HTTPHeaders {
        return [
            "Authorization": Utility.load(key: Constant.token)
        ]
    }
    
    var parameters: RequestParams {
        switch self {
        case .getUserHistory:
            return .body(nil)
        }
    }
    
    
}
