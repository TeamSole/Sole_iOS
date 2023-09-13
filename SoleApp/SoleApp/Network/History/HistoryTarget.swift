//
//  HistoryTarget.swift
//  SoleApp
//
//  Created by SUN on 2023/09/13.
//

import Alamofire

enum HistoryTarget {
    case getUserHistories(HistoryModelRequest?)
    case getUserHistoryDescription
}

extension HistoryTarget: TargetType {
    var baseURL: String {
        return K.baseUrl
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getUserHistories:
            return .post
            
        case .getUserHistoryDescription:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getUserHistories:
            return K.Path.userHistory
            
        case .getUserHistoryDescription:
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
        case .getUserHistories(let query):
            return .query(query)
            
        case .getUserHistoryDescription:
            return .body(nil)
        }
    }
    
    
}
