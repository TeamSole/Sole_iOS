//
//  APIClient.swift
//  SoleApp
//
//  Created by SUN on 2023/02/25.
//

import Foundation
import Alamofire

struct K {
    static let baseUrl: String = Bundle.main.object(forInfoDictionaryKey: "Base Url") as! String
    static let naverSearhUrl: String = "https://openapi.naver.com/v1/search/local.json"
    
}

extension K {
    struct Header {
        static let jsonHeader: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        static let multiplatformHeader: HTTPHeaders = [
            "Content-Type" : "multipart/form-data"
        ]
        
        static let naverSearhHeader: HTTPHeaders = [
            "X-Naver-Client-Id":  Bundle.main.object(forInfoDictionaryKey: "NaverClientId") as! String,
            "X-Naver-Client-Secret": Bundle.main.object(forInfoDictionaryKey: "NaverSecretId") as! String
        ]
    }
}

extension K {
    struct Path {
        static let validCheckForNickName: String = "api/members/nickname"
        static func signUp(platform: String) -> String {
            return "api/members/\(platform)/signup"
        }
        static let signUpApple: String = "api/members/apple/signup"
        static let signUpKakao: String = "api/members/kakao/signup"
        static let reissueToken: String = "api/members/reissue"
        static let checkExistAccount: String = "api/members/"
        
        // MARK: MyPage
        static let myAccountInfo: String = "api/mypage"
        static let withdrawal: String = "api/mypage/quit"
        static let logout: String = "api/members/logout"
        
        // MARK: Folllowing
        static let boardList: String = "api/follows"
        static let followList: String = "api/follows/followings"
        static let followerList: String = "api/follows/followers"
        static func follow(memberId: Int) -> String {
            return "api/follows/follow/\(memberId)"
        }
        
        // MARK: Scrap
        static let folderList: String = "api/scraps"
        
        // MARK: Histroy
        static let userProfileInHistory: String = "api/histories"
        static let userHistory: String = "api/histories/courses"
        
        // MARK: HOME
        static func couseScrap(courseId: Int) -> String {
            return "api/courses/\(courseId)/scrap"
        }
        static func courseDeclare(courseId: Int) -> String {
            return "api/courses/\(courseId)/declare"
        }
        static let courses: String = "api/courses"
        static let recommendCourse: String = "api/courses/recommend"
        static let category: String = "api/courses/favCategory"
        static let location: String = "api/courses/currentGps"
        
        static let courseDetail: String = "api/courses/"
        
    }
}


final class APIClient {
    static var apiReqeust: Bool = false
    static func reissueToken() {
        guard apiReqeust == false,
              Utility.load(key: Constant.token).isEmpty == false,
              Utility.load(key: Constant.refreshToken).isEmpty == false else { return }
        apiReqeust = true
        let url: Alamofire.URLConvertible = URL(string:  K.baseUrl + K.Path.reissueToken)!
        let headers: HTTPHeaders = [
            "Authorization": Utility.load(key: Constant.token),
            "Refresh": Utility.load(key: Constant.refreshToken)
        ]
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: ReissueResponse.self, completionHandler: { response in
                switch response.result {
                case .success(let response):
                    if let token = response.data?.accessToken,
                       let refreshToken = response.data?.refreshToken {
                        Utility.delete(key: Constant.token)
                        Utility.delete(key: Constant.refreshToken)
                        Utility.save(key: Constant.token, value: token)
                        Utility.save(key: Constant.refreshToken, value: refreshToken)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                apiReqeust = false
            })
    }
}



struct ReissueResponse: Codable {
    let data: DataModel?
    let status: Int
    let success: Bool
    
    struct DataModel: Codable {
        let accessToken: String?
        let refreshToken: String?
    }
}
