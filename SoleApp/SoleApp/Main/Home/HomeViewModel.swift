//
//  HomeViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/21.
//

import SwiftUI
import CoreLocation
import Alamofire

final class HomeViewModel: NSObject, ObservableObject {
    typealias RecommendCourse = RecommendCourseModel.DataModel
    typealias Course = CourseModelResponse.DataModel
    var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var recommendCourses: [RecommendCourse] = []
    @Published var courses: [Course] = []
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
}

extension HomeViewModel {
    func getRecommendCourses() {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.recommendCourse)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: RecommendCourseModel.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true,
                       let data = response.data {
                        self?.recommendCourses = data
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
    
    func getCourses() {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.courses)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: CourseModelResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true,
                       let data = response.data {
                        self?.courses = data
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
    
}

extension HomeViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
                    print("위도: \(location.coordinate.latitude)")
                    print("경도: \(location.coordinate.longitude)")
                }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
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

//func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//    switch manager.authorizationStatus {
//    case .authorizedWhenInUse:
//        authorizationStatus = .authorizedWhenInUse
//        locationManager.requestLocation()
//        break
//
//    case .restricted:
//        authorizationStatus = .restricted
//        break
//
//    case .denied:
//        authorizationStatus = .denied
//        break
//
//    case .notDetermined:
//        authorizationStatus = .notDetermined
//        manager.requestWhenInUseAuthorization()
//        break
//
//    default:
//        break
//    }
//}
//func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .restricted, .denied:
//            self.locationManager.requestWhenInUseAuthorization()
//        default:
//            locationManager.startUpdatingLocation()
//        }
//    }
//
//func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//}
//
//struct LocationView: View {
//    @StateObject var locationDataManager = LocationDataManager()
//       var body: some View {
//           VStack {
//               switch locationDataManager.locationManager.authorizationStatus {
//               case .authorizedWhenInUse:  // Location services are available.
//                   // Insert code here of what should happen when Location services are authorized
//                   Text("Your current location is:")
//                   Text("Latitude: \(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")")
//                   Text("Longitude: \(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")")
//
//               case .restricted, .denied:  // Location services currently unavailable.
//                   // Insert code here of what should happen when Location services are NOT authorized
//                   Text("Current location data was restricted or denied.")
//               case .notDetermined:        // Authorization not determined yet.
//                   Text("Finding your location...")
//                   ProgressView()
//               default:
//                   ProgressView()
//               }
//           }
//       }
//}
//
//class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
//    var locationManager = CLLocationManager()
//    @Published var authorizationStatus: CLAuthorizationStatus?
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        switch manager.authorizationStatus {
//        case .authorizedWhenInUse:  // Location services are available.
//            // Insert code here of what should happen when Location services are authorized
//            authorizationStatus = .authorizedWhenInUse
//            locationManager.requestLocation()
//            break
//
//        case .restricted:  // Location services currently unavailable.
//            // Insert code here of what should happen when Location services are NOT authorized
//            authorizationStatus = .restricted
//            break
//
//        case .denied:  // Location services currently unavailable.
//            // Insert code here of what should happen when Location services are NOT authorized
//            authorizationStatus = .denied
//            break
//
//        case .notDetermined:        // Authorization not determined yet.
//            authorizationStatus = .notDetermined
//            manager.requestWhenInUseAuthorization()
//            break
//
//        default:
//            break
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        // Insert code to handle location updates
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("error: \(error.localizedDescription)")
//    }
//
//
//}
//
//
//struct LocationView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationView()
//    }
//}


