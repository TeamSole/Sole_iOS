//
//  CourseClient.swift
//  SoleApp
//
//  Created by SUN on 2023/09/24.
//

import Dependencies

struct CourseClient {
    var searchCourse: (_ query: SearchCourseRequest) async throws -> (CourseModelResponse)
}

extension CourseClient: DependencyKey {
    static var liveValue: CourseClient = CourseClient(
        searchCourse: { query in
            let request = API.makeDataRequest(CourseTarget.searchCourse(query: query))
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: CourseModelResponse.self)
        })
}

extension DependencyValues {
    var courseClient: CourseClient {
        get { self[CourseClient.self] }
        set { self[CourseClient.self] = newValue }
    }
}
