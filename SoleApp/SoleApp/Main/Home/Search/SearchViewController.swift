//
//  SearchViewController.swift
//  SoleApp
//
//  Created by SUN on 2023/03/01.
//

import UIKit

final class SearchViewController: UIViewController {
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색"
        return searchBar
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.gray_404040, for: .normal)
        button.titleLabel?.font = .pretendardRegular(size: 14)
        button.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.hidesBackButton = true
    }
    
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
}
 
