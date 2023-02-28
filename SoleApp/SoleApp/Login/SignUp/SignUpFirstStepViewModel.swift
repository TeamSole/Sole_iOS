//
//  SignUpFirstStepViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/02/10.
//

import Combine

final class SignUpFirstStepViewModel: ObservableObject {
    @Published var isSelectedFirstTerm: Bool = false
    @Published var isSelectedSecondTerm: Bool = false
    @Published var isSelectedThirdTerm: Bool = false
    @Published var isAvailableNickname: Bool? = nil
    var isValidToAgreeOfTerms: AnyPublisher<(Bool, Bool), Never> {
        return Publishers.CombineLatest3($isSelectedFirstTerm, $isSelectedSecondTerm, $isSelectedThirdTerm)
            .map({ first, second, third in
                (first && second, first && second && third) })
            .eraseToAnyPublisher()
    }
}
