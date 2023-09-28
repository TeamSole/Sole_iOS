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
        @PresentationState var courseDetail: CourseDetailFeature.State?
        var courses: [CourseOfFollower] = []
        @PresentationState var followingUserList: FollowingUserListFeature.State?
        var isCalledApi: Bool = false
    }
    
    enum Action: Equatable {
        /// 코스 상세 연결
        case courseDetail(PresentationAction<CourseDetailFeature.Action>)
        /// 코스 목록 클릭시 호출
        case didTappedCourseDetail(courseId: Int)
        case didTappedFollowingUserListView
        case followingUserList(PresentationAction<FollowingUserListFeature.Action>)
        case getCoursesOfFollowers
        case getCoursesOfFollowersResponse(TaskResult<FollowBoardModelResponse>)
        case scrap(couseId: Int)
        case scrapResponse(TaskResult<BaseResponse>)
        case viewDidLoad
    }
    
    @Dependency(\.followClient) var followClient
    @Dependency(\.scrapClient) var scrapClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .courseDetail:
                return .none
                
            case .didTappedCourseDetail(let courseId):
                state.courseDetail = CourseDetailFeature.State(courseId: courseId)
                return .none
                
            case .didTappedFollowingUserListView:
                state.followingUserList = FollowingUserListFeature.State()
                return .none
                
            case .followingUserList:
                return .none
                
            case .getCoursesOfFollowers:
                guard state.isCalledApi == false else { return .none }
                state.isCalledApi = true
                return .run { send in
                    await send(.getCoursesOfFollowersResponse(
                        TaskResult { try await followClient.getCoursesOfFollowers()}))
                }
                
            case .getCoursesOfFollowersResponse(.success(let response)):
                state.isCalledApi = false
                if response.success == true,
                   let data = response.data {
                    state.courses = data
                }
                return .none
                
            case .getCoursesOfFollowersResponse(.failure(let error)):
                state.isCalledApi = false
                debugPrint(error.localizedDescription)
                return .none
                
            case .scrap(let courseId):
                guard state.isCalledApi == false else { return .none }
                state.isCalledApi = true
                if let index = state.courses.firstIndex(where: { $0.courseId == courseId }) {
                    state.courses[index].like?.toggle()
                }
                return .run { send in
                    await send(.scrapResponse(
                        TaskResult { try await scrapClient.scrap(courseId)}))
                }
                
            case .scrapResponse(.success(let response)):
                state.isCalledApi = false
                if response.success == true {
                  
                }
                return .none
                
            case .scrapResponse(.failure(let error)):
                state.isCalledApi = false
                debugPrint(error.localizedDescription)
                return .none
                
            case .viewDidLoad:
                return .send(.getCoursesOfFollowers)
            }
        }
        .ifLet(\.$followingUserList, action: /Action.followingUserList) {
            FollowingUserListFeature()
        }
    }
}
