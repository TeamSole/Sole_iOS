//
//  NotiListView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI

struct NotiListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            ScrollView {
                
            }
        }
    }
}

extension NotiListView {
    private var navigationBar: some View {
        ZStack {
            Image("arrow_back")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("알림 내역")
                .foregroundColor(.black)
                .font(.pretendard(.medium, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .center)
        }
        .frame(height: 48.0)
        .padding(.horizontal, 16.0)
    }
}

struct NotiListView_Previews: PreviewProvider {
    static var previews: some View {
        NotiListView()
    }
}
