//
//  BottomToastViewModifier.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/14.
//

import Foundation
import SwiftUI

struct BottomToastViewModifier: ViewModifier {
    @Binding var isPresent: Bool
    let message: String
    let type: ToastType

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresent {
                BottomToastView(message: message, type: type)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut(duration: 0.4)) { // 離場動畫
                                isPresent = false
                            }
                        }
                    }
            }
        }
    }
}
