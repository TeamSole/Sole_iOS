//
//  MainViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/17.
//

import SwiftUI
import Combine

// TODO: 파일 삭제
final class MainViewModel: ObservableObject {
    @Published var canShowMain = false
    @Published var existToken = false
    @Published var isFirstSignUp = false
    
    var toastMessageSubject = PassthroughSubject<(String, CGFloat), Never>()
}
