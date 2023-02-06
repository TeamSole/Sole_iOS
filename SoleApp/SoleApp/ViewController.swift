//
//  ViewController.swift
//  SoleApp
//
//  Created by SUN on 2023/02/06.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        #if Dev
        print("gg")
        #else
        print("33333")
        #endif
    }


}

