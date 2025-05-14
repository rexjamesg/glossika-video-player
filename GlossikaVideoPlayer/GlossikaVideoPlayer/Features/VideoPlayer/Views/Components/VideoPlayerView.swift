//
//  VideoPlayerView.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/14.
//

import AVKit
import SwiftUI

// MARK: - VideoPlayerView

struct VideoPlayerView: View {
    let player: AVPlayer
    var body: some View {
        AVPlayerUIView(player: player)
            .aspectRatio(16 / 9, contentMode: .fit)
            .onDisappear {
                player.pause()
            }
    }
}

// MARK: - VideoPlayerView_Previews

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let demoURL = URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2021/10253/4/8E391590-5CCE-4D1A-A042-8354F4955272/master.m3u8")!
        let demoPlayer = AVPlayer(url: demoURL)

        VideoPlayerView(player: demoPlayer)
            .previewLayout(.sizeThatFits)
    }
}
