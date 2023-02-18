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
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
        viewControllers = [homeViewController, homeViewController2, homeViewController3, homeViewController4]
    }
}
