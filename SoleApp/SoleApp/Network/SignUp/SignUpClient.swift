//
//  SignUpClient.swift
//  SoleApp
//
//  Created by SUN on 2023/08/05.
//

import Foundation
import ComposableArchitecture
import Alamofire

struct SignUpClient {
    var checkAleadyMember: (CheckExistAccountRequest, String) async throws -> (SignUpModelResponse)
}

extension SignUpClient: DependencyKey {
    static var liveValue = SignUpClient { parameter, platform in
        
        let task = API.session.request(SignUpTarget.checkAleardyMember(parameter, platform))
            .validate()
            .serializingDecodable(SignUpModelResponse.self)
        return try await task.value
    }
}


