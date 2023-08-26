//
//  CommonAuthenticator.swift
//  SoleApp
//
//  Created by SUN on 2023/08/26.
//

import Foundation
import Alamofire

final class CommonAuthenticator: Authenticator {
    
    typealias Credential = CommonAuthenticationCredential
    
    func apply(_ credential: CommonAuthenticationCredential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(credential.accessToken))
        urlRequest.addValue(credential.refreshToken, forHTTPHeaderField: "Refresh")
    }
    
    func refresh(_ credential: CommonAuthenticationCredential, for session: Alamofire.Session, completion: @escaping (Result<CommonAuthenticationCredential, Error>) -> Void) {
        let url: String = K.baseUrl + K.Path.reissueToken
        API.session.request(url)
            .validate()
            .responseDecodable(of: RefreshModel.self) { result in
                switch result.result {
                case .success(let response):
                    if let token = response.data?.accessToken,
                       let refreshToken = response.data?.refreshToken {
                        Utility.save(key: Constant.token, value: token)
                        Utility.save(key: Constant.refreshToken, value: refreshToken)
                        completion(.success(Credential(accessToken: token,
                                                       refreshToken: refreshToken,
                                                       expiredAt: Date(timeIntervalSinceNow: 60 * 1440))))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: CommonAuthenticationCredential) -> Bool {
        let token = HTTPHeader.authorization(credential.accessToken).value
        return urlRequest.headers["Authorization"] == token
    }
    
    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == 401
    }
    
}
