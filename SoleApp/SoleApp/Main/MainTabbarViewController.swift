//
//  MainTabbarViewController.swift
//  SoleApp
//
//  Created by SUN on 2023/02/17.
//

import UIKit

final class MainTabbarViewController: UITabBarController {
    private lazy var homeViewController: UIViewController = {
        let vc = UINavigationController(rootViewController: HomeViewController())
        let tabbarItem = UITabBarItem(title: "홈", image: nil, tag: 0)
        vc.tabBarItem = tabbarItem
        return vc
    }()
    
    private lazy var homeViewController2: UIViewController = {
        let vc = UINavigationController(rootViewController: HomeViewController())
        let tabbarItem = UITabBarItem(title: "홈2", image: nil, tag: 1)
        vc.tabBarItem = tabbarItem
        return vc
    }()
    
    private lazy var homeViewController3: UIViewController = {
        let vc = UINavigationController(rootViewController: HomeViewController())
        let tabbarItem = UITabBarItem(title: "홈3", image: nil, tag: 2)
        vc.tabBarItem = tabbarItem
        return vc
    }()
    
    private lazy var homeViewController4: UIViewController = {
        let vc = UINavigationController(rootViewController: HomeViewController())
        let tabbarItem = UITabBarItem(title: "홈4", image: nil, tag: 3)
        vc.tabBarItem = tabbarItem
        return vc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
        viewControllers = [homeViewController, homeViewController2, homeViewController3, homeViewController4]
    }
    
    private func setupTabbar() {
        tabBar.isTranslucent = false
        if #available(iOS 15, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = .white
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black]
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
            tabBar.standardAppearance = tabBarAppearance
            tabBar.scrollEdgeAppearance = tabBarAppearance
        } else {
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
            tabBar.barTintColor = .white
        }
    }
}
