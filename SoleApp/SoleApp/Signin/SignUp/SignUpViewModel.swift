//
//  SignUpViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/17.
//

import Foundation
import Alamofire

final class SignUpViewModel: ObservableObject {
    var model: SignUpModel = SignUpModel()
    
    @Published var isSelectedFirstTerm: Bool = false
    @Published var isSelectedSecondTerm: Bool = false
    @Published var isSelectedThirdTerm: Bool = false
    @Published var isAvailableNickname: Bool? = nil
    
    var isSelectedAllTerms: Bool {
        return isSelectedFirstTerm && isSelectedSecondTerm && isSelectedThirdTerm
    }
    
    var isValidCheckingTerms: Bool {
        return isSelectedFirstTerm && isSelectedSecondTerm
    }
    var loginType: String = ""
    
    
}

extension SignUpViewModel {
    func didTapCheckAllTerms() {
        if isSelectedAllTerms {
            isSelectedFirstTerm = false
            isSelectedSecondTerm = false
            isSelectedThirdTerm = false
        } else {
            isSelectedFirstTerm = true
            isSelectedSecondTerm = true
            isSelectedThirdTerm = true
        }
    }
    
    func isValidNickName(name: String) {
        guard name.isEmpty == false else {
            isAvailableNickname = false
            return }
        
        guard name.count <= 10 else {
            isAvailableNickname = false
            return }
        
        let url: Alamofire.URLConvertible = URL(string:  K.baseUrl + "api/members/nickname")!
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        let parameter = ["nickname": name]
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: header)
            .validate()
            .response { [weak self] response in
                switch response.result {
                case .success(let response):
                    let valid = String(decoding: response ?? Data(), as: UTF8.self)
                    self?.isAvailableNickname = valid == "false"
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
    }
}
