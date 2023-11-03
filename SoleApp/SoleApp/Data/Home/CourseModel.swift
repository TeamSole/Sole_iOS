//
//  CourseModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/21.
//

import Foundation

struct CourseModelRequest: Codable {
    var courseId: Int?
}

struct CourseModelResponse: APIResponse {
    var message: String?
    var code: String?
    let data: [DataModel]?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable, Equatable, Identifiable {
        var id: UUID? = UUID()
        var address: String?
        var courseId: Int?
        var distance: Double?
        var categories: [String]?
        var duration: Int?
        var like: Bool?
        var thumbnailImg: String?
        var finalPage: Bool? = false
        var title: String?
    }
}

extension CourseModelResponse.DataModel {
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
    
    var isScrapped: Bool {
        return like == true
    }
}
