//
//  HistoryView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/12.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

extension HistoryView {
    private var naviagationBar: some View {
        HStack(spacing: 0.0) {
            Text("나의 기록")
                .font(.pretendard(.bold, size: 14.0))
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
