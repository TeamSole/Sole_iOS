//
//  CourseEditView.swift
//  Release
//
//  Created by SUN on 2023/03/23.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct CourseEditView: View {
    typealias Course = EditCourseModelRequest.PlaceUpdateRequestDtos
    typealias FullCourse = EditCourseModelRequest
    typealias CourseDetail = CourseDetailModelResponse.DataModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isShowThumbnailPhotoPicker: Bool = false
    @State private var isShowCoursePhotoPicker: Bool = false
    @State private var isShowSubPhotoPicker: Bool = false
    @State private var isShowHourMinutePicker: Bool = false
    @State private var isShowSelectTagView: Bool = false
    @State private var isShowLocationSearchView: Bool = false

    @State private var availableWidth: CGFloat = 10

    @State private var selectIndex: Int = 0

    
    private let store: StoreOf<CourseEditFeature>
    @ObservedObject var viewStore: ViewStoreOf<CourseEditFeature>
    
    init(store: StoreOf<CourseEditFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            ScrollView {
                LazyVStack(spacing: 0.0) {
                    courseThumbnailSectionView
                    thickSectionDivider
                    courseSubLocationSectionView
                }
                .onTapGesture {
                    hideKeyboard()
                }
            }
        }
        .navigationBarHidden(true)
        .introspectDatePicker(customize: { datePicker in
            datePicker.backgroundColor = .white
            datePicker.setValue(UIColor.clear, forKey: "tintColor")
            datePicker.tintColor = .blue_4708FA
        })
        .onLoaded {
            
        }
        .modifier(HourMinutePickerModifier(isShowFlag: $isShowHourMinutePicker,
                                           complete: { hour, minute in
            let duration = (hour * 60) + minute
            viewStore.send(.setDurationOfCourse(courseIndex: selectIndex, duration: duration))
        }))
        .sheet(isPresented: $isShowThumbnailPhotoPicker,
               content: {
            PhotoPicker(isPresented: $isShowThumbnailPhotoPicker, filter: .images, limit: 1) { result in
                PhotoPicker.convertToUIImageArray(fromResults: result) { (imagesOrNil, errorOrNil) in
                    if let images = imagesOrNil {
                        if let first = images.first {
                            viewStore.send(.selectThumbnailImage(first))
                        }
                    }
                }
            }
        })
        .sheet(isPresented: $isShowSubPhotoPicker,
               content: {
            PhotoPicker(isPresented: $isShowSubPhotoPicker, filter: .images, limit: 4 - (viewStore.courses[selectIndex].placeImgUrls.count) - viewStore.selectedCourseImages[selectIndex].count) { result in
                PhotoPicker.convertToUIImageArray(fromResults: result) { (imagesOrNil, errorOrNil) in
                    if let images = imagesOrNil {
                        viewStore.send(.selectCourseImages(images: images, courseIndex: selectIndex))
                    }
                }
            }
        })
        .sheet(isPresented: $isShowSelectTagView,
               content: {
            SelectTagView(isHiddenLocationSection: true,
                          selectedPlace: viewStore.selectedPlaceParameter,
                          selectedWith: viewStore.selectedWithParameter,
                          selectedTrans: viewStore.selectedVehiclesParameter,
                          selectType: .filter,
                          complete: {place, with, trans, _ in
                viewStore.send(.setplaceTagParameter(places: place, with: with, vehicles: trans))
            })
        })
        .sheet(isPresented: $isShowLocationSearchView,
               content: {
            LocationSearchView { course in
                let courseObject = Course(address: course.address,
                                          description: course.description,
                                          placeId: selectIndex >= viewStore.courses.count ? nil : viewStore.courses[selectIndex].placeId ?? 0,
                                          placeName: course.placeName,
                                          latitude: course.latitude,
                                          longitude: course.longitude,
                                          placeImgUrls: selectIndex >= viewStore.courses.count ? [] : viewStore.courses[selectIndex].placeImgUrls
                )
                viewStore.send(.insertSearchedPlace(courseIndex: selectIndex, course: courseObject))
            }
        })
    }
}

extension CourseEditView {
    private var navigationBar: some View {
        ZStack {
            Image("arrow_back")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("코스 기록")
                .foregroundColor(.black)
                .font(.pretendard(.medium, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .center)
        }
        .frame(height: 48.0)
        .padding(.horizontal, 16.0)
    }
    
    private var courseThumbnailSectionView: some View {
        VStack(spacing: 0.0) {
            courseTextFeildView
            thumbnailImageView
            dateView
            tagView
            descriptionTextView
        }
    }
    
    private var courseSubLocationSectionView: some View {
        VStack(spacing: 0.0) {
            Text("장소 입력")
                .foregroundColor(.black)
                .font(.pretendard(.bold, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(16.0)
            ForEach(0..<viewStore.courses.count, id: \.self) { index in
                VStack(spacing: 0.0) {
                    Image("close")
                        .frame(maxWidth: .infinity,
                               alignment: .trailing)
                        .padding(16.0)
                        .isHidden(viewStore.courses.count < 3, remove: true)
                        .onTapGesture {
                            viewStore.send(.removeCourse(index: index))
                        }
                    locationTextFieldView(index: index)
                    takenTimeView(index: index)
                    subImageGridView(index: index)
                   
                }
            }
            addLocationButtonView
            registerCourseButtonView
        }
    }
    
    private var courseTextFeildView: some View {
        VStack(spacing: 4.0) {
            TextField(StringConstant.courseTitle, text: viewStore.binding(get: \.courseTitle, send: { .setCourseTitle($0) }))
            Color.gray_D3D4D5
                .frame(height: 1.0)
        }
        .frame(maxWidth: .infinity,
               alignment: .leading)
        .padding(.horizontal, 16.0)
    }
    
    private var thumbnailImageView: some View {
        VStack(spacing: 0.0) {
            if viewStore.thumbnailImage == nil {
                KFImage(URL(string: viewStore.courseDetail.thumbnailUrl ?? ""))
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: 186.0)
                    .cornerRadius(12.0)
            } else {
                Image(uiImage: viewStore.thumbnailImage ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 186.0)
                    .cornerRadius(12.0)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 186.0)
        .overlay(
            RoundedRectangle(cornerRadius: 12.0)
                .stroke(Color.gray_D3D4D5, lineWidth: 1.0)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
            isShowThumbnailPhotoPicker = true
        }
        .padding(16.0)
        .padding(.bottom, 20.0)
    }
    
    private var dateView: some View {
        VStack(spacing: 16.0) {
            HStack(spacing: 0.0) {
                Text("방문 날짜")
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                DatePicker("", selection: viewStore.binding(get: \.dateOfVisit, send: { .setDateOfVisit(date: $0) }), displayedComponents: .date)
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .background(Color.white)
                    
                    .environment(\.locale, Locale.init(identifier: "ko_KR"))
                    .frame(height: 14.0)
                Image("arrow_right")
            }
            Color.gray_D3D4D5
                .frame(height: 1.0)
        }
        .frame(maxWidth: .infinity,
               alignment: .leading)
        .padding(16.0)
        
    }
    
    private var tagView: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            HStack(spacing: 0.0) {
                Text("태그")
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("arrow_right")
            }
            .padding(.bottom, 12.0)
            .contentShape(Rectangle())
            .onTapGesture {
                isShowSelectTagView = true
            }
            Color.clear
                .frame(height: 1.0)
                .readSize { size in
                    availableWidth = size.width
                }
            TagListView(data: viewStore.selectedPlaceParameter +
                        viewStore.selectedWithParameter +
                        viewStore.selectedVehiclesParameter,
                        spacing: 8.0,
                        alignment: .leading,
                        availableWidth: availableWidth) { item in
                HStack(spacing: 0.0) {
                    Text(Category(rawValue: item)?.title ?? "카페")
                        .foregroundColor(.black)
                        .font(.pretendard(.reguler, size: 11.0))
                        .frame(height: 18.0)
                        .padding(.horizontal, 8.0)
                        .background(Color.gray_EDEDED)
                        .cornerRadius(4.0)
                }
            }
            
            Color.gray_D3D4D5
                .frame(height: 1.0)
                .padding(.top, 12.0)
        }
        .frame(maxWidth: .infinity,
               alignment: .leading)
        .padding(.horizontal, 16.0)
    }
    
    private var descriptionTextView: some View {
        VStack(spacing: 6.0) {
            Text(StringConstant.reviewOfCourse)
                .font(.pretendard(.reguler, size: 14.0))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            TextEditor(text: viewStore.binding(get: \.courseDescription, send: { .setCourseDescription($0) }))
                .frame(height: 86.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 4.0)
                        .stroke(Color.gray_D3D4D5, lineWidth: 1.0))
            
        }
        .frame(maxWidth: .infinity)
        
        .padding(16.0)
    }
    
    private var thickSectionDivider: some View {
        Color.gray_EDEDED
            .frame(height: 3.0)
            .frame(maxWidth: .infinity)
    }
    
    private func locationTextFieldView(index: Int) -> some View {
        VStack(spacing: 20.0) {
            HStack(spacing: 6.0) {
                Image(systemName: "magnifyingglass")
                Text(viewStore.courses[index].placeName.isEmpty ? "장소명" : viewStore.courses[index].placeName)
                    .font(.pretendard(.reguler, size: 14.0))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity,
                   alignment: .leading)
            .frame(height: 36.0)
            .padding(.horizontal, 7.0)
            .background(Color.gray_EDEDED)
            .cornerRadius(10.0)
        }
        .padding(.horizontal, 16.0)
        .padding(.bottom, 16.0)
        .contentShape(Rectangle())
        .onTapGesture {
            selectIndex = index
            isShowLocationSearchView = true
        }
    }
    
    private func takenTimeView(index: Int) -> some View {
        VStack(spacing: 16.0) {
            HStack(spacing: 0.0) {
                Text(StringConstant.timeTaken)
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Text(String(format: "%d시간 %d분", viewStore.courses[index].duration / 60, viewStore.courses[index].duration % 60))
                    .foregroundColor(.blue_4708FA)
                    .font(.pretendard(.reguler, size: 14.0))
                Image("arrow_right")
            }
            Color.gray_D3D4D5
                .frame(height: 1.0)
        }
        .frame(maxWidth: .infinity,
               alignment: .leading)
        .padding(.horizontal, 16.0)
        .contentShape(Rectangle())
        .onTapGesture {
            selectIndex = index
            isShowHourMinutePicker = true
        }
    }
    
    private func subImageGridView(index: Int) -> some View {
        HStack(spacing: 0.0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8.0) {
                    ForEach(0..<(viewStore.courses[index].placeImgUrls.count), id: \.self) { index2 in
                        ZStack(alignment: .topTrailing) {
                            KFImage(URL(string: viewStore.courses[index].placeImgUrls[index2]))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80.0,
                                       height: 80.0)
                                .cornerRadius(4.0)
                            Image("closeBlack")
                                .padding(4.0)
                                .onTapGesture {
                                    viewStore.send(.removeUploadedImageInCourse(courseIndex: index, imageIndex: index2))
                                }
                        }
                        
                    }
                    
                    ForEach(0..<viewStore.selectedCourseImages[index].count, id: \.self) { imageIndex in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: viewStore.selectedCourseImages[index][imageIndex])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80.0,
                                       height: 80.0)
                                .cornerRadius(4.0)
                            Image("closeBlack")
                                .padding(4.0)
                                .onTapGesture {
                                    viewStore.send(.removeImageInCourse(courseIndex: index, imageIndex: imageIndex))
                                }
                        }
                    }
                    addSubImageView(index: index)
                        .frame(width: 80.0,
                               height: 80.0)
                        .isHidden(viewStore.selectedCourseImages[index].count + (viewStore.courses[index].placeImgUrls.count ) > 3, remove: true)
                }
                
            }
        }
        .padding(16.0)
        .padding(.bottom, 16.0)
    }
    
    private func addSubImageView(index: Int) -> some View {
        VStack(spacing: 4.0) {
            Text("사진 추가")
                .foregroundColor(.black)
                .font(.pretendard(.reguler, size: 14.0))
            Image("add_circle")
            Text("\(viewStore.selectedCourseImages[index].count)/4")
                .foregroundColor(.black)
                .font(.pretendard(.reguler, size: 12.0))
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 4.0)
                .stroke(Color.gray_D3D4D5, lineWidth: 1.0)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            selectIndex = index
            isShowSubPhotoPicker = true
        }
    }
    
    private var addLocationButtonView: some View {
        VStack() {
            Text("장소 추가하기 +")
                .font(.pretendard(.reguler, size: 14.0))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40.0)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(Color.gray_D3D4D5, lineWidth: 1.0)
        )
        .padding(16.0)
        .contentShape(Rectangle())
        .isHidden(viewStore.courses.count > 4, remove: true)
        .onTapGesture {
            viewStore.send(.addCourse)
        }
    }
    
    private var registerCourseButtonView: some View {
        VStack() {
            Text("코스 수정하기")
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40.0)
        .background(viewStore.isValid ? Color.blue_4708FA : Color.gray_EDEDED)
        .cornerRadius(8.0)
        .padding(16.0)
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
            viewStore.send(.editCourse)
        }
    }
}

struct CourseEditView_Previews: PreviewProvider {
    static var previews: some View {
        CourseEditView(store: Store(initialState: CourseEditFeature.State(courseDetail: .init()), reducer: { CourseEditFeature() }))
    }
}
