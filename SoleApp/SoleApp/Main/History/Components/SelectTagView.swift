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

struct SelectTagView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTagView()
    }
}
