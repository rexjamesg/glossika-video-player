//
//  AnyAnyTransitionExtensions.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/14.
//

import SwiftUI

extension AnyTransition {
    static let toastSlide: AnyTransition = .asymmetric(
        insertion: .move(edge: .bottom).combined(with: .opacity),
        removal : .offset(y: 300).combined(with: .opacity)
    )
}
