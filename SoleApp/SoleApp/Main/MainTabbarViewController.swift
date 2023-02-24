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
        let tabbarItem = UITabBarItem(title: "홈", image: UIImage(named: "home_tap")?.withRenderingMode(.alwaysOriginal), tag: 0)
        tabbarItem.selectedImage = UIImage(named: "home_tap_selected")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem = tabbarItem
        return vc
    }()
    
    private lazy var homeViewController2: UIViewController = {
        let vc = UINavigationController(rootViewController: HomeViewController())
        let tabbarItem = UITabBarItem(title: "나의 기록", image: UIImage(named: "history_tap")?.withRenderingMode(.alwaysOriginal), tag: 1)
        tabbarItem.selectedImage = UIImage(named: "history_tap_selected")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem = tabbarItem
        return vc
    }()
    
    private lazy var homeViewController3: UIViewController = {
        let vc = UINavigationController(rootViewController: HomeViewController())
        let tabbarItem = UITabBarItem(title: "팔로잉", image: UIImage(named: "following_tap")?.withRenderingMode(.alwaysOriginal), tag: 1)
        tabbarItem.selectedImage = UIImage(named: "following_tap_selected")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem = tabbarItem
        return vc
    }()
    
    private lazy var homeViewController4: UIViewController = {
        let vc = UINavigationController(rootViewController: HomeViewController())
        let tabbarItem = UITabBarItem(title: "스크랩", image: UIImage(named: "scrap_tap")?.withRenderingMode(.alwaysOriginal), tag: 1)
        tabbarItem.selectedImage = UIImage(named: "scrap_tap_selected")?.withRenderingMode(.alwaysOriginal)
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
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.blue_4708FA]
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
            tabBar.standardAppearance = tabBarAppearance
            tabBar.scrollEdgeAppearance = tabBarAppearance
        } else {
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue_4708FA], for: .selected)
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
            tabBar.barTintColor = .white
        }
    }
}
