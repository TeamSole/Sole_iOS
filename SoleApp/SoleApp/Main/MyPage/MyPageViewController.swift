//
//  MyPageViewController.swift
//  SoleApp
//
//  Created by SUN on 2023/02/20.
//

import UIKit
import SnapKit
import SwiftUI

final class MyPageViewController: UIViewController {
    @ObservedObject var viewModel: MyPageViewModel = MyPageViewModel()
    private lazy var listTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.rowHeight = 48.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = myPageHeaderView
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var myPageHeaderView: MyPageTableViewHeader = {
        let header = MyPageTableViewHeader(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 100.0)))
        return header
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationUI(title: "마이페이지")
        let appearance = UINavigationBarAppearance()
//        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(listTableView)
        
        listTableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }

}

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myPageViewCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier, for: indexPath) as? MyPageTableViewCell else { return UITableViewCell()}
        cell.setupCellData(viewModel.myPageViewCellData[indexPath.row])
        return cell
    }
    
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AccountSettingView()
        navigationController?.pushViewController(UIHostingController(rootView: vc), animated: true)
    }
}

