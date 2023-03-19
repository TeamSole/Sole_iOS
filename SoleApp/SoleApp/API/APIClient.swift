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
}

extension K {
    struct Header {
        static let jsonHeader: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        static let multiplatformHeader: HTTPHeaders = [
            "Content-Type" : "multipart/form-data"
        ]
        
        static let reissueHeader: HTTPHeaders = [
            "Authorization": Utility.load(key: Constant.token),
            "Refresh": Utility.load(key: Constant.refreshToken)
        ]
        
        static let jsonHeaderWithToken: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
    }
}

extension K {
    struct Path {
        static let validCheckForNickName: String = "api/members/nickname"
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
        
        // MARK: HOME
        static func couseScrap(courseId: Int) -> String {
            return "api/courses/\(courseId)/scrap"
        }
        
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
