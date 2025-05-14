//
//  PlayerControlsViewBase.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/14.
//

import SwiftUI

struct PlayerControlsViewBase: View {
    @ObservedObject var viewModel: PlayerContainerViewModel

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                PlayerBufferView(viewModel: viewModel)
            }
            PlayerControlsView(viewModel: viewModel)
        }
        .background(.black.opacity(0.6))
        .padding(.bottom, 0)
    }
}


struct PlayerControlsViewBase_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlsViewBase(viewModel: PlayerContainerViewModel.mock)
            .previewLayout(.sizeThatFits)
            .aspectRatio(16 / 9, contentMode: .fit)
    }
}
