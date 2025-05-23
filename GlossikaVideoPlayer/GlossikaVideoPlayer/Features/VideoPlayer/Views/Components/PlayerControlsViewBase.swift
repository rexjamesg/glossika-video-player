//
//  PlayerControlsViewBase.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/14.
//

import SwiftUI

// MARK: - PlayerControlsViewBase

struct PlayerControlsViewBase: View {
    @EnvironmentObject var viewModel: PlayerContainerViewModel

    var body: some View {
        ZStack {
            VStack {
                VStack {                    
                    if viewModel.isLoading || viewModel.isSeeking {
                        Spacer()
                        setProgressView()
                        Spacer()
                    }
                }
                Spacer()
                PlaybackOverlayView()
                    .environmentObject(viewModel)
            }
            PlayerControlsView()
                .environmentObject(viewModel)
        }
        .background(.black.opacity(0.6))
        .padding(.bottom, 0)
    }
}

// MARK: - Private Methods

private extension PlayerControlsViewBase {
    func setProgressView() -> some View {
        ProgressView()
            .scaleEffect(2)
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(width: 40, height: 40)
            .transition(.opacity)
    }
}

// MARK: - PlayerControlsViewBase_Previews

struct PlayerControlsViewBase_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlsViewBase()
            .environmentObject(PlayerContainerViewModel.mock)
            .previewLayout(.sizeThatFits)
    }
}
