//
//  CourseEditFeature.swift
//  SoleApp
//
//  Created by SUN on 10/5/23.
//

import Foundation
import ComposableArchitecture
import UIKit

struct CourseEditFeature: Reducer {
    typealias CourseDetail = CourseDetailModelResponse.DataModel
    typealias Course = EditCourseModelRequest.PlaceUpdateRequestDtos
    typealias FullCourse = EditCourseModelRequest
    struct State: Equatable {
        var courseId: Int
        var courseDetail: CourseDetail
        var fullCourse: FullCourse = .init()
        var courses: [Course] = []
        var courseTitle: String = ""
        var courseDescription: String = ""
        var dateOfVisit: Date = Date()
        var selectedCourseImages: [[UIImage]] = []
        var selectedPlaceParameter: [String] = []
        var selectedWithParameter: [String] = []
        var selectedVehiclesParameter: [String] = []
        var thumbnailImage: UIImage? = nil
        var isCalledApi: Bool = false
        
        var isValid: Bool {
            return courseTitle.isEmpty == false &&
            courseDescription.isEmpty == false &&
            courses.first?.placeName.isEmpty == false
        }
        
        init(courseDetail: CourseDetail) {
            self.courseDetail = courseDetail
            courseTitle = courseDetail.title ?? ""
            courseDescription = courseDetail.description ?? ""
            fullCourse.startDate = courseDetail.startDate ?? ""
            fullCourse.placeCategories = courseDetail.categories?.filter({ Category.placeCategory.contains(Category(rawValue: $0) ?? .CAFE ) }) ?? []
            fullCourse.transCategories = courseDetail.categories?.filter({ Category.transCategory.contains(Category(rawValue: $0) ?? .WALK) }) ?? []
            fullCourse.withCategories = courseDetail.categories?.filter({ Category.withCategory.contains(Category(rawValue: $0) ?? .ALONE) }) ?? []
            courseId = courseDetail.courseId ?? 0
            dateOfVisit = Date(courseDetail.startDate ?? "", format: "yyyy-MM-dd") ?? Date()
            for index in 0..<(courseDetail.placeResponseDtos?.count ?? 0) {
                selectedCourseImages.append([])
                let course = Course(address: courseDetail.placeResponseDtos?[index].address ?? "",
                                    description: courseDetail.placeResponseDtos?[index].description ?? "",
                                    duration: courseDetail.placeResponseDtos?[index].duration ?? 0,
                                    placeId: courseDetail.placeResponseDtos?[index].placeId ?? 0,
                                    placeName: courseDetail.placeResponseDtos?[index].placeName ?? "",
                                    latitude: courseDetail.placeResponseDtos?[index].latitude ?? 0.0,
                                    longitude: courseDetail.placeResponseDtos?[index].longitude ?? 0.0,
                                    placeImgUrls: courseDetail.placeResponseDtos?[index].placeImgUrls ?? [])
                courses.append(course)
            }
        }
    }
    
    enum Action: Equatable {
        /// 작성할 코스 항목 추가
        case addCourse
        case didTappedDismissButton
        /// 코스 수정
        case editCourse
        case editCourseResponse(TaskResult<BaseResponse>)
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
        /// 편집중 코스에 추가한 이미지 삭제
        case removeImageInCourse(courseIndex: Int, imageIndex: Int)
        /// 업로드된 이미지 삭제
        case removeUploadedImageInCourse(courseIndex: Int, imageIndex: Int)
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
                
            case .editCourse:
                guard state.isValid == true,
                      state.isCalledApi == false else { return .none }
                state.isCalledApi = true

                state.fullCourse.title = state.courseTitle
                state.fullCourse.description = state.courseDescription
                state.fullCourse.startDate = state.dateOfVisit.toString(format: "yyyy-MM-dd")
                state.fullCourse.placeCategories = state.selectedPlaceParameter
                state.fullCourse.transCategories = state.selectedVehiclesParameter
                state.fullCourse.withCategories = state.selectedWithParameter
                state.fullCourse.placeUpdateRequestDtos = state.courses

                return .run { [thumbnailImage = state.thumbnailImage,
                               coursesImages = state.selectedCourseImages,
                               fullCourse = state.fullCourse,
                               courseId = state.courseId
                ] send in
                    await send(.editCourseResponse(
                        TaskResult {
                            try await courseClient.editCourse(courseId, fullCourse, thumbnailImage, coursesImages
                            )
                        })
                    )
                }
                
            case .editCourseResponse(.success(let response)):
                state.isCalledApi = false
                if response.success == true {
                    return .send(.didTappedDismissButton)
                }
                return .none
                
            case .editCourseResponse(.failure(let error)):
                state.isCalledApi = false
                debugPrint(error.localizedDescription)
                return .none
                
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
                
            case .removeImageInCourse(let courseIndex, let imageIndex):
                state.selectedCourseImages[courseIndex].remove(at: imageIndex)
                return .none
                
            case .removeUploadedImageInCourse(let courseIndex, let imageIndex):
                state.courses[courseIndex].placeImgUrls.remove(at: imageIndex)
                return .none
                
           
            }
        }
    }
}
