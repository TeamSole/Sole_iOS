//
//  API.swift
//  SoleApp
//
//  Created by SUN on 2023/08/05.
//

import Foundation
import Alamofire

class API {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 5.0
        let apiLogger = APIEventLogger()
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
    
    static func makeDataRequest(_ convertible: URLRequestConvertible, isNeedInterceptor: Bool = true) -> DataRequest {
        if isNeedInterceptor == true {
            let authenticator = CommonAuthenticator()
            let credential = CommonAuthenticationCredential(accessToken: Utility.load(key: Constant.token),
                                                            refreshToken: Utility.load(key: Constant.refreshToken),
                                                            expiredAt: Date(timeIntervalSinceNow: 60 * 1440))
            
            let authenticationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                      credential: credential)
            let request = session.request(convertible, interceptor: authenticationInterceptor)
            debugPrint(request.cURLDescription())
            return request
        } else {
            let request = session.request(convertible, interceptor: nil)
            debugPrint(request.cURLDescription())
            return request
        }
       
    }
    
    static func responseDecodeToJson<Response: Codable>(data: Data, response: Response.Type) throws -> Response {
        do {
            let startTime      = Date(timeIntervalSinceNow: 0.0)
            let responseObject = try JSONDecoder().decode(response.self, from: data)
            let codableDelay   = -(startTime.timeIntervalSinceNow * 1_000_000)
            debugPrint(String(format: ">> [Codable jsonParsingDelay in: %.3fµs]", codableDelay))
            return responseObject
        } catch (let error) {
            if let jsonString = String(data: data, encoding: .utf8) {
                debugPrint("--------------------------------\n\(jsonString)\n--------------------------------")
            }
            debugPrint(String(format: "Decoding Error: %@", error.localizedDescription))
            throw AFError.responseSerializationFailed(reason: .decodingFailed(error: error))
        }
    }
}


enum NetworkResult<T: Codable> {
    case success(T)
    case fail(NetworkError)
}

enum NetworkError: Int, Error {
  case badRequest = 400
  case authenticationFailed = 401
  case notFoundException = 404
  case contentLengthError = 413
  case quotaExceeded = 429
  case systemError = 500
  case endpointError = 503
  case timeout = 504
}

