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
        var distance: Double?
        var categories: [String]?
        var duration: Int?
        var like: Bool?
        var thumbnailImg: String?
        var title: String?
    }
}

extension ScrapListModelResponse.DataModel {
    var cateogoryTitles: [String] {
        guard let categories = categories,
              categories.isEmpty == false else { return [] }
        if categories.count < 4 {
            return categories.map { Category(rawValue: $0)?.title ?? "" }
        } else {
            var data: [String] = []
            for index in 0..<4 {
                data.append(Category(rawValue: categories[index])?.title ?? "")
            }
            return data
        }
    }
    var scaledDistance: String {
        guard let distance = distance else { return "" }
        return String(format: "%.2fkm", distance)
    }
}
