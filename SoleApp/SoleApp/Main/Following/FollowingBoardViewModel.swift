//
//  FollowingBoardViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import SwiftUI
import Alamofire

final class FollowingBoardViewModel: ObservableObject {
    typealias FollowingBoardList = [FollowBoardModelResponse.DataModel]
    
    
    @Published var boardList: FollowingBoardList = FollowingBoardList()
    @Published var apiRequestStatus: Bool = false
}

extension FollowingBoardViewModel {
    func getFollowingBoardList() {
        guard apiRequestStatus == false else { return }
        apiRequestStatus = true
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.boardList)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: FollowBoardModelResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true,
                       let list = response.data {
                        self?.boardList = list
                    }
                    self?.apiRequestStatus = false
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.apiRequestStatus = false
                }
            })
    }
    
    func scrap(courseId: Int) {
        guard courseId != 0 else { return }
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.couseScrap(courseId: courseId))!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: BaseResponse.self, completionHandler: { response in
                switch response.result {
                case .success(let response):
                    if response.success == true {
                       
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
}

