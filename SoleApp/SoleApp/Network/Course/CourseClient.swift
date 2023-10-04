//
//  CourseClient.swift
//  SoleApp
//
//  Created by SUN on 2023/09/24.
//

import Dependencies
import Alamofire
import Foundation
import UIKit

struct CourseClient {
    var declareCourse: (_ courseId: Int) async throws -> (BaseResponse)
    var getCourseDetail: (_ courseId: Int) async throws -> (CourseDetailModelResponse)
    var removeCourse: (_ courseId: Int) async throws -> (BaseResponse)
    var searchCourse: (_ query: SearchCourseRequest) async throws -> (CourseModelResponse)
    var uploadCourse: (_ parameter: RegisterCourseModelRequest, _ thumbnailImage: UIImage?, _ coursesImages: [[UIImage]]) async throws -> (BaseResponse)
}

extension CourseClient: DependencyKey {
    static var liveValue: CourseClient = CourseClient(
        declareCourse: { courseId in
            let request = API.makeDataRequest(CourseTarget.declareCourse(courseId: courseId))
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: BaseResponse.self)
        },
        getCourseDetail: { courseId in
            let request = API.makeDataRequest(CourseTarget.getCourseDetail(courseId: courseId))
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: CourseDetailModelResponse.self)
        },
        removeCourse: { courseId in
            let request = API.makeDataRequest(CourseTarget.removeCourse(courseId: courseId))
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: BaseResponse.self)
        },
        searchCourse: { query in
            let request = API.makeDataRequest(CourseTarget.searchCourse(query: query))
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: CourseModelResponse.self)
        },
        uploadCourse: { parameter, thumbnailImage, coursesImages in
            let url = K.baseUrl + K.Path.courses
            let headers = K.Header.multiplatformHeader
            
            let data = try await API.session.upload(multipartFormData: { multipart in
                let data = try? JSONEncoder().encode(parameter)
                multipart.append(data!, withName: "courseRequestDto")
                if let image = thumbnailImage?.jpegData(compressionQuality: 0.1) {
                    multipart.append(image, withName: "thumbnailImg", fileName: "\(image).jpeg", mimeType: "multipart/form-data")
                }
                for r in 0..<(coursesImages.count) {
                    for c in 0..<(coursesImages[r].count) {
                        if let image = coursesImages[r][c].jpegData(compressionQuality: 0.1) {
                            multipart.append(image, withName: "\(parameter.placeRequestDtos[r].placeName)", fileName: "\(image).jpeg", mimeType: "multipart/form-data")
                        }
                    }
                }
            }, to: url, method: .post, headers: headers)
                .validate()
                .serializingData()
                .value
            return try API.responseDecodeToJson(data: data, response: BaseResponse.self)
        }
    )
}

extension DependencyValues {
    var courseClient: CourseClient {
        get { self[CourseClient.self] }
        set { self[CourseClient.self] = newValue }
    }
}
