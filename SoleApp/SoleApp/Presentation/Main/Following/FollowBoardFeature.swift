//
//  FollowBoardFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/09/17.
//

import ComposableArchitecture

struct FollowBoardFeature: Reducer {
    typealias CourseOfFollower = FollowBoardModelResponse.DataModel
    struct State: Equatable {
        var courses: [CourseOfFollower] = []
    }
    
    enum Action: Equatable {
        case getCoursesOfFollowers
        case getCoursesOfFollowersResponse(TaskResult<FollowBoardModelResponse>)
        case viewDidLoad
    }
    
    @Dependency(\.followClient) var followClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .getCoursesOfFollowers:
                return .run { send in
                    await send(.getCoursesOfFollowersResponse(
                        TaskResult { try await followClient.getCoursesOfFollowers()}))
                }
                
            case .getCoursesOfFollowersResponse(.success(let response)):
                if response.success == true,
                   let data = response.data {
                    state.courses = data
                }
                return .none
                
            case .getCoursesOfFollowersResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
            case .viewDidLoad:
                return .send(.getCoursesOfFollowers)
            }
        }
    }
}
