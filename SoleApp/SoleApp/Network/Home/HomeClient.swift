//
//  HomeClient.swift
//  SoleApp
//
//  Created by SUN on 2023/09/08.
//

import Foundation
import ComposableArchitecture

struct HomeClient {
    var getCourses: () async throws -> (CourseModelResponse)
}

extension HomeClient: DependencyKey {
    static var liveValue: HomeClient = HomeClient(
        getCourses: {
            let request = API.makeDataRequest(HomeTarget.getCourses)
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: CourseModelResponse.self)
        }
    )
}

extension DependencyValues {
    var homeClient: HomeClient {
        get { self[HomeClient.self] }
        set { self[HomeClient.self] = newValue }
    }
}
