//
//  PlayerControlsView.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/14.
//

import SwiftUI

struct PlayerControlsView: View {
    @ObservedObject var viewModel: PlayerContainerViewModel
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                setActionButton(imageName: "gobackward.10") {
                    viewModel.rewindTapped.send()
                }
                               
                Spacer()

                setActionButton(imageName: viewModel.isPlaying ? "pause.fill" : "play.fill") {
                    viewModel.playPauseTapped.send()
                }
                
                Spacer()

                setActionButton(imageName: "goforward.10") {
                    viewModel.fastForwardTapped.send()
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)

            Spacer()
        }
    }
}

//MARK: - Private Methods
private extension PlayerControlsView {
    func setActionButton(imageName: String, action: @escaping ()->Void) -> some View {
        Button {
            action()
            viewModel.resetAutoHide.send()
        } label: {
            Image(systemName: imageName)
                .font(.title)
        }
    }
}

struct PlayerControlsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlsView(viewModel: PlayerContainerViewModel.mock)
            .previewLayout(.sizeThatFits)
            .background(.gray)
    }
}
