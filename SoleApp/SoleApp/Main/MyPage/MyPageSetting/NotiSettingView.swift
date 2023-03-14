//
//  NotiSettingView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI

struct NotiSettingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isGetNoti: Bool = false
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            activityNotiTogleView
            Divider()
                .padding(.horizontal, 16.0)
            marketingNotiTogleView
            Spacer()
        }
    }
}

extension NotiSettingView {
    private var navigationBar: some View {
        ZStack {
            Image("arrow_back")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("알림 설정")
                .foregroundColor(.black)
                .font(.pretendard(.medium, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .center)
        }
        .frame(height: 48.0)
        .padding(.horizontal, 16.0)
    }
    
    private var activityNotiTogleView: some View {
        HStack(spacing: 0.0) {
            Toggle(isOn: $isGetNoti,
                   label: {
                VStack(spacing: 4.0) {
                    Text("활동 알림")
                        .font(.pretendard(.medium, size: 16.0))
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                    Text("팔로우, 스크랩 등 내 활동 알림을 받아볼 수 있어요")
                        .font(.pretendard(.reguler, size: 13.0))
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                }
            })
        }
        .padding(16.0)
    }
    
    private var marketingNotiTogleView: some View {
        HStack(spacing: 0.0) {
            Toggle(isOn: $isGetNoti,
                   label: {
                VStack(spacing: 4.0) {
                    Text("마케팅 알림")
                        .font(.pretendard(.medium, size: 16.0))
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                    Text("최신 큐레이션 정보, 이벤트 등을 빠르게 알려드려요")
                        .font(.pretendard(.reguler, size: 13.0))
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                }
            })
        }
        .padding(16.0)
    }
}

struct NotiSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NotiSettingView()
    }
}
