//
//  AccountSettingViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/19.
//

import SwiftUI
import Alamofire

final class AccountSettingViewModel: ObservableObject {
    typealias AccountInfo = MyPageResponse.DataModel
    
    @Published var accountInfo: AccountInfo = AccountInfo()
    
    func getmyAccountInfo() {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.myAccountInfo)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: MyPageResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    guard let data = response.data else { return }
                    self?.accountInfo = data
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
    
    func changeMyInfo() {
        
    }
    
    func withdrawal() {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.withdrawal)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .delete, headers: headers)
            .validate()
            .responseDecodable(of: BaseResponse.self, completionHandler: { response in
                switch response.result {
                case .success(let response):
                    if response.success == true {
                        Utility.delete(key: Constant.token)
                        Utility.delete(key: Constant.refreshToken)
                        Utility.delete(key: Constant.loginPlatform)
                        Utility.delete(key: Constant.profileImage)
                        AppDelegate.shared.mainViewModel.existToken = false
                        AppDelegate.shared.mainViewModel.canShowMain = false
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
}
