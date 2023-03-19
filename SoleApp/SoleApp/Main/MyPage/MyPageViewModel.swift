//
//  MyPageViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/02/28.
//

import SwiftUI
import Alamofire

enum MyPageCell: CaseIterable {
    case setPush
    case notice
    case faq
    case inquiry
    case terms
    case privacyPolicy
    case version
    
    var leftTitle: String {
        switch self {
        case .setPush:
            return "알림 설정"
        case .notice:
            return "공지사항"
        case .faq:
            return "FAQ"
        case .inquiry:
            return "문의하기"
        case .terms:
            return "이용약관"
        case .privacyPolicy:
            return "개인정보 처리방침"
        case .version:
            return "버전"
        }
    }
    
    var rightTitle: String {
        switch self {
        case .version:
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        default:
            return ""
        }
    }
}

final class MyPageViewModel: ObservableObject {
    typealias AccountInfo = MyPageResponse.DataModel
    var myPageViewCellData = MyPageCell.allCases
    
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
    
    func logout(complete: @escaping () -> ()) {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.logout)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .patch, headers: headers)
            .validate()
            .responseDecodable(of: BaseResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true {
                        self?.resetToken()
                        complete()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
       
    }
    
    private func resetToken() {
        Utility.delete(key: Constant.token)
        Utility.delete(key: Constant.refreshToken)
        Utility.delete(key: Constant.loginPlatform)
        Utility.delete(key: Constant.profileImage)
    }
}
