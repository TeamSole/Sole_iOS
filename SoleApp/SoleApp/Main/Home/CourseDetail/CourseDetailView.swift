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
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationUI(title: "")
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)

        scrollView.backgroundColor = .red
        scrollView.snp.makeConstraints({
            $0.edges.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalToSuperview()
        })
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        })
        
        [mapView].forEach({ contentView.addSubview($0) })
        
        mapView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(300.0)
        })

    }
    
}
