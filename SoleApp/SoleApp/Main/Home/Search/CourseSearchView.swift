//
//  CourseSearchView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/13.
//

import SwiftUI

struct CourseSearchView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var searchText: String = ""
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            searchItemListView
        }
        .navigationBarHidden(true)
    }
}

extension CourseSearchView {
    private var navigationBar: some View {
        HStack(spacing: 14.0) {
            HStack(spacing: 0.0) {
                Image(systemName: "magnifyingglass")
                TextField("검색", text: $searchText)
                    .frame(maxWidth: .infinity)
            }
            .padding(7.0)
            .background(Color.gray_EDEDED)
            .cornerRadius(10.0)
            Text("취소")
                .foregroundColor(.gray_404040)
                .font(.pretendard(.reguler, size: 14.0))
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        }
        .padding(.horizontal, 16.0)
        .frame(height: 50.0)
    }
    
    private var searchItemListView: some View {
        LazyVStack(spacing: 16.0) {
            HStack(spacing: 0.0) {
                Text("최근 검색")
                    .font(.pretendard(.bold, size: 14.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Text("전체 삭제")
                    .font(.pretendard(.bold, size: 12.0))
                    .foregroundColor(.blue_0996F6)
                
            }
            ForEach(0..<4) { index in
                searchHistoryItem(title: "\(index)")
            }
        }
        .frame(maxHeight: .infinity,
               alignment: .top)
        .padding(.horizontal, 16.0)
        .padding(.top, 28.0)
    }
    
    private func searchHistoryItem(title: String) -> some View {
        HStack(spacing: 0.0) {
            Text(title)
                .font(.pretendard(.reguler, size: 14.0))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            Image("close")
        }
        
    }
}

struct CourseSearchView_Previews: PreviewProvider {
    static var previews: some View {
        CourseSearchView()
    }
}
