//
//  SignUpFirstStepViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/02/10.
//

import Foundation

final class SignUpFirstStepViewModel: ObservableObject {
    @Published var isSelectedFirstTerm: Bool = false
    @Published var isSelectedSecondTerm: Bool = false
    @Published var isSelectedThirdTerm: Bool = false
}
