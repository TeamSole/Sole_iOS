//
//  ScrapListModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import Foundation


struct ScrapListModelResponse: Codable {
    let data: [DataModel]?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable {
        var address: String?
        var courseId: Int?
        var distance: Int?
        var duration: Int?
        var like: Bool?
        var thumbnailImg: String?
        var title: String?
    }
}
