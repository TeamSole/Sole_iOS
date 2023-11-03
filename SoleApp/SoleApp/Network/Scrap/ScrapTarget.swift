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
    case removeScraps(isDefaultFolder: Bool, folderId: Int, scrapsCourseIds: [Int])
    case renameFolder(folderId: Int, ScrapRenameFolderRequest)
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
            
        case .removeFolder, .removeScraps:
            return .delete
            
        case .renameFolder:
            return .patch
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
            
        case .removeFolder(let folderId), .renameFolder(let folderId, _):
            return K.Path.folderList + "/\(folderId)"
            
        case .removeScraps(let isDefaultFolder, let folderId, let scrapsCourseIds):
            let courseIds = scrapsCourseIds.map({ String($0) }).joined(separator: ",")
            return isDefaultFolder
            ? K.Path.folderList + "/default/\(courseIds)"
            : K.Path.folderList + "/\(folderId)/\(courseIds)"
            
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
            
        case .renameFolder(_, let parameter):
            return .body(parameter)
        
        case .scrap, .getScrapFolderList, .getScrapList, .removeFolder, .removeScraps:
            return .body(nil)
        }
    }
    
    
}
