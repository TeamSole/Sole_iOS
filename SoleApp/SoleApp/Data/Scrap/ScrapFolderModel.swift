//
//  ScrapFolderModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import Foundation

struct ScrapFolderResponseModel: APIResponse {
    var message: String?
    var code: String?
    let data: [DataModel]?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable, Equatable {
        var scrapFolderId: Int?
        var scrapFolderName: String?
        var scrapFolderImg: String?
    }
}
