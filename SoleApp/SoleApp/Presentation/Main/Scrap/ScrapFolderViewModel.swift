//
//  ScrapFolderViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/19.
//

import SwiftUI
import Alamofire

final class ScrapFolderViewModel: ObservableObject {
    typealias Folders = [ScrapFolderResponseModel.DataModel]
    
    @Published var folders = Folders()
}


extension ScrapFolderViewModel {
    func getFolders() {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.folderList)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: ScrapFolderResponseModel.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true,
                       let list = response.data {
                        self?.folders = list
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
    
    func addFolder(folderName: String) {
        guard folderName.isEmpty == false else { return }
        let parameter = ScrapAddFolderModelRequest(scrapFolderName: folderName)
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.folderList)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: BaseResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true {
                        self?.getFolders()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
}
