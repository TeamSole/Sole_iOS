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

struct LocationModelResponse: APIResponse {
    var message: String?
    var code: String?
    let data: DataModel?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable, Equatable {
        var currentGps: CurrentGps?
    }
    struct CurrentGps: Codable, Equatable {
        var address: String? = "서울 마포구"
        var latitude: Double?
        var longitude: Double?
        
    }
}
