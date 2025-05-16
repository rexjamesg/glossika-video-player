//
//  PlayerSlider.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/16.
//

import SwiftUI

struct PlayerSlider: View {
    @EnvironmentObject var viewModel: PlayerContainerViewModel

    var body: some View {
        Slider(value: Binding(
            get: {
                viewModel.duration.isFinite && viewModel.duration > 0
                    ? viewModel.currentTime
                    : 0
            },
            set: { newValue in if viewModel.duration.isFinite, viewModel.duration > 0 {
                viewModel.playerAction.send(.seek(to: newValue))
            }
            }
        ), in: 0 ... max(viewModel.duration, 1),
        onEditingChanged: { editing in
            viewModel.setSeekingStatus.send(editing)
            if editing {
                viewModel.playerAction.send(.pause)
            } else {
                viewModel.playerAction.send(.play)
            }
        })
    }
}



struct PlayerSlider_Previews: PreviewProvider {
    static var previews: some View {
        PlayerSlider().environmentObject(PlayerContainerViewModel.mock)
    }
}
