//
//  ScrapListViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import Foundation
import Alamofire

final class ScrapListViewModel: ObservableObject {
    typealias Scraps = [ScrapListModelResponse.DataModel]
    
    @Published var scraps: Scraps = Scraps()
    @Published var apiRequestStatus: Bool = false
}

extension ScrapListViewModel {
    func getScraps(folderId: Int) {
        guard apiRequestStatus == false else { return }
        apiRequestStatus = true
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.folderList + "/\(folderId)")!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: ScrapListModelResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true,
                       let data = response.data {
                        self?.scraps = data
                    }
                    self?.apiRequestStatus = false
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.apiRequestStatus = false
                }
            })
    }
    
}
