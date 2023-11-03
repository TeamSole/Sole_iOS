//
//  NaverSearchModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import Foundation

struct NaverSearchModel: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]?
    
    struct Item: Codable {
        var title: String?
        var link: String?
        var category: String?
        var description: String?
        var telephone: String?
        var address: String?
        var roadAddress: String?
        var mapx: String?
        var mapy: String?
    }
}

extension NaverSearchModel.Item {
    var resultTitle: String {
        guard let title = title else { return ""}
        return title.replacingOccurrences(of: "</b>", with: "")
            .replacingOccurrences(of: "<b>", with: "")
    }
}


