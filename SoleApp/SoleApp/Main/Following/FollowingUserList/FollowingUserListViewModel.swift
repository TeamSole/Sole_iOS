//
//  FollowingUserListViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import SwiftUI
import Alamofire

final class FollowingUserListViewModel: ObservableObject {
    typealias FollowList = [FollowListModelResponse.DataModel]
    @Published var followList: FollowList = FollowList()
    @Published var followerList: FollowList = FollowList()
}

extension FollowingUserListViewModel {
    func getFollowList() {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.followList)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: FollowListModelResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true,
                       let list = response.data {
                        self?.followList = list
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
    
    func getFollowerList() {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.followList)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: FollowListModelResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true,
                       let list = response.data {
                        self?.followerList = list
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
}
