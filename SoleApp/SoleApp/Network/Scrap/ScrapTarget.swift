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
    case getScrapList(isDefaultFolder: Bool, folderId: Int)
    case removeFolder(folderId: Int)
    case scrap(courseId: Int)
}

extension ScrapTarget: TargetType {
    var baseURL: String {
        return K.baseUrl
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .addFolder, .scrap:
            return .post
            
        case .getScrapFolderList, .getScrapList:
            return .get
            
        case .removeFolder:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .addFolder, .getScrapFolderList:
            return K.Path.folderList
            
        case .getScrapList(let isDefaultFolder, let folderId):
            return isDefaultFolder ?
            K.Path.folderList + "/default" :
            K.Path.folderList + "/\(folderId)"
            
        case .removeFolder(let folderId):
            return K.Path.folderList + "/\(folderId)"
            
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
        
        case .scrap, .getScrapFolderList, .getScrapList, .removeFolder:
            return .body(nil)
        }
    }
    
    
}
