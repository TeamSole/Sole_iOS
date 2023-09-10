//
//  HomeTarget.swift
//  SoleApp
//
//  Created by SUN on 2023/09/04.
//

import Foundation
import Alamofire

enum HomeTarget {
    case getCourses
    case getNextCourses(CourseModelRequest)
    case getRecommendedCourses
}

extension HomeTarget: TargetType {
    var baseURL: String {
        return K.baseUrl
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .getCourses, .getNextCourses:
            return K.Path.courses
        case .getRecommendedCourses:
            return K.Path.recommendCourse
        }
    }
    
    var headers: Alamofire.HTTPHeaders {
        return [
            "Authorization": Utility.load(key: Constant.token)
        ]
    }
    
    var parameters: RequestParams {
        switch self {
        case .getCourses:
            return .body(nil)
            
        case .getNextCourses(let parameter):
            return .query(parameter)
            
        case .getRecommendedCourses:
            return .body(nil)
        }
    }
    
    
}
