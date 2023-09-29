//
//  CourseTarget.swift
//  SoleApp
//
//  Created by SUN on 2023/09/13.
//

import Foundation
import Alamofire

enum CourseTarget {
    case declareCourse(courseId: Int)
    case getCourseDetail(courseId: Int)
    case removeCourse(courseId: Int)
    case searchCourse(query: SearchCourseRequest)
}

extension CourseTarget: TargetType {
    var baseURL: String {
        return K.baseUrl
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .declareCourse:
            return .post
            
        case .getCourseDetail, .searchCourse:
            return .get
            
        case .removeCourse:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .declareCourse(let courseId):
            return K.Path.courseDeclare(courseId: courseId)
            
        case .getCourseDetail(let courseId):
            return K.Path.courseDetail + "/\(courseId)"
            
        case .removeCourse(let courseId):
            return K.Path.courseDetail + "/\(courseId)"
            
        case .searchCourse:
            return K.Path.courses
        }
    }
    
    var headers: Alamofire.HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
    }
    
    var parameters: RequestParams {
        switch self {
        case .getCourseDetail, .removeCourse, .declareCourse:
            return .body(nil)
            
        case .searchCourse(let query):
            return .query(query)
        }
    }
    
    
}
