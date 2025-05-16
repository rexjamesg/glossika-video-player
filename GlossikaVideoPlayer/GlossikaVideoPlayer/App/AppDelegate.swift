//
//  AppDelegate.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/16.
//

import Foundation
import UIKit

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
        orientationLock = orientation

        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        else { return }
    
        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))

        windowScene.windows.first?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
    }
}
