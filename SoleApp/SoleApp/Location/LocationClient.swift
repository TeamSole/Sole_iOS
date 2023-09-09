//
//  LocationClient.swift
//  SoleApp
//
//  Created by SUN on 2023/09/08.
//

import ComposableArchitecture
import CoreLocation


struct LocationClient {
    var updateLocation: () async throws -> (CLLocationCoordinate2D)
}

extension LocationClient: DependencyKey {
    static let liveValue: LocationClient = LocationClient(
        // 반환 안됨
        updateLocation: {
            let locationManager = LocationManager()
            // 위치정보 반환
            let info = try await locationManager.updateLocation()
            return info
        }
    )
}

extension DependencyValues {
    var locationClient: LocationClient {
        get { self[LocationClient.self] }
        set { self[LocationClient.self] = newValue }
    }
}
