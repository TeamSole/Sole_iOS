//
//  LocationSearchView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import SwiftUI
import Alamofire
import NMapsMap

struct LocationSearchView: View {
    typealias SearchResult = NaverSearchModel.Item
    typealias Course = RegisterCourseModelRequest.PlaceRequestDtos
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var searchText: String = ""
    @State private var apiRequestStatus: Bool = false
    @State private var searchResults: [SearchResult] = []
    let complete: (Course) -> ()
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            searchBar
            ScrollView {
                searhResultList
            }
        }
    }
}

extension LocationSearchView {
    private var navigationBar: some View {
        VStack(spacing: 0.0) {
            HStack {
                Text("장소 입력")
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
//            Color.gray_EDEDED
//                .frame(height: 1.0)
//                .frame(maxWidth: .infinity)
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 14.0) {
            HStack(spacing: 0.0) {
                Image(systemName: "magnifyingglass")
                TextField("장소 검색", text: $searchText,
                          onCommit: {
                    search(searchText: searchText)
                })
                    .frame(maxWidth: .infinity)
            }
            .padding(7.0)
            .background(Color.gray_EDEDED)
            .cornerRadius(10.0)
        }
        .padding(.horizontal, 16.0)
        .frame(height: 50.0)
    }
    
    private var searhResultList: some View {
        VStack(spacing: 0.0) {
            ForEach(0..<searchResults.count, id: \.self) { index in
                searchResultItem(item: searchResults[index])
            }
            Spacer()
        }
    }
    
    private func searchResultItem(item: SearchResult) -> some View {
        VStack(spacing: 0.0) {
            VStack(spacing: 0.0) {
                HStack(spacing: 12.0) {
                    Text(item.resultTitle)
                        .font(.pretendard(.medium, size: 15.0))
                        .foregroundColor(.black)
                    Text(item.category ?? "")
                        .font(.pretendard(.reguler, size: 12.0))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.bottom, 8.0)
                
                Text(item.roadAddress ?? "")
                    .font(.pretendard(.reguler, size: 12.0))
                    .foregroundColor(.gray_383838)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .padding(.bottom, 9.0)
            }
            .padding(16.0)
            Divider()
        }
        .onTapGesture {
            let x = Double(Int(item.mapx ?? "0") ?? 0)
            let y = Double(Int(item.mapy ?? "0") ?? 0)
            
            let gmt = NMGTm128(x: x, y: y)
            
            let course = Course(address: item.roadAddress ?? "", description: item.category ?? "", placeName: item.resultTitle, latitude: gmt.toLatLng().lat, longitude: gmt.toLatLng().lng )
            
            complete(course)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func search(searchText: String) {
        guard searchText.isEmpty == false,
        apiRequestStatus == false else { return }
        apiRequestStatus = true
        let query: String  = K.naverSearhUrl + "?query=\(searchText)&display=5"
        let encodedQuery: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url: URLConvertible = URL(string: encodedQuery)!
        
        let headers: HTTPHeaders = K.Header.naverSearhHeader
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: NaverSearchModel.self, completionHandler: { response in
                switch response.result {
                case .success(let response):
                    if let result = response.items {
                        self.searchResults = result
                    }
                    self.apiRequestStatus = false
                case .failure(let error):
                    print(error.localizedDescription)
                    self.apiRequestStatus = false
                }
            })
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(complete: {_ in})
    }
}
