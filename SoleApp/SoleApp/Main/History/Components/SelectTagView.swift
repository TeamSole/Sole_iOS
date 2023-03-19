//
//  SelectTagView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI

struct SelectTagView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            ScrollView {
                VStack(spacing: 0.0) {
                    
                }
            }
            confirmButtonView
        }
        
    }
}

extension SelectTagView {
    private var navigationBar: some View {
        VStack(spacing: 0.0) {
            HStack {
                Text("취향")
                    .foregroundColor(.black)
                    .font(.pretendard(.medium, size: 16.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("closeBk")
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
            .frame(height: 60.0)
            .padding(.horizontal, 16.0)
            Color.gray_EDEDED
                .frame(height: 1.0)
                .frame(maxWidth: .infinity)
        }
    }
    
    private var confirmButtonView: some View {
        Text("적용하기")
            .foregroundColor(.white)
            .font(.pretendard(.bold, size: 16.0))
            .frame(maxWidth: .infinity)
            .frame(height: 48.0)
            .background(Color.blue_4708FA.cornerRadius(8.0))
            .padding(16.0)
            .contentShape(Rectangle())
        
    }
}

enum PlaceCategory: String {
    case TASTY_PLACE = "TASTY_PLACE"
    case CAFE = "CAFE"
    case CULTURE_ART = "CULTURE_ART"
    case ACTIVITY = "ACTIVITY"
    case HEALING = "HEALING"
    case NATURE = "NATURE"
    case NIGHT_VIEW = "NIGHT_VIEW"
    case HISTORY = "HISTORY"
    case THEME_PARK = "THEME_PARK"
}

enum TransCategory: String {
    case WALK = "WALK"
    case BIKE = "BIKE"
    case CAR = "CAR"
    case PUBLIC_TRANSPORTATION = "PUBLIC_TRANSPORTATION "
}

//PlaceCategory
// TASTY_PLACE : 맛집
// CAFE : 카페
// CULTURE_ART : 문화 예술
// ACTIVITY : 액티비티
// HEALING : 힐링
// NATURE : 자연
// NIGHT_VIEW : 아경
// HISTORY : 역사
// THEME_PARK : 테마파크
// TransCategory
// WALK : 도보
// BIKE : 자전거
// CAR : 자동차
// PUBLIC_TRANSPORTATION : 대중교통
// WithCategory
// ALONE : 혼자
// FRIEND : 친구
// COUPLE : 커플
// KID : 아이와
// PET : 반려동물과

struct SelectTagView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTagView()
    }
}
