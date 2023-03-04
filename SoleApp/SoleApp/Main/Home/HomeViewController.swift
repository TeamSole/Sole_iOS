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
        let searchImage = UIImage(named: "search24")?.withRenderingMode(.alwaysOriginal)
        let profileButton = UIButton(type: .custom)
        profileButton.setImage(profileImage, for: .normal)
        profileButton.addTarget(self, action: #selector(moveToMyPage), for: .touchUpInside)
        profileButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: profileButton),
            UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(moveToSearchVC))]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc func moveToMyPage() {
        let vc = MyPageViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moveToSearchVC() {
        let vc = SearchViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: FloatingPanelControllerDelegate {

}
