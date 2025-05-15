//
//  GlossikaVideoPlayerApp.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/13.
//

import SwiftUI

// MARK: - GlossikaVideoPlayerApp

@main
struct GlossikaVideoPlayerApp: App {
    init() {
        // 在應用啟動時初始化 AppDelegate
        AppDelegate.shared = AppDelegate()
    }

    var body: some Scene {
        WindowGroup {
            VideoListView()
        }
    }
}

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    static var shared: AppDelegate! // Access to AppDelegate
    var orientationLock: UIInterfaceOrientationMask = .portrait

    func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }

    func rotateScreen(to orientation: UIInterfaceOrientationMask) {
        // 全螢幕切換動作
        AppDelegate.shared.orientationLock = orientation

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
    }

}
