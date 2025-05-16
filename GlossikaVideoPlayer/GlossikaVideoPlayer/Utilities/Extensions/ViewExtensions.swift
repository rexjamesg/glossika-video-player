//
//  ViewExtensions.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/14.
//

import SwiftUI

// MARK: - Toast

extension View {
    func bottomToast(isPresented: Binding<Bool>, message: String, type: ToastType = .info) -> some View {
        modifier(BottomToastViewModifier(isPresent: isPresented, message: message, type: type))
    }
}

// MARK: - Rotation

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        modifier(DeviceRotationViewModifier(action: action))
    }
}
