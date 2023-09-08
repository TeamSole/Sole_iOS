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
    @Published var profileImage: UIImage? = nil
    
    func getmyAccountInfo(complete: @escaping () -> ()) {
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
                    complete()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
    
    func changeMyInfo(nickname: String, description: String, complete: @escaping () -> ()) {
        guard nickname.isEmpty == false else { return }
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.myAccountInfo)!
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Authorization": Utility.load(key: Constant.token)
        ]
        let model = EditAccountModelRequest(description: description, nickname: nickname)
        
        AF.upload(multipartFormData: { [weak self] multipart in
            let data = try? JSONEncoder().encode(model)
            multipart.append(data!, withName: "mypageRequestDto")
            if let image = self?.profileImage?.jpegData(compressionQuality: 0.1) {
                multipart.append(image, withName: "multipartFile", fileName: "\(image).jpeg", mimeType: "multipart/form-data")
            }
        }, to: url, method: .put, headers: header)
        .responseDecodable(of: EditAccountModelResponse.self, completionHandler: { [weak self] response in
            switch response.result {
            case .success(let response):
                if let imageUrl = response.data?.profileImgUrl {
                    Utility.save(key: Constant.profileImage, value: imageUrl)
                    self?.profileImage = nil
                }
                complete()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func withdrawal(complete: @escaping () -> ()) {
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
                        complete()
//                        AppDelegate.shared.mainViewModel.existToken = false
//                        AppDelegate.shared.mainViewModel.canShowMain = false
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
}
