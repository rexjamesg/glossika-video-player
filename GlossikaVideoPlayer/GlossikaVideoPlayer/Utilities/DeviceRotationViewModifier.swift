//
//  DeviceRotationViewModifier.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/16.
//

import Foundation
import SwiftUI

// 開始／停止產生裝置方向變化通知，並把變化傳出去
struct DeviceRotationViewModifier: ViewModifier {
    /// 回調的 closure，會回傳當前的 UIDeviceOrientation
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                // 開始產生方向改變的通知
                UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            }
            .onReceive(
                NotificationCenter.default
                    .publisher(for: UIDevice.orientationDidChangeNotification)
            ) { _ in
                action(UIDevice.current.orientation)
            }
            .onDisappear {
                // 釋放資源
                UIDevice.current.endGeneratingDeviceOrientationNotifications()
            }
    }
}
