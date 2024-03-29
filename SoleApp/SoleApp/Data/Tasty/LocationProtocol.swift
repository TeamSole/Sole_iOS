//
//  LocationProtocol.swift
//  SoleApp
//
//  Created by SUN on 1/17/24.
//

import Foundation

protocol LocationProtocol: CaseIterable {
    var allCode: [String] { get }
    
    var mainLocationName: String { get }
    
    var isWholeLocation: Bool { get }
    
    
}
