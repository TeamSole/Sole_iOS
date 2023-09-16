//
//  ScrapTarget.swift
//  SoleApp
//
//  Created by SUN on 2023/09/10.
//

import Alamofire

enum ScrapTarget {
    case addFolder(ScrapAddFolderModelRequest)
    case getScrapFolderList
    case scrap(courseId: Int)
}

extension ScrapTarget: TargetType {
    var baseURL: String {
        return K.baseUrl
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .addFolder:
            return .post
            
        case .getScrapFolderList:
            return .get
            
        case .scrap:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .addFolder:
            return K.Path.folderList
            
        case .getScrapFolderList:
            return K.Path.folderList
            
        case .scrap(let courseId):
            return K.Path.couseScrap(courseId: courseId)
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
        case .addFolder(let parameter):
            return .body(parameter)
            
        case .getScrapFolderList:
            return .body(nil)
            
        case .scrap:
            return .body(nil)
        }
    }
    
    
}
