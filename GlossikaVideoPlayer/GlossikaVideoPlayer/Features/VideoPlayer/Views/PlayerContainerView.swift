//
//  PlayerContainerView.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/13.
//

import SwiftUI

// MARK: - PlayerContainerView

struct PlayerContainerView: View {
    @StateObject var viewModel: PlayerContainerViewModel
    @Environment(\.dismiss) private var dismiss

    init(url: URL) {
        _viewModel = StateObject(wrappedValue: PlayerContainerViewModel(url: url))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Color.black.ignoresSafeArea()
                                                
                VStack {
                    Button {
                        viewModel.playPauseTapped.send()
                    } label: {
                        VideoPlayerView(player: viewModel.player)
                            .frame(width: geometry.size.width, height: geometry.size.width*9/16)
                    }
                }
                
                CloseButton(action: { dismiss() })
                    .padding(.top, 48)
                    .padding(.leading, 16)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

// MARK: - PlayerContainerView_Previews

struct PlayerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        PlayerContainerView(url: url)
    }
}
