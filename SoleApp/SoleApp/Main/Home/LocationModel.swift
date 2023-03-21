//
//  LocationModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/21.
//

import Foundation


struct LocationModelRequest: Codable {
    var latitude: Double
    var longitude: Double
}

struct LocationModelResponse: Codable {
    let data: DataModel?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable {
        var currentGps: CurrentGps?
    }
    struct CurrentGps: Codable {
        var address: String? = "서울 마포구"
        var latitude: Double?
        var longitude: Double?
        
    }
}
