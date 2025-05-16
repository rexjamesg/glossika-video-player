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
    // 沒有這段的話，SwiftUI App 啟動時不會把 AppDelegate 加入，supportedInterfaceOrientationsFor 不會被呼叫。
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        // 在應用啟動時初始化 AppDelegate
        AppDelegate.shared = appDelegate
    }

    var body: some Scene {
        WindowGroup {
            VideoListView()
        }
    }
}
