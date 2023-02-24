//
//  MyPageViewController.swift
//  SoleApp
//
//  Created by SUN on 2023/02/20.
//

import UIKit
import SnapKit

final class MyPageViewController: UIViewController {
    private lazy var listTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationUI(title: "마이페이지")
    }
    
    private func setupUI() {
        view.addSubview(listTableView)
        
        listTableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }

}

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "QnA"
        return cell
    }
    
    
}

