//
//  SelectTagView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI
import Alamofire

enum SelectType {
    case first, add, filter
}

enum SelectTagCategory: CaseIterable {
    case location
    case tasty
    
    var title: String {
        switch self {
        case .location:
            "지역"
        case .tasty:
            "취향"
        }
    }
}

struct SelectTagView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedPlace: [Category] = []
    @State private var selectedWith: [Category] = []
    @State private var selectedTrans: [Category] = []
    @State private var availableWidth: CGFloat = 10
    @State private var selectedCategory: SelectTagCategory = .tasty
    
    @State private var selectedMainLocation: KoreaLocation = .Seoul
    @State private var selectedLocation: [LocationModel] = []
    
    private let selectCategoryAllCase: [SelectTagCategory]
    let isHiddenLocationSection: Bool
    var selectType: SelectType
    let complete: ([String], [String], [String], [LocationModel]) -> Void
    
    init(isHiddenLocationSection: Bool = true,
         selectedPlace: [String] = [],
         selectedWith: [String] = [],
         selectedTrans: [String] = [],
         selectedResion: [LocationModel] = [],
         selectType: SelectType,
         complete: @escaping ([String], [String], [String], [LocationModel]) -> Void) {
        self.isHiddenLocationSection = isHiddenLocationSection
        if isHiddenLocationSection == true {
            selectCategoryAllCase = [.tasty]
        } else {
            selectCategoryAllCase = SelectTagCategory.allCases
        }
        self._selectedPlace = State(initialValue: selectedPlace.map({ Category(rawValue: $0) ?? .none}).filter({ $0 != .none}))
        self._selectedWith = State(initialValue: selectedWith.map({ Category(rawValue: $0) ?? .none}).filter({ $0 != .none}))
        self._selectedTrans = State(initialValue: selectedTrans.map({ Category(rawValue: $0) ?? .none}).filter({ $0 != .none}))
        self.selectType = selectType
        self.complete = complete
    }
    
    
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
                .padding(.horizontal, 16.0)
                .isHidden(selectType == .first, remove: true)
            switch selectedCategory {
            case .location:
                locationCategoryView
            case .tasty:
                ScrollView {
                    VStack(spacing: 0.0) {
                        if selectType == .first {
                            firstSelectTopBar
                        }
                        tagItems(title: "장소", categories: placeCategory, index: 0)
                        tagItems(title: "동행", categories: withCategory, index: 1)
                        tagItems(title: "교통", categories: transCategory, index: 2)
                    }
                }
            }
            
            confirmButtonView
                .padding(16.0)
        }
        .onLoaded {
            if selectType == .add {
                getTaste()
            }
        }
        
    }
}

extension SelectTagView {
    private var navigationBar: some View {
        VStack(spacing: 0.0) {
            HStack {
                HStack(spacing: 12.0) {
                    ForEach(selectCategoryAllCase, id: \.self) { category in
                        Text(category.title)
                            .foregroundColor(selectedCategory == category ? .black : .gray_999999)
                            .font(.pretendard(.bold, size: 16.0))
                            .onTapGesture {
                                selectedCategory = category
                            }
                    }
                }
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.leading, 16.0)
                Image("closeBk")
                    .padding(.trailing, 16.0)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
            .frame(height: 60.0)
            Color.gray_EDEDED
                .frame(height: 1.0)
                .frame(maxWidth: .infinity)
        }
    }
    
    private var firstSelectTopBar: some View {
        VStack(spacing: 0.0) {
            Text("건너뛰기")
                .foregroundColor(.black)
                .font(.pretendard(.reguler, size: 12.0))
                .frame(maxWidth: .infinity,
                       alignment: .trailing)
                .padding(.trailing, 16.0)
                .padding(.vertical, 35.0)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("내 취향 코스를 추천받기 위해\n선호하는 코스의 태그를 설정해주세요.")
                .foregroundColor(.black)
                .font(.pretendard(.bold, size: 16.0))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity,
                       alignment: .center)
                .padding(.bottom, 50.0)
            
        }
    }
    
    private var locationCategoryView: some View {
        VStack(spacing: 0.0) {
            HStack(spacing: 0.0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0.0) {
                        ForEach(KoreaLocation.allCases, id: \.self) { location in
                            Text(location.koreanName)
                                .font(.pretendard(.medium, size: 16.0))
                                .foregroundColor(selectedMainLocation == location ? .blue_4708FA : .black_151515)
                                .frame(width: 135.0,
                                       height: 40.0)
                                .background(selectedMainLocation == location ? Color.white: Color.gray_EDEDED)
                                .onTapGesture {
                                    selectedMainLocation = location
                                }
                        }
                    }
                }
                .frame(width: 135.0)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0.0) {
                        ForEach(selectedMainLocation.getInnerLocations(), id: \.id) { innerLocation in
                            Text(innerLocation.locationName)
                                .font(.pretendard(.medium, size: 14.0))
                                .foregroundColor(selectedLocation.contains(innerLocation) ? .blue_4708FA : .black_151515)
                                .padding(.leading, 20.0)
                                .frame(height: 40.0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture {
                                    if selectedLocation.contains(innerLocation) {
                                        selectedLocation = selectedLocation.filter({ $0 != innerLocation })
                                    } else {
                                        selectedLocation.append(innerLocation)
                                    }
                                }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(spacing: 8.0) {
                HStack(spacing: 8.0) {
                    Text("선택한 지역")
                        .foregroundColor(.black)
                        .font(.pretendard(.medium, size: 14.0))
                    Text("\(selectedLocation.count)")
                        .foregroundColor(.blue_4708FA)
                        .font(.pretendard(.medium, size: 14.0))
                }
                .frame(maxWidth: .infinity, 
                       alignment: .leading)
               
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                        ForEach(selectedLocation) { selectedLocation in
                            HStack(spacing: 4.0) {
                                Text(selectedLocation.mainLocationName)
                                Text(">")
                                Text(selectedLocation.locationName)
                                Image("close")
                                    .onTapGesture {
                                        self.selectedLocation = self.selectedLocation.filter({ $0 != selectedLocation })
                                    }
                                
                            }
                            .padding(.horizontal, 8.0)
                            .frame(height: 30.0)
                            .background(Color.gray_EDEDED)
                            .cornerRadius(4.0)
                            
                        }
                    }
                }
            }
            .padding(.leading, 16.0)
            .padding(.vertical, 12.0)
            .isHidden(selectedLocation.isEmpty == true, 
                      remove: true)
        }
    }
    
    private func tagItems(title: String, categories: [Category], index: Int) -> some View {
        VStack(alignment: .leading, spacing: 0.0) {
                Text(title)
                    .font(.pretendard(.bold, size: 14.0))
                    .foregroundColor(.black)
//                    .padding(.bottom, 12.0)
                    .padding(.leading, 16.0)
                Color.clear
                    .frame(height: 1.0)
                    .readSize { size in
                        availableWidth = size.width
                    }
                TagListView(data: categories,
                            spacing: 8.0,
                            alignment: .leading,
                            availableWidth: availableWidth) { item in
                    HStack(spacing: 0.0) {
                        Text(item.title)
                            .foregroundColor(selectedArray(index: index).contains(item) ? .white : .black)
                            .padding(.horizontal, 10.0)
                            .font(.pretendard(.reguler, size: 11.0))
                            .frame(height: 34.0)
                            .padding(.horizontal, 8.0)
                            .background(selectedArray(index: index).contains(item) ? Color.blue_4708FA : Color.white)
                            .cornerRadius(17.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 17.0)
                                    .stroke(Color.gray_EDEDED, lineWidth: 1.0)
                            )
                            .onTapGesture {
                                if selectedArray(index: index).contains(item) {
                                    if index == 0 {
                                        selectedPlace = selectedPlace.filter({ $0 != item })
                                    } else if index == 1 {
                                        selectedWith = selectedWith.filter({ $0 != item })
                                    } else {
                                        selectedTrans = selectedTrans.filter({ $0 != item })
                                    }
                                    
                                } else {
                                    if index == 0 {
                                        selectedPlace.append(item)
                                    } else if index == 1 {
                                        selectedWith.append(item)
                                    } else {
                                        selectedTrans.append(item)
                                    }
                                }
                            }
                    }
                    
    
            }
            .padding(16.0)
        }
        .padding(.vertical, 10.0)
        .padding(.horizontal, 16.0)
    }
    
    private var confirmButtonView: some View {
        Text("적용하기")
            .foregroundColor(.white)
            .font(.pretendard(.bold, size: 16.0))
            .frame(maxWidth: .infinity)
            .frame(height: 48.0)
            .background(Color.blue_4708FA.cornerRadius(8.0))
            .padding(.horizontal, 16.0)
            .padding(.top, 12.0)
            .contentShape(Rectangle())
            .onTapGesture {
                complete(selectedPlace.map({$0.rawValue}),
                         selectedWith.map({$0.rawValue}),
                         selectedTrans.map({$0.rawValue}),
                         selectedLocation)
                presentationMode.wrappedValue.dismiss()
            }
        
    }
    
    func getTaste() {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.category)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: CategoryModelResponse.self, completionHandler: { response in
                switch response.result {
                case .success(let response):
                    if response.success == true,
                       let data = response.data {
                        selectedPlace = data.placeCategories.map({ Category(rawValue: $0) ?? .CAFE })
                        selectedWith = data.withCategories.map({ Category(rawValue: $0) ?? .ALONE })
                        selectedTrans = data.transCategories.map({ Category(rawValue: $0) ?? .WALK })
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
}

extension SelectTagView {
    private func selectedArray(index: Int) -> [Category] {
        if index == 0 {
            return selectedPlace
        } else if index == 1 {
            return selectedWith
        } else {
            return selectedTrans
        }
    }
    private var placeCategory: [Category] {
        return [.TASTY_PLACE, .CAFE, .CULTURE_ART, .ACTIVITY, .HEALING, .NATURE, .NIGHT_VIEW, .HISTORY, .THEME_PARK]
    }
    
    private var transCategory: [Category] {
        return [.WALK, .BIKE, .CAR, .PUBLIC_TRANSPORTATION]
        
    }
    
    private var withCategory: [Category] {
        return [.ALONE, .FRIEND, .COUPLE, .KID, .PET]
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
        SelectTagView(isHiddenLocationSection: false, selectType: .add, complete: {_,_,_,_ in })
            .previewDevice("iphone11")
    }
}
