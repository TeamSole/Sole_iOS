//
//  MyPageClient.swift
//  SoleApp
//
//  Created by SUN on 2023/08/27.
//

import ComposableArchitecture
import Alamofire

struct MyPageClient {
    var getAccountInfo: () async throws -> (MyPageResponse)
    var logOut: () async throws -> (BaseResponse)
}

extension MyPageClient: DependencyKey {
    static var liveValue: MyPageClient = MyPageClient (
        getAccountInfo: {
            let request = API.makeDataRequest(MyPageTarget.accountInfo, isNeedInterceptor: false)
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: MyPageResponse.self)
            
        },
        logOut: {
            let request = API.makeDataRequest(MyPageTarget.logOut)
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

