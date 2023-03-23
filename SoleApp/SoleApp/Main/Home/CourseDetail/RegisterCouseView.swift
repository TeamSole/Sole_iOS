//
//  RegisterCouseView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI
import Introspect

struct RegisterCouseView: View {
    typealias Course = RegisterCourseModelRequest.PlaceRequestDtos
    typealias FullCourse = RegisterCourseModelRequest
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: RegisterCourseViewModel = RegisterCourseViewModel()
    @State private var courseTitle: String = ""
    @State private var courseDescription: String = ""
    
    @State private var isShowThumbnailPhotoPicker: Bool = false
    @State private var isShowCoursePhotoPicker: Bool = false
    @State private var isShowSubPhotoPicker: Bool = false
    @State private var isShowHourMinutePicker: Bool = false
    @State private var isShowSelectTagView: Bool = false
    @State private var isShowLocationSearchView: Bool = false
    
    @State private var thumbnailImage: UIImage? = nil
    @State private var availableWidth: CGFloat = 10
    @State private var selectedDate: Date = Date()
    
    @State private var selectedPlace: [String] = []
    @State private var selectedWith: [String] = []
    @State private var selectedTrans: [String] = []
    
    @State private var courses: [Course] = [Course()]
//    @State private var selectedImages: [[UIImage]] = [[]]
    @State private var selectIndex: Int = 0
   
    private let gridItem: [GridItem] = [
        GridItem(.adaptive(minimum: 50.0), spacing: 8.0),
        GridItem(.adaptive(minimum: 50.0), spacing: 8.0),
        GridItem(.adaptive(minimum: 50.0), spacing: 8.0),
        GridItem(.adaptive(minimum: 50.0), spacing: 8.0)
    ]
    
    private let gridItemHeight: CGFloat = (UIScreen.main.bounds.width - 56) / 4
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
        .modifier(HourMinutePickerModifier(isShowFlag: $isShowHourMinutePicker,
                                           complete: { hour, minute in
            courses[selectIndex].duration = (hour * 60) + minute
        }))
        .sheet(isPresented: $isShowThumbnailPhotoPicker,
               content: {
            PhotoPicker(isPresented: $isShowThumbnailPhotoPicker, filter: .images, limit: 1) { result in
                PhotoPicker.convertToUIImageArray(fromResults: result) { (imagesOrNil, errorOrNil) in
                    if let images = imagesOrNil {
                        if let first = images.first {
                            viewModel.thumbnailImage = first
                        }
                    }
                }
            }
        })
        .sheet(isPresented: $isShowSubPhotoPicker,
               content: {
            PhotoPicker(isPresented: $isShowSubPhotoPicker, filter: .images, limit: 4) { result in
                PhotoPicker.convertToUIImageArray(fromResults: result) { (imagesOrNil, errorOrNil) in
                    if let images = imagesOrNil {
                        viewModel.selectedImages[selectIndex] = images
                    }
                }
            }
        })
        .sheet(isPresented: $isShowSelectTagView,
               content: {
            SelectTagView(selectType: .filter, complete: {place, with, trans in
                selectedPlace = place
                selectedWith = with
                selectedTrans = trans
            })
        })
        .sheet(isPresented: $isShowLocationSearchView,
               content: {
            LocationSearchView { course in
                courses[selectIndex] = course
            }
        })
    }
}

extension RegisterCouseView {
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
            ForEach(0..<courses.count, id: \.self) { index in
                VStack(spacing: 0.0) {
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
            TextField("코스 제목", text: $courseTitle)
            Color.gray_D3D4D5
                .frame(height: 1.0)
        }
        .frame(maxWidth: .infinity,
               alignment: .leading)
        .padding(.horizontal, 16.0)
    }
    
    private var thumbnailImageView: some View {
        VStack(spacing: 0.0) {
            if viewModel.thumbnailImage == nil {
                Text("대표 사진 추가")
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                Image("add_circle")
            } else {
                Image(uiImage: viewModel.thumbnailImage ?? UIImage())
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
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
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
            TagListView(availableWidth: availableWidth,
                        data: selectedPlace + selectedWith + selectedTrans,
                        spacing: 8.0,
                        alignment: .leading,
                        isExpandedUserTagListView: .constant(false),
                        maxRows: .constant(0)) { item in
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
            Text("코스 후기")
                .font(.pretendard(.reguler, size: 14.0))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            TextEditor(text: $courseDescription)
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
                Text(courses[index].placeName.isEmpty ? "장소명" : courses[index].placeName)
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
                Text("소요 시간")
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Text(String(format: "%d시간 %d분", courses[index].duration / 60, courses[index].duration % 60))
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
                    ForEach(0..<viewModel.selectedImages[index].count, id: \.self) { index2 in
                        Image(uiImage: viewModel.selectedImages[index][index2])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80.0,
                                   height: 80.0)
                            .cornerRadius(4.0)
                    }
                    addSubImageView(index: index)
                        .frame(width: 80.0,
                               height: 80.0)
                        .isHidden(viewModel.selectedImages[index].count == 4, remove: true)
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
            Text("\(viewModel.selectedImages[index].count)/4")
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
        .isHidden(courses.count > 3, remove: true)
        .onTapGesture {
            viewModel.selectedImages.append([])
            courses.append(Course())
        }
    }
    
    private var registerCourseButtonView: some View {
        VStack() {
            Text("코스 업로드")
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40.0)
        .background(isValid ? Color.blue_4708FA : Color.gray_EDEDED)
        .cornerRadius(8.0)
        .padding(16.0)
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
            let fullCourse = FullCourse(title: courseTitle,
                                        date: selectedDate.toString(format: "yyyy-MM-dd"),
                                        description: courseDescription,
                                        placeCategories: selectedPlace,
                                        transCategories: selectedTrans,
                                        withCategories: selectedWith,
                                        placeRequestDtos: courses)
            viewModel.uploadCourse(fullCourse: fullCourse) {
                guard isValid else { return }
                print("성공")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private var isValid: Bool {
        return courseTitle.isEmpty == false &&
        courseDescription.isEmpty == false &&
        viewModel.thumbnailImage != nil &&
        courses.first?.placeName.isEmpty == false
    }
    
}

struct RegisterCouseView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterCouseView()
    }
}
