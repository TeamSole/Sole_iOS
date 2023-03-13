//
//  CourseDetailView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/08.
//

import UIKit
import NMapsMap
import SnapKit

final class CourseDetailViewController: UIViewController {
    private let mapView = NMFMapView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let profileSectionView = ProfileSectionView(frame: .zero)
    private let courseSummarySectionView = CourseSummarySectionView(frame: .zero)
    private let courseDetailSectionView = CourseDetailSectionView(frame: .zero)
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray_EDEDED
        return view
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0.0
        return stackView
    }()
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
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints({
            $0.edges.equalTo(contentView)
        })
        
        [mapView,
         profileSectionView,
         courseSummarySectionView,
         dividerView,
         courseDetailSectionView].forEach({ stackView.addArrangedSubview($0) })
        
        mapView.snp.makeConstraints({
            $0.height.equalTo(300.0)
        })
        
        profileSectionView.snp.makeConstraints({
            $0.height.equalTo(72.0)
        })
        
        dividerView.snp.makeConstraints({
            $0.height.equalTo(3.0)
        })

    }
    
}
