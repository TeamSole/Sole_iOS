//
//  HomeViewController.swift
//  SoleApp
//
//  Created by SUN on 2023/02/17.
//

import UIKit
import NMapsMap

final class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        let mapView = NMFMapView(frame: view.frame)
            view.addSubview(mapView)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        let logoImage = UIImage(named: "small_logo")?.withRenderingMode(.alwaysOriginal)
        let profileImage = UIImage(named: "profile24")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(moveToMyPage))
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc func moveToMyPage() {
        let vc = MyPageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
