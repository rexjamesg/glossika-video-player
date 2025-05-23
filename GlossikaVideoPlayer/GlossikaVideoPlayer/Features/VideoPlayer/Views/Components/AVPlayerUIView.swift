//
//  AVPlayerUIView.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/13.
//

import Foundation
import SwiftUI
import AVKit

// MARK: - AVPlayerUIView

struct AVPlayerUIView: UIViewControllerRepresentable {
    let player: AVPlayer

    // 將 AVPlayerViewController 嵌入 SwiftUI，隱藏預設控制列
    func makeUIViewController(context _: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context _: Context) {
        uiViewController.player = player
    }
}
