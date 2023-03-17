//
//  MainViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/17.
//

import SwiftUI

final class MainViewModel: ObservableObject {
    @Published var canShowMain = false
    @Published var existToken = false
}
