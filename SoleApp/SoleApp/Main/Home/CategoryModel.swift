//
//  CategoryModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/21.
//

import Foundation

struct CategoryModelRequest: Codable {
    var placeCategories: [String] = []
    var withCategories: [String] = []
    var transCategories: [String] = []
}
