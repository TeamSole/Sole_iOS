//
//  ViewDidLoadModifier.swift
//  Release
//
//  Created by SUN on 2023/09/08.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if self.didLoad == false {
                self.didLoad = true
                self.action?()
            }
        }
    }
}
