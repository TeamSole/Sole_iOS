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
    var checkAleadyMember: @Sendable (CheckExistAccountRequest, String) async throws -> (SignUpModelResponse)
}

extension SignUpClient: DependencyKey {
    static var liveValue = SignUpClient { parameter, platform in
        let request = API.makeDataRequest(SignUpTarget.checkAleardyMember(parameter, platform))
        let data = try await request.validate().serializingData().value
            
        return try await API.responseDecodeToJson(data: data, response: SignUpModelResponse.self)
    }
}


