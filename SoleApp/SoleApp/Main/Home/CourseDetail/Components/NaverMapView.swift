//
//  NaverMapView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI
import NMapsMap

struct NaverMapView: UIViewRepresentable {
    func makeUIView(context: Context) -> NMFNaverMapView {
        let mapView = NMFNaverMapView()
        return mapView
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
//        let coord = NMGLatLng(lat: coord.1, lng: coord.0)
//        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
//        cameraUpdate.animation = .fly
//        cameraUpdate.animationDuration = 1
//        uiView.mapView.moveCamera(cameraUpdate)}
    }
    
    typealias UIViewType = NMFNaverMapView
    
   
}

struct NaverMapView_Previews: PreviewProvider {
    static var previews: some View {
        NaverMapView()
    }
}
