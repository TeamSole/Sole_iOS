//
//  ScrapFolderModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import Foundation

struct ScrapFolderResponseModel: Codable {
    let data: [DataModel]?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable {
        var scrapFolderId: Int?
        var scrapFolderName: String?
    }
}
