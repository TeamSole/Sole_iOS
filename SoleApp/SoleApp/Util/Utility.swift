//
//  Utility.swift
//  SoleApp
//
//  Created by SUN on 2023/03/17.
//

import Foundation
import UIKit

final class Utility {
    class func save(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    class func load(key: String) -> String {
        if let value = UserDefaults.standard.string(forKey: key) {
            return value
        } else {
            return ""
        }
    }
    
    class func delete(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    // MARK: 외부 브라우저(사파리) 사용
    class func openUrlWithSafari(url: String, _ complete: (() -> Void)? = nil) {
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url, options: [:]) { result in
            complete?()
        }
    }
}
