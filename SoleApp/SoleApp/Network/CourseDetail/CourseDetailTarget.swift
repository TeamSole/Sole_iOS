//
//  CourseDetailTarget.swift
//  SoleApp
//
//  Created by SUN on 2023/09/13.
//

import Foundation
import Alamofire

enum CourseDetailTarget {
    case getCourseDetail(courseId: Int)
}

extension CourseDetailTarget: TargetType {
    var baseURL: String {
        return K.baseUrl
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getCourseDetail:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getCourseDetail(let courseId):
            return K.Path.courseDetail + "\(courseId)"
        }
    }
    
    var headers: Alamofire.HTTPHeaders {
        return [
            "Authorization": Utility.load(key: Constant.token)
        ]
    }
    
    var parameters: RequestParams {
        switch self {
        case .getCourseDetail:
            return .body(nil)
        }
    }
    
    
}
