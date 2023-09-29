//
//  CourseClient.swift
//  SoleApp
//
//  Created by SUN on 2023/09/24.
//

import Dependencies

struct CourseClient {
    var getCourseDetail: (_ courseId: Int) async throws -> (CourseDetailModelResponse)
    var removeCourse: (_ courseId: Int) async throws -> (BaseResponse)
    var searchCourse: (_ query: SearchCourseRequest) async throws -> (CourseModelResponse)
}

extension CourseClient: DependencyKey {
    static var liveValue: CourseClient = CourseClient(
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
        })
}

extension DependencyValues {
    var courseClient: CourseClient {
        get { self[CourseClient.self] }
        set { self[CourseClient.self] = newValue }
    }
}
