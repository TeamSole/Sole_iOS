//
//  TargetType.swift
//  SoleApp
//
//  Created by SUN on 2023/08/05.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var parameters: RequestParams { get }
}

extension TargetType {

    // URLRequestConvertible 구현
    func asURLRequest() throws -> URLRequest {
        guard let url =  URL(string: baseURL) else { throw AFError.invalidURL(url: baseURL) }
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        urlRequest.headers = headers

        switch parameters {
        case .query(let request):
            let params = request?.toDictionary() ?? [:]
            let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        case .body(let request):
            let parameters = request?.toDictionary() ?? [:]
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                debugPrint("Error: ParameterEncodingError - \(error.localizedDescription)")
                debugPrint("--------------------------------\n\(parameters)\n--------------------------------")
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }

        return urlRequest
    }
}

enum RequestParams {
    case query(_ parameter: Encodable?)
    case body(_ parameter: Encodable?)
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any] else { return [:] }
        return dictionaryData
    }
}
