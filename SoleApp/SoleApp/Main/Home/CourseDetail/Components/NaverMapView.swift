//
//  NaverMapView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI
import NMapsMap

struct NaverMapView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    typealias Place = CourseDetailModelResponse.DataModel
    @Binding var places: Place
    func makeUIView(context: Context) -> NMFNaverMapView {
        let mapView = NMFNaverMapView()
        mapView.mapView.positionMode = .direction
        mapView.mapView.zoomLevel = 15
        mapView .mapView.addCameraDelegate(delegate: context.coordinator)
        return mapView
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let coord = locations.first ?? NMGLatLng()
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
    
        let polyline = NMFPolylineOverlay(locations)
        polyline?.color = .blue_4708FA
        polyline?.pattern = [6, 3]
        polyline?.mapView = uiView.mapView
        for index in 0..<locations.count {
            let marker = NMFMarker()
            marker.iconImage = NMFOverlayImage(image: UIImage(named: String(format: "mark%d", index + 1)) ?? UIImage())
            marker.position = locations[index]
            marker.mapView = uiView.mapView
        }
        uiView.mapView.moveCamera(cameraUpdate)
       
    }
    
    class Coordinator: NSObject, NMFMapViewCameraDelegate {
        typealias Place = CourseDetailModelResponse.DataModel
       
//        @Binding var places: Place
//            init(_ places: Binding<Place>) {
//                self._places = places
//            }
            
            func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
                print("카메라 변경 - reason: \(reason)")
            }

            func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
                print("카메라 변경 - reason: \(reason)")
            }
        }
    
    typealias UIViewType = NMFNaverMapView
    
    var locations: [NMGLatLng] {
//        guard places.isEmpty == false else { return [] }
        var locations: [NMGLatLng] = []
        for index in 0..<(places.placeResponseDtos?.count ?? 0) {
            locations.append(NMGLatLng(lat: places.placeResponseDtos?[index].latitude ?? 0.0, lng: places.placeResponseDtos?[index].longitude ?? 0.0))
        }
        return locations
    }
}

struct NaverMapView_Previews: PreviewProvider {
    static var previews: some View {
        NaverMapView(places: .constant(CourseDetailModelResponse.DataModel()))
    }
}
