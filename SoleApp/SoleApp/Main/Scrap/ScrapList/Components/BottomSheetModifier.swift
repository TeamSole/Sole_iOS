//
//  BottomSheetModifier.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import SwiftUI

struct BottomSheetModifier: ViewModifier {
    @Binding var showFlag: Bool
    let edit: () -> ()
    let remove: () -> ()
    func body(content: Content) -> some View {
        ZStack() {
            content
                .zIndex(0)
            if showFlag {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.top)
                    .onTapGesture {
                        showFlag = false
                    }
                VStack(spacing: 0.0) {
                    Spacer()
                        .onTapGesture {
                            showFlag = false
                        }
                    bottomSheetView
                }
                .animation(.easeInOut(duration: 0.3))
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
    }
    
    private var bottomSheetView: some View {
        VStack(spacing: 20.0) {
            HStack(spacing: 14.0) {
                Image("edit")
                    .resizable()
                    .frame(width: 19,
                           height: 19.0)
                Text("폴더명 수정")
                    .font(.pretendard(.medium, size: 15.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
            }
            .onTapGesture {
                showFlag = false
                edit()
            }
            
            HStack(spacing: 14.0) {
                Image("delete")
                Text("폴더 삭제")
                    .font(.pretendard(.medium, size: 15.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
            }
            .onTapGesture {
                showFlag = false
                remove()
            }
        }
        .padding(16.0)
        .padding(.top, 26.0)
        .background(RoundedCorners(color: Color.white,
                                   tl:    20.0,
                                   tr:    20.0)
//            .edgesIgnoringSafeArea(.bottom)
        )
    }
}

struct BottomSheetModifier_Previews: PreviewProvider {
    static var previews: some View {
        Color.red
            .modifier(BottomSheetModifier(showFlag: .constant(true), edit: {}, remove: {}))
    }
}
