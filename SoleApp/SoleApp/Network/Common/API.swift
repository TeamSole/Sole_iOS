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
    
    static func makeDataRequest(_ convertible: URLRequestConvertible, interceptor: RequestInterceptor? = nil) -> DataRequest {
        let request = session.request(convertible, interceptor: interceptor)
        debugPrint(request.cURLDescription())
        return request
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

