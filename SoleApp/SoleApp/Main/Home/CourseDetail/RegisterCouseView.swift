//
//  RegisterCouseView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI

struct RegisterCouseView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var courseTitle: String = ""
    @State private var courseDescription: String = ""
    @State private var isShowThumbnailPhotoPicker: Bool = false
    @State private var isShowSubPhotoPicker: Bool = false
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
            }
        }
        .sheet(isPresented: $isShowThumbnailPhotoPicker,
               content: {
            PhotoPicker(isPresented: $isShowThumbnailPhotoPicker, filter: .images, limit: 1) { result in
                PhotoPicker.convertToUIImageArray(fromResults: result) { (imagesOrNil, errorOrNil) in
                    if let images = imagesOrNil {
                        if let first = images.first {
//                            viewModel.selectedImage = first
                        }
                    }
                }
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
            locationTextFieldView
            takenTimeView
            subImageGridView
            addLocationButtonView
            registerCourseButtonView
        }
    }
    
    private var courseTextFeildView: some View {
        VStack(spacing: 0.0) {
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
            Text("대표 사진 추가")
                .foregroundColor(.black)
                .font(.pretendard(.reguler, size: 14.0))
            Image("add_circle")
        }
        .frame(maxWidth: .infinity)
        .frame(height: 186.0)
        .overlay(
            RoundedRectangle(cornerRadius: 12.0)
                .stroke(Color.gray_D3D4D5, lineWidth: 1.0)
        )
        .padding(16.0)
    }
    
    private var dateView: some View {
        VStack(spacing: 16.0) {
            HStack(spacing: 0.0) {
                Text("방문 날짜")
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("arrow_right")
            }
            Color.gray_D3D4D5
                .frame(height: 1.0)
        }
        .frame(maxWidth: .infinity,
               alignment: .leading)
        .padding(.horizontal, 16.0)
    }
    
    private var tagView: some View {
        VStack(spacing: 16.0) {
            HStack(spacing: 0.0) {
                Text("태그")
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("arrow_right")
            }
            Color.gray_D3D4D5
                .frame(height: 1.0)
        }
        .frame(maxWidth: .infinity,
               alignment: .leading)
        .padding(.horizontal, 16.0)
    }
    
    private var descriptionTextView: some View {
        VStack(spacing: 0.0) {
            TextEditor(text: $courseDescription)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 86.0)
        .overlay(
            RoundedRectangle(cornerRadius: 4.0)
                .stroke(Color.gray_D3D4D5, lineWidth: 1.0)
        )
        .padding(16.0)
    }
    
    private var thickSectionDivider: some View {
        Color.gray_EDEDED
            .frame(height: 3.0)
            .frame(maxWidth: .infinity)
    }
    
    private var locationTextFieldView: some View {
        VStack(spacing: 20.0) {
            Text("장소 입력")
                .foregroundColor(.black)
                .font(.pretendard(.bold, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            HStack(spacing: 6.0) {
                Image(systemName: "magnifyingglass")
                Text("장소명")
                    .font(.pretendard(.reguler, size: 14.0))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity,
                   alignment: .leading)
            .padding(7.0)
            .background(Color.gray_EDEDED)
            .cornerRadius(10.0)
        }
        .padding(.horizontal, 16.0)
    }
    
    private var takenTimeView: some View {
        VStack(spacing: 16.0) {
            HStack(spacing: 0.0) {
                Text("소요 시간")
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("arrow_right")
            }
            Color.gray_D3D4D5
                .frame(height: 1.0)
        }
        .frame(maxWidth: .infinity,
               alignment: .leading)
        .padding(.horizontal, 16.0)
    }
    
    private var subImageGridView: some View {
        LazyVGrid(columns: gridItem) {
            ForEach(0..<3) { index in
                Color.gray
                    .frame(height: gridItemHeight)
                    .cornerRadius(4.0)
            }
            addSubImageView
                .frame(height: gridItemHeight)
        }
        .padding(16.0)
    }
    
    private var addSubImageView: some View {
        VStack(spacing: 4.0) {
            Text("사진 추가")
                .foregroundColor(.black)
                .font(.pretendard(.reguler, size: 14.0))
            Image("add_circle")
            Text("3/4")
                .foregroundColor(.black)
                .font(.pretendard(.reguler, size: 12.0))
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 4.0)
                .stroke(Color.gray_D3D4D5, lineWidth: 1.0)
        )
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
        .padding(.horizontal, 16.0)
    }
    
    private var registerCourseButtonView: some View {
        VStack() {
            Text("코스 업로드")
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40.0)
        .background(Color.blue_4708FA)
        .cornerRadius(8.0)
        .padding(.horizontal, 16.0)
    }
    
}

struct RegisterCouseView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterCouseView()
    }
}
