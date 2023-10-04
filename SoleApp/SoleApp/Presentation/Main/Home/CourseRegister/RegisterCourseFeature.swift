//
//  RegisterCourseFeature.swift
//  SoleApp
//
//  Created by SUN on 9/29/23.
//

import ComposableArchitecture
import UIKit

struct RegisterCourseFeature: Reducer {
    typealias Course = RegisterCourseModelRequest.PlaceRequestDtos
    typealias FullCourse = RegisterCourseModelRequest
    struct State: Equatable {
        var courses: [Course] = [Course(), Course()]
        var courseTitle: String = ""
        var courseDescription: String = ""
        var dateOfVisit: Date = Date()
        var selectedCourseImages: [[UIImage]] = [[], []]
        var selectedPlaceParameter: [String] = []
        var selectedWithParameter: [String] = []
        var selectedVehiclesParameter: [String] = []
        var thumbnailImage: UIImage? = nil
        var isCalledApi: Bool = false
        var isValid: Bool {
            return courseTitle.isEmpty == false &&
            courseDescription.isEmpty == false &&
            thumbnailImage != nil &&
            courses.first?.placeName.isEmpty == false
        }
    }
    
    enum Action: Equatable {
        /// 작성할 코스 항목 추가
        case addCourse
        case didTappedDismissButton
        /// 코스 검색 기록 추가
        case insertSearchedPlace(courseIndex: Int, course: Course)
        /// 코스 썸네일 이미지 추가
        case selectThumbnailImage(UIImage)
        /// 코스별 이미지 선택
        case selectCourseImages(images: [UIImage], courseIndex: Int)
        /// 코스 설명
        case setCourseDescription(String)
        /// 코스 제목 입력
        case setCourseTitle(String)
        /// 코스 소요시간 입력
        case setDurationOfCourse(courseIndex: Int, duration: Int)
        /// 코스 관련 테그 추가
        case setplaceTagParameter(places: [String], with: [String], vehicles: [String])
        /// 코스 방문 날짜 추가
        case setDateOfVisit(date: Date)
        /// 추가한 코스 삭제
        case removeCourse(index: Int)
        /// 코스 업로드
        case uploadCourse
        case uploadCourseResponse(TaskResult<BaseResponse>)
    }
    
    @Dependency(\.courseClient) var courseClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .addCourse:
                state.selectedCourseImages.append([])
                state.courses.append(.init())
                return .none
                
            case .didTappedDismissButton:
                return .run { _ in await dismiss() }
                
            case .insertSearchedPlace(let courseIndex, let course):
                state.courses[courseIndex] = course
                return .none
                
            case .selectCourseImages(let images, let courseIndex):
                state.selectedCourseImages[courseIndex] = images
                return .none
                
            case .selectThumbnailImage(let image):
                state.thumbnailImage = image
                return .none
                
            case .setCourseDescription(let description):
                state.courseDescription = description
                return .none
                
            case .setCourseTitle(let title):
                state.courseTitle = title
                return .none
                
            case .setDurationOfCourse(let courseIndex, let duration):
                state.courses[courseIndex].duration = duration
                return .none
                
            case .setplaceTagParameter(let places, let with, let vehicles):
                state.selectedPlaceParameter = places
                state.selectedWithParameter = with
                state.selectedVehiclesParameter = vehicles
                return .none
                
            case .setDateOfVisit(let date):
                state.dateOfVisit = date
                return .none
                
            case .removeCourse(let index):
                // 코스 먼저 삭제해야함
                state.courses.remove(at: index)
                state.selectedCourseImages.remove(at: index)
                return .none
                
            case .uploadCourse:
                guard state.isValid == true,
                      state.isCalledApi == false else { return .none }
                state.isCalledApi = true
                let fullCourse = FullCourse(title: state.courseTitle,
                                            date: state.dateOfVisit.toString(format: "yyyy-MM-dd"),
                                            description: state.courseDescription,
                                            placeCategories: state.selectedPlaceParameter,
                                            transCategories: state.selectedVehiclesParameter,
                                            withCategories: state.selectedWithParameter,
                                            placeRequestDtos: state.courses)
                return .run { [thumbnailImage = state.thumbnailImage,
                               coursesImages = state.selectedCourseImages] send in
                    await send(.uploadCourseResponse(
                        TaskResult {
                            try await courseClient.uploadCourse(fullCourse, thumbnailImage, coursesImages
                            )
                        })
                    )
                }
                
            case .uploadCourseResponse(.success(let response)):
                state.isCalledApi = false
                return .send(.didTappedDismissButton)
                
            case .uploadCourseResponse(.failure(let error)):
                state.isCalledApi = false
                debugPrint(error.localizedDescription)
                return .none
            }
        }
    }
}


