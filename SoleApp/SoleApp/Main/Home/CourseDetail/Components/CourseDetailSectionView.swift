//
//  CourseDetailSectionView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/12.
//

import UIKit
import SnapKit

final class CourseDetailSectionView: UIView {
    let model: [String] = ["1", "2", "3", "4"]
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "코스 상세보기"
        label.textColor = .black
        label.font = .pretendardBold(size: 14.0)
        label.textAlignment = .left
        return label
    }()
    
    private let expandButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow_down"), for: .normal)
        button.setImage(UIImage(named: "arrow_up"), for: .selected)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(CourseDetailTableViewCell.self, forCellReuseIdentifier: "CourseDetailTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        [headerTitleLabel,
         expandButton,
        tableView].forEach({ addSubview($0) })
        
        headerTitleLabel.snp.makeConstraints({
            $0.top.leading.equalToSuperview()
            $0.trailing.equalTo(expandButton.snp.leading)
        })
        
        expandButton.snp.makeConstraints({
            $0.centerY.equalTo(headerTitleLabel.snp.centerY)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(24.0)
        })
        
        tableView.snp.makeConstraints({
            $0.top.equalTo(headerTitleLabel).offset(16.0)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(tableView.contentSize.height * CGFloat(model.count))
        })
    }
}

extension CourseDetailSectionView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseDetailTableViewCell", for: indexPath) as! CourseDetailTableViewCell
        return cell
    }
    
    
}
