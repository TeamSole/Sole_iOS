//
//  FolderPopupTextFieldModifier.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import SwiftUI

enum FolderPopupType {
    case add, rename, remove
    
    var title: String {
        switch self {
        case .add:
            return "새 폴더"
        case .rename:
            return "폴더명 수정"
        case .remove:
            return "폴더를 삭제하시겠습어요?"
        }
    }
    
    var confirmTitle: String {
        switch self {
        case .add:
            return "만들기"
        case .rename:
            return "수정하기"
        case .remove:
            return "삭제하기"
        }
    }
}

struct FolderPopupTextFieldModifier: ViewModifier {
    @State private var textFieldInput: String = ""
    @Binding var isShowFlag: Bool
    let folderPopupType: FolderPopupType
    let complete: (String) -> ()
    func body(content: Content) -> some View {
        ZStack() {
            content
            if isShowFlag {
                Color.black
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                if folderPopupType == .add || folderPopupType == .rename {
                    textFieldContentView
                } else {
                    contentView
                }
            }
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 0.0) {
            Text(folderPopupType.title)
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.black)
                .padding(.vertical, 30.0)
            HStack(spacing: 7.0) {
                Text("취소")
                    .foregroundColor(.white)
                    .font(.pretendard(.bold, size: 16.0))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48.0)
                    .background(RoundedRectangle(cornerRadius: 8.0).foregroundColor(.gray_D3D4D5))
                    .onTapGesture {
                        isShowFlag = false
                    }
                Text(folderPopupType.confirmTitle)
                    .foregroundColor(.white)
                    .font(.pretendard(.bold, size: 16.0))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48.0)
                    .background(RoundedRectangle(cornerRadius: 8.0).foregroundColor(.blue_4708FA))
                    .onTapGesture {
                        isShowFlag = false
                        complete("")
                    }
            }
            .frame(maxWidth: .infinity)
            .padding(12.0)
        }
        .background(Color.white)
        .frame(width: 300.0)
        .cornerRadius(10.0)
    }
    
    private var textFieldContentView: some View {
        VStack(spacing: 0.0) {
            Text(folderPopupType.title)
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.black)
                .padding(.vertical, 30.0)
            TextField(" 폴더명", text: $textFieldInput)
                .frame(height: 44.0)
                .border(Color.gray_D3D4D5, width: 1.0)
                .padding(.horizontal, 12.0)
            HStack(spacing: 7.0) {
                Text("취소")
                    .foregroundColor(.white)
                    .font(.pretendard(.bold, size: 16.0))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48.0)
                    .background(RoundedRectangle(cornerRadius: 8.0).foregroundColor(.gray_D3D4D5))
                    .onTapGesture {
                        isShowFlag = false
                    }
                Text(folderPopupType.confirmTitle)
                    .foregroundColor(.white)
                    .font(.pretendard(.bold, size: 16.0))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48.0)
                    .background(RoundedRectangle(cornerRadius: 8.0).foregroundColor(textFieldInput.isEmpty ? .gray_D3D4D5 : .blue_4708FA))
                    .onTapGesture {
                        guard textFieldInput.isEmpty == false else { return }
                        isShowFlag = false
                        complete(textFieldInput)
                    }
            }
            .frame(maxWidth: .infinity)
            .padding(12.0)
        }
        .background(Color.white)
        .frame(width: 300.0)
        .cornerRadius(10.0)
    }
    
}

struct FolderPopupTextFieldModifier_Previews: PreviewProvider {
    static var previews: some View {
        Color.red
            .modifier(FolderPopupTextFieldModifier(isShowFlag: .constant(true), folderPopupType: .add, complete: {_ in}))
    }
}
