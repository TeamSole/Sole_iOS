//
//  BasePopupModifier.swift
//  SoleApp
//
//  Created by SUN on 2023/03/18.
//

import SwiftUI

enum AlertType {
    case remove, declare, withdrawal, logout
    
    var title: String {
        switch self {
        case .remove:
            return "작성하신 코스를 삭제하시겠습니까?"
        case .declare:
            return "해당 코스를 신고하시겠습니까?"
        case .withdrawal:
            return "탈퇴 시 쏠을 이용할 수 없어요.\n정말 탈퇴하시겠어요?"
        case .logout:
            return "로그아웃 하시겠어요?"
        }
    }
    
    var confirmTitle: String {
        switch self {
        case .remove:
            return "삭제하기"
        case .declare:
            return "신고하기"
        case .withdrawal:
            return "탈퇴하기"
        case .logout:
            return "로그아웃"
        }
    }
}

struct BasePopupModifier: ViewModifier {
    @Binding var isShowFlag: Bool
    let detailViewAlertType: AlertType
    let complete: () -> ()
    func body(content: Content) -> some View {
        ZStack() {
            content
            if isShowFlag {
                Color.black
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                contentView
            }
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 0.0) {
            Text(detailViewAlertType.title)
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
                Text(detailViewAlertType.confirmTitle)
                    .foregroundColor(.white)
                    .font(.pretendard(.bold, size: 16.0))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48.0)
                    .background(RoundedRectangle(cornerRadius: 8.0).foregroundColor(.blue_4708FA))
                    .onTapGesture {
                        isShowFlag = false
                        complete()
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

struct CourseDetailPopupModifier_Previews: PreviewProvider {
    static var previews: some View {
        Color.red
            .modifier(BasePopupModifier(isShowFlag: .constant(true), detailViewAlertType: .declare,
                                                complete: {}))
    }
}
