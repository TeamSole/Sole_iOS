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
        let apiLogger = APIEventLogger()
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
}
