//
//  IndicatorView.swift
//  SoleApp
//
//  Created by SUN on 10/18/23.
//

import UIKit

class IndicatorView {
    static let shared = IndicatorView()
        
    let containerView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    open func show() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        self.containerView.frame = window.frame
        self.containerView.center = window.center
        self.containerView.backgroundColor = .clear
        
        self.containerView.addSubview(self.activityIndicator)
        UIApplication.shared.windows.first?.addSubview(self.containerView)
    }
    
    open func showIndicator() {
        self.containerView.backgroundColor = .clear
        
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.activityIndicator.style = .large
        self.activityIndicator.center = self.containerView.center
        
        self.activityIndicator.startAnimating()
    }
    
    open func dismiss() {
        self.activityIndicator.stopAnimating()
        self.containerView.removeFromSuperview()
    }
}
