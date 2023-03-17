//
//  Utility.swift
//  SoleApp
//
//  Created by SUN on 2023/03/17.
//

import Foundation

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
    
}
