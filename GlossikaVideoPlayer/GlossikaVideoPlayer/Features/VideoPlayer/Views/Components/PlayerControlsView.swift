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
                    viewModel.playerAction.send(.rewind())
                }
                               
                Spacer()

                setActionButton(imageName: viewModel.isPlaying ? "pause.fill" : "play.fill") {
                    viewModel.playerAction.send(.togglePlay)
                }
                
                Spacer()

                setActionButton(imageName: "goforward.10") {
                    viewModel.playerAction.send(.fastForward())
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
