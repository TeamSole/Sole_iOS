//
//  CourseEditViewModel.swift
//  Release
//
//  Created by SUN on 2023/03/23.
//

import SwiftUI
import Alamofire


final class CourseEditViewModel: ObservableObject {
    typealias FullCourse = EditCourseModelRequest
    @Published var thumbnailImage: UIImage? = nil
    @Published var selectedImages: [[UIImage]] = Array<[UIImage]>(repeating: [], count: 10)
}

extension CourseEditViewModel {
    func updateCourse(fullCourse: FullCourse, courseId: Int, complete: @escaping (() -> ())) {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.courses + "/\(courseId)")!
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "Authorization": Utility.load(key: Constant.token)
        ]
        let subModel = fullCourse
        
        AF.upload(multipartFormData: { [weak self] multipart in
            let data = try? JSONEncoder().encode(subModel)
            multipart.append(data!, withName: "courseUpdateRequestDto")
            if let image = self?.thumbnailImage?.jpegData(compressionQuality: 0.1) {
                multipart.append(image, withName: "thumbnailImg", fileName: "\(image).jpeg", mimeType: "multipart/form-data")
            }
            for r in 0..<(self?.selectedImages.count ?? 0) {
                for c in 0..<(self?.selectedImages[r].count ?? 0) {
                    if let image = self?.selectedImages[r][c].jpegData(compressionQuality: 0.1) {
                        multipart.append(image, withName: "\(fullCourse.placeUpdateRequestDtos[r].placeName)", fileName: "\(image).jpeg", mimeType: "multipart/form-data")
                    }
                }
            }
        }, to: url, method: .put, headers: headers)
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
