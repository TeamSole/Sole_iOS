//
//  UIViewController.swift
//  SoleApp
//
//  Created by SUN on 2023/02/11.
//

import UIKit

extension UIViewController {
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = viewControllerToPresent
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        } else {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    func setupNavigationUI(title: String) {
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationItem.title = title
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "arrow_back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arrow_back")
    }
}
