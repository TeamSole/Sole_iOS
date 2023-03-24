//
//  FollowUserViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/21.
//

import SwiftUI
import Alamofire

final class FollowUserViewModel: ObservableObject {
    typealias UserDetail = FollowUserModelResponse.DataModel
    typealias Course = FollowUserModelResponse.Place
    
    @Published var userDetail: UserDetail = UserDetail()
    @Published var popularCourse: Course? = nil
    @Published var recentCourses: [Course]? = []
    @Published var callingRequest: Bool = false
    
}

extension FollowUserViewModel {
    func getUserDetail(socialId: String) {
        guard socialId.isEmpty == false else { return }
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.boardList + "/\(socialId)")!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: FollowUserModelResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true,
                       let data = response.data {
                        self?.userDetail = data
                        self?.popularCourse = data.popularCourse
                        self?.recentCourses = data.recentCourses
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
    
    func getNextUserDetail(socialId: String) {
        guard socialId.isEmpty == false,
              recentCourses?.last?.finalPage == false,
              callingRequest == false else { return }
        callingRequest = true
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.boardList + "/\(socialId)?courseId=\(recentCourses?.last?.courseId ?? 0)")!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: FollowUserModelResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true,
                       let data = response.data?.recentCourses {
                        self?.recentCourses! += data
                    }
                    self?.callingRequest = false
                case .failure(let error):
                    self?.callingRequest = false
                    print(error.localizedDescription)
                }
            })
    }
    
    func follow(memberId: Int) {
        guard memberId != 0 else { return }
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.follow(memberId: memberId))!
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
