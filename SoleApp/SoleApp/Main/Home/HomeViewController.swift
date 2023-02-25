//
//  HomeViewController.swift
//  SoleApp
//
//  Created by SUN on 2023/02/17.
//

import UIKit
import NMapsMap
import FloatingPanel

final class HomeViewController: UIViewController {
    private var fcp: FloatingPanelController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
        setupFcp()
    }
    
    private func setupFcp() {
        fcp = FloatingPanelController()
        fcp.delegate = self
        fcp.set(contentViewController: FloatingListViewController())
        fcp.addPanel(toParent: self)
        fcp.layout = FloatingListPanelLayout()
        fcp.show()
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

extension HomeViewController: FloatingPanelControllerDelegate {

}
