//
//  UINavigationControllerExtension.swift
//  SoleApp
//
//  Created by SUN on 2023/03/01.
//

import UIKit

extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}
