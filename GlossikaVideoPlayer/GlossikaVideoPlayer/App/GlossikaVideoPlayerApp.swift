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

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    static var shared: AppDelegate!
    var orientationLock: UIInterfaceOrientationMask = .portrait

    override init() {
        super.init()
        // 這邊也要指派，不然orientationLock不會生效
        AppDelegate.shared = self
    }

    func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }

    /// 強制切換方向的 helper
    func rotateScreen(to orientation: UIInterfaceOrientationMask) {
        // 更新 lock
        // orientationLock = orientation

        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
        }

        // 強制改變目前“設備”的方向
        let deviceOrient: UIInterfaceOrientation = {
            switch orientation {
            case .portrait:
                return .portrait
            case .landscapeLeft:
                return .landscapeLeft
            default:
                return .landscapeRight
            }
        }()

        UIDevice.current.setValue(deviceOrient.rawValue, forKey: "orientation")

        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
            let root = windowScene.windows.first?.rootViewController
        {
            root.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
}
