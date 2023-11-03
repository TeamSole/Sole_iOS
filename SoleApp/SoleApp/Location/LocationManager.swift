//
//  LocationManager.swift
//  SoleApp
//
//  Created by SUN on 2023/09/08.
//

import CoreLocation

final class LocationManager: NSObject {
    let locationManager = CLLocationManager()
    var authorizationStatus: CLAuthorizationStatus?
    var locationCheckedThrowingContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // 위치 반환 함수
    func updateLocation() async throws -> CLLocationCoordinate2D {
        return try await withCheckedThrowingContinuation({ [weak self] (continuation: CheckedContinuation<CLLocationCoordinate2D, Error>) in
            guard let self = self else { return }

            self.locationCheckedThrowingContinuation = continuation
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        })
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 안되는 경우는 여기 호출 안됩니다ㅠ
        guard let location = locations.last else { return }
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
        let locationCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude)
        locationCheckedThrowingContinuation?.resume(returning: locationCoordinate)
        locationCheckedThrowingContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCheckedThrowingContinuation?.resume(throwing: error)
        locationCheckedThrowingContinuation = nil
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
            
        case .restricted:
            authorizationStatus = .restricted
            manager.requestWhenInUseAuthorization()
            break
            
        case .denied:
            authorizationStatus = .denied
            manager.requestWhenInUseAuthorization()
            break
            
        case .notDetermined:
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
}
