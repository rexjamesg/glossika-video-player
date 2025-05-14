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
    @State var showControls = true
    @State var autoHideControlsTask: DispatchWorkItem?
    @Environment(\.dismiss) private var dismiss

    init(url: URL) {
        _viewModel = StateObject(wrappedValue: PlayerContainerViewModel(url: url))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Color.black.ignoresSafeArea()
                VStack {
                    Spacer()
                    ZStack {
                        setVideoPlayerView(geometry: geometry)
                        
                        if showControls {
                            setPlayerControlsViewBase(geometry: geometry)
                                .transition(.opacity)
                        }
                    }
                    Spacer()
                }
                
                if showControls {
                    setCloseButton()
                        .transition(.opacity)
                }
            }
            .background(Color.black.ignoresSafeArea())
            .onTapGesture {
                toggleControls()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .onChange(of: viewModel.isReadyToPlay, perform: { newValue in
            if newValue {
                viewModel.playPauseTapped.send()
            }
        })
    }
}

// MARK: - Private Methods

private extension PlayerContainerView {
    func setVideoPlayerView(geometry: GeometryProxy) -> some View {
        VideoPlayerView(player: viewModel.player)
            .frame(width: geometry.size.width, height: geometry.size.width * 9 / 16)
    }

    func setPlayerControlsViewBase(geometry: GeometryProxy) -> some View {
        PlayerControlsViewBase(viewModel: viewModel)
            .frame(width: geometry.size.width, height: geometry.size.width * 9 / 16)
    }

    func setCloseButton() -> some View {
        CloseButton(action: {
            dismiss()
        }, color: .white)
            .padding(.top, 20)
            .padding(.leading, 20)
    }
    
    func toggleControls() {
        withAnimation { showControls.toggle() }

        autoHideControlsTask?.cancel()
        if showControls {
            let task = DispatchWorkItem {
                withAnimation { showControls = false }
            }
            autoHideControlsTask = task
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: task)
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


// MARK: - PlayerSlider

struct PlayerSlider: View {
    @ObservedObject var viewModel: PlayerContainerViewModel
    
    var body: some View {
        Slider(value: Binding(
            get: {
                viewModel.duration.isFinite && viewModel.duration > 0
                    ? viewModel.currentTime
                    : 0
            },
            set: { newValue in if viewModel.duration.isFinite, viewModel.duration > 0 {
                viewModel.seekToTime.send(newValue)
            }
            }
        ), in: 0 ... max(viewModel.duration, 1),
        onEditingChanged: { editing in
            if editing {
                viewModel.pauseTapped.send()
            } else {
                viewModel.playTapped.send()
            }
        })
    }
}
