//
//  ScrapAddFolderModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import Foundation

struct ScrapAddFolderModelRequest: Codable {
    var scrapFolderName: String
}

struct ScrapAddFolderModelResponse: Codable {
    var scrapFolderName: String
}
