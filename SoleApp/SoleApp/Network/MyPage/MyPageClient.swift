//
//  MyPageClient.swift
//  SoleApp
//
//  Created by SUN on 2023/08/27.
//

import ComposableArchitecture
import Alamofire
import UIKit

struct MyPageClient {
    var getAccountInfo: () async throws -> (MyPageResponse)
    var editAccountInfo: (EditAccountModelRequest, UIImage?) async throws -> (EditAccountModelResponse)
    var logOut: () async throws -> (BaseResponse)
    var withdrawal: () async throws -> (BaseResponse)
}

extension MyPageClient: DependencyKey {
    static var liveValue: MyPageClient = MyPageClient (
        getAccountInfo: {
            let request = API.makeDataRequest(MyPageTarget.accountInfo, isNeedInterceptor: false)
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: MyPageResponse.self)
            
        },
        editAccountInfo: { parameter, image in
            
            let url = K.baseUrl + K.Path.myAccountInfo
            var header: HTTPHeaders = K.Header.multiplatformHeader
            header.add(name: "Authorization", value: Utility.load(key: Constant.token))
            
            let data = try await API.session.upload(multipartFormData: { multipart in
                let data = try? JSONEncoder().encode(parameter)
                multipart.append(data!, withName: "mypageRequestDto")
                if let image = image?.jpegData(compressionQuality: 0.1) {
                    multipart.append(image, withName: "multipartFile", fileName: "\(image).jpeg", mimeType: "multipart/form-data")
                }
            }, to: url, method: .put, headers: header)
            .validate()
            .serializingData()
            .value
            
            return try API.responseDecodeToJson(data: data, response: EditAccountModelResponse.self)
        },
        logOut: {
            let request = API.makeDataRequest(MyPageTarget.logOut)
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: BaseResponse.self)
        },
        withdrawal: {
            let request = API.makeDataRequest(MyPageTarget.withdrawal)
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: BaseResponse.self)
        }
    )
}

extension DependencyValues {
    var myPageClient: MyPageClient {
        get { self[MyPageClient.self] }
        set { self[MyPageClient.self] = newValue }
    }
}

