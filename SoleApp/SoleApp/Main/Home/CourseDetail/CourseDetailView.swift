//
//  CourseDetailView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/08.
//

import UIKit
import NMapsMap
import SnapKit

final class CourseDetailView: UIViewController {
    private let mapView = NMFMapView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationUI(title: "")
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        [mapView].forEach({ view.addSubview($0) })
        
        mapView.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(300.0)
        })
    }
    
}
