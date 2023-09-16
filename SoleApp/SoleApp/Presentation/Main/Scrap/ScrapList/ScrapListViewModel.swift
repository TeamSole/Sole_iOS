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
    
//    @Published var scraps: Scraps = Scraps()
    @Published var apiRequestStatus: Bool = false
}

extension ScrapListViewModel {
    func getScraps(isDefaultFolder: Bool, folderId: Int) {
        guard apiRequestStatus == false else { return }
        apiRequestStatus = true
        let url: URLConvertible = isDefaultFolder
        ? URL(string: K.baseUrl + K.Path.folderList + "/default")!
        : URL(string: K.baseUrl + K.Path.folderList + "/\(folderId)")!
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
//                        self?.scraps = data
                    }
                    self?.apiRequestStatus = false
                case .failure(let error):
                    print(error)
                    self?.apiRequestStatus = false
                }
            })
    }
    
    func renameFolder(folderId: Int, folderName: String, complete: @escaping () -> ()) {
        guard folderName.isEmpty == false else { return }
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.folderList + "/\(folderId)")!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        let parameter = ScrapRenameFolderRequest(scrapFolderName: folderName)
        AF.request(url, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default, headers: headers)
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
    
    func removeFolder(folderId: Int, complete: @escaping () -> ()) {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.folderList + "/\(folderId)")!
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
    
    func removeScraps(isDefaultFolder: Bool, folderId: Int, scraps: [Int], complete: @escaping () -> ()) {
        guard scraps.isEmpty == false else { return }
        let courseIds = scraps.map({ String($0) }).joined(separator: ",")
        let url: URLConvertible = isDefaultFolder
        ? URL(string: K.baseUrl + K.Path.folderList + "/default/\(courseIds)")!
        : URL(string: K.baseUrl + K.Path.folderList + "/\(folderId)/\(courseIds)")!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .delete, headers: headers)
            .validate()
            .responseDecodable(of: BaseResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success:
                    self?.getScraps(isDefaultFolder: isDefaultFolder, folderId: folderId)
                    complete()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
    
   
    
}
