//
//  ScrapTarget.swift
//  SoleApp
//
//  Created by SUN on 2023/09/10.
//

import Alamofire

enum ScrapTarget {
    case getScrapFolderList
    case scrap(courseId: Int)
}

extension ScrapTarget: TargetType {
    var baseURL: String {
        return K.baseUrl
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getScrapFolderList:
            return .get
        case .scrap:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getScrapFolderList:
            return K.Path.folderList
        case .scrap(let courseId):
            return K.Path.couseScrap(courseId: courseId)
        }
    }
    
    var headers: Alamofire.HTTPHeaders {
        return [
            "Authorization": Utility.load(key: Constant.token)
        ]
    }
    
    var parameters: RequestParams {
        switch self {
        case .getScrapFolderList:
            return .body(nil)
        case .scrap:
            return .body(nil)
        }
    }
    
    
}
