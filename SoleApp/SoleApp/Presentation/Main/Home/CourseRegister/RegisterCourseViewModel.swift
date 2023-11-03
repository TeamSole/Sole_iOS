//
//  RegisterCourseViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/21.
//

import SwiftUI
import Alamofire

final class RegisterCourseViewModel: ObservableObject {
    typealias FullCourse = RegisterCourseModelRequest
    @Published private var thumbnailImage: UIImage? = nil
    @Published private var selectedImages: [[UIImage]] = [[], []]
}

extension RegisterCourseViewModel {
    func uploadCourse(fullCourse: FullCourse, complete: @escaping (() -> ())) {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.courses)!
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "Authorization": Utility.load(key: Constant.token)
        ]
        let subModel = fullCourse
        
        AF.upload(multipartFormData: { [weak self] multipart in
            let data = try? JSONEncoder().encode(subModel)
            multipart.append(data!, withName: "courseRequestDto")
            if let image = self?.thumbnailImage?.jpegData(compressionQuality: 0.1) {
                multipart.append(image, withName: "thumbnailImg", fileName: "\(image).jpeg", mimeType: "multipart/form-data")
            }
            for r in 0..<(self?.selectedImages.count ?? 0) {
                for c in 0..<(self?.selectedImages[r].count ?? 0) {
                    if let image = self?.selectedImages[r][c].jpegData(compressionQuality: 0.1) {
                        multipart.append(image, withName: "\(fullCourse.placeRequestDtos[r].placeName)", fileName: "\(image).jpeg", mimeType: "multipart/form-data")
                    }
                }
            }
        }, to: url, method: .post, headers: headers)
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
}
