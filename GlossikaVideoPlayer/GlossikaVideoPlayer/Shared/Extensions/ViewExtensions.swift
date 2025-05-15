//
//  ViewExtensions.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/14.
//

import SwiftUI

extension View {
    func bottomToast(isPresented: Binding<Bool>, message: String, type: ToastType = .info) -> some View {
        modifier(BottomToastViewModifier(isPresent: isPresented, message: message, type: type))
    }
}

// A View wrapper to make the modifier easier to use
//extension View {
//    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
//        modifier(DeviceRotationViewModifier(action: action))
//    }
//}

//// MARK: - DeviceRotationViewModifier
//
//struct DeviceRotationViewModifier: ViewModifier {
//    let action: (UIDeviceOrientation) -> Void
//
//    func body(content: Content) -> some View {
//        content
//            .onAppear()
//            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
//                action(UIDevice.current.orientation)
//            }
//    }
//}

