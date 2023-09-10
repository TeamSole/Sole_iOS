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
    var getNextCourses: (CourseModelRequest) async throws -> (CourseModelResponse)
    var getRecommendedCourses: () async throws -> (RecommendCourseModel)
    var setTasty: (CategoryModelRequest) async throws -> (BaseResponse)
}

extension HomeClient: DependencyKey {
    static var liveValue: HomeClient = HomeClient(
        getCourses: {
            let request = API.makeDataRequest(HomeTarget.getCourses)
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: CourseModelResponse.self)
        },
        getNextCourses: { parameter in
            let request = API.makeDataRequest(HomeTarget.getNextCourses(parameter))
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: CourseModelResponse.self)
        },
        getRecommendedCourses: {
            let request = API.makeDataRequest(HomeTarget.getRecommendedCourses)
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: RecommendCourseModel.self)
        },
        
        setTasty: { parameter in
            let request = API.makeDataRequest(HomeTarget.setTasty(parameter))
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: BaseResponse.self)
        }
    )
}

extension DependencyValues {
    var homeClient: HomeClient {
        get { self[HomeClient.self] }
        set { self[HomeClient.self] = newValue }
    }
}
