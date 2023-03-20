//
//  HistoryViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import SwiftUI
import Alamofire

final class HistoryViewModel: ObservableObject {
    typealias ProfileDescription = UserProfileHistoryModelResponse.DataModel
    typealias Histories = [HistoryModelResponse.DataModel]
//    typealias History
    @Published var profileDescription = ProfileDescription()
    @Published var histories: Histories = Histories()
    @Published var apiRequestStatus: Bool = false
}

extension HistoryViewModel {
    func getUserProfile() {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.userProfileInHistory)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: UserProfileHistoryModelResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true,
                       let data = response.data {
                        self?.profileDescription = data
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
    
    func getUserHistoies() {
        guard apiRequestStatus == false else { return }
        apiRequestStatus = true
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.userHistory)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: HistoryModelResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true,
                       let data = response.data {
                        self?.histories = data
                    }
                    self?.apiRequestStatus = false
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.apiRequestStatus = false
                }
            })
    }
}
