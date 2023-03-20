//
//  CourseDetailViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import SwiftUI
import Alamofire

final class CourseDetailViewModel: ObservableObject {
    typealias CourseDetail = CourseDetailModelResponse.DataModel
    
    @Published var courseDetail: CourseDetail = CourseDetail()
}

extension CourseDetailViewModel {
    func getCourseDetail(courseId: Int) {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.courseDetail + "\(courseId)")!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: CourseDetailModelResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true,
                       let data = response.data {
                        self?.courseDetail = data
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
    
    func removeCourse(courseId: Int, complete: @escaping () -> ()) {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.courseDetail + "\(courseId)")!
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
                        complete()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
    
    func declareCourse(courseId: Int) {
        guard courseId != 0 else { return }
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.courseDeclare(courseId: courseId))!
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
