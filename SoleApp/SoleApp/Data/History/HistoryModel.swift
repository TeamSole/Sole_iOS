//
//  HistoryModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import Foundation
import SwiftUI

struct HistoryModelRequest: Codable {
    var courseId: Int
}


struct HistoryModelResponse: APIResponse {
    var message: String?
    var code: String?
    let data: [DataModel]?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable, Equatable {
        var address: String?
        var courseId: Int?
        var categories: [String]?
        var distance: Double?
        var duration: Int?
        var like: Bool?
        var finalPage: Bool? = false
        var thumbnailImg: String?
        var title: String?
    }
}

extension HistoryModelResponse.DataModel {
    var cateogoryTitles: [String] {
        guard let categories = categories,
              categories.isEmpty == false else { return [] }
        if categories.count < 3 {
            return categories.map { Category(rawValue: $0)?.title ?? "" }
        } else {
            var data: [String] = []
            for index in 0..<3 {
                data.append(Category(rawValue: categories[index])?.title ?? "")
            }
            return data
        }
    }
    
    var scaledDistance: String {
        guard let distance = distance else { return "" }
        return String(format: "%.2fkm", distance)
    }
    
    var computedDuration: String {
        guard let duration = duration else { return "" }
        return duration / 60 == 0
        ? String(format: "%d분 소요", duration%60)
        : String(format: "%d시간 %d분 소요", duration/60, duration%60)
    }
}

