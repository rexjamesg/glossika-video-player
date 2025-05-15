//
//  PlayerContainerView.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/13.
//

import Combine
import SwiftUI

// MARK: - PlayerContainerView

struct PlayerContainerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: PlayerContainerViewModel
    @State var showControls = true
    @State var autoHideControlsTask: DispatchWorkItem?
    @State private var orientation = UIDeviceOrientation.unknown

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

                if showControls && !viewModel.isFullScreen {
                    setCloseButton()
                        .transition(.opacity)
                }
            }
            .background(Color.black.ignoresSafeArea())
            .onTapGesture {
                toggleControls()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onAppear {
                AppDelegate.shared.orientationLock = .all
            }
            .onDisappear {
                AppDelegate.shared.orientationLock = .portrait
            }
            .onReceive(viewModel.orientationToRotate.compactMap { $0 }) { orientation in
                AppDelegate.shared.rotateScreen(to: orientation)
            }
            .onReceive(viewModel.resetAutoHide) { _ in
                scheduleAutoHideControls()
            }
        }
        .onChange(of: viewModel.isSeeking, perform: { isSeeking in
            if isSeeking {
                autoHideControlsTask?.cancel()
            } else {
                scheduleAutoHideControls()
            }
        })
        .onChange(of: viewModel.isReadyToPlay, perform: { isReadyToPlay in
            if isReadyToPlay {
                viewModel.playPauseTapped.send()
                scheduleAutoHideControls()
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
            scheduleAutoHideControls()
        }
    }

    func scheduleAutoHideControls() {
        autoHideControlsTask?.cancel()

        // 拖曳中不排程，防止拖曳過程控制列消失
        guard !viewModel.isSeeking else { return }

        let task = DispatchWorkItem {
            withAnimation {
                showControls = false
            }
        }
        autoHideControlsTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 拖曳結束才執行
            if !viewModel.isSeeking {
                task.perform()
            }
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
            viewModel.setSeekingStatus.send(editing)
            print("editing", editing)
            if editing {
                viewModel.pauseTapped.send()
            } else {
                viewModel.playTapped.send()
            }
        })
    }
}
