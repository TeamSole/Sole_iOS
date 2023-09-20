//
//  FollowTarget.swift
//  SoleApp
//
//  Created by SUN on 2023/09/17.
//

import Alamofire

enum FollowTarget {
    /// 팔로우
    case follow(memberId: Int)
    /// 팔로우한 사람의 코스 상세 불러오기 할 때 사용
    case getCoursesOfFollowers
    /// 팔로워 목록 가저오기
    case getFollowers
    /// 팔로우 목록 가져오기
    case getFollows
    /// 팔로우 한 유저 정보
    case getUserDetail(socialId: String)
}

extension FollowTarget: TargetType {
    var baseURL: String {
        return K.baseUrl
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .follow:
            return .post
            
        case .getCoursesOfFollowers, .getFollowers, .getFollows, .getUserDetail:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .follow(let memberId):
            return K.Path.follow(memberId: memberId)
            
        case .getCoursesOfFollowers:
            return K.Path.boardList
            
        case .getFollowers:
            return K.Path.followerList
            
        case .getFollows:
            return K.Path.followList
            
        case .getUserDetail(let socialId):
            return K.Path.boardList + "/\(socialId)"
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
        case .follow, .getCoursesOfFollowers, .getFollowers, .getFollows, .getUserDetail:
            return .body(nil)
        }
    }
    
    
}
