//
//  SearchViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/22.
//

import SwiftUI
import Alamofire

final class SearchViewModel: ObservableObject {
    typealias Course = CourseModelResponse.DataModel
    @Published var courses: [Course] = []
    @Published var title: String = ""
}

extension SearchViewModel {
    func getCourses(keyword: String) {
        guard keyword.isEmpty == false else { return }
        let query: String = K.baseUrl + K.Path.courses + "?searchWord=\(keyword)"
        let encodedQuery: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url: URLConvertible = URL(string: encodedQuery)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: CourseModelResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true,
                       let data = response.data {
                        if data.isEmpty {
                            self?.title = "검색 결과가 없습니다"
                        } else {
                            self?.title = ""
                        }
                        self?.courses = data
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
