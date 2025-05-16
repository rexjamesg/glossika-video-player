//
//  PlayerContainerView.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/13.
//

import AVFoundation
import Combine
import SwiftUI

// MARK: - PlayerContainerView

/// 負責包裹 AVPlayer、控制列顯示／隱藏邏輯，以及螢幕旋轉鎖定
struct PlayerContainerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: PlayerContainerViewModel
    
    @State var showControls = true
    @State var autoHideControlsTask: DispatchWorkItem?
    @State private var orientation = UIDeviceOrientation.unknown

    init(viewModel: PlayerContainerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Color.black.ignoresSafeArea()
                VStack {
                    Spacer()
                    ZStack {
                        if let player = viewModel.player {
                            setVideoPlayerView(player: player, geometry: geometry)
                        }

                        if showControls {
                            setPlayerControlsViewBase()
                        }
                    }
                    Spacer()
                }

                if showControls {
                    setPlayerTopView()
                        .transition(.opacity)
                }
            }
            .background(Color.black.ignoresSafeArea())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onTapGesture {
                toggleControls()
            }
        }
        .onAppear {
            // 進入播放頁時開放所有方向
            AppDelegate.shared.orientationLock = .all
        }
        .onDisappear {
            // 離開播放頁時鎖回直向
            AppDelegate.shared.orientationLock = .portrait
            DispatchQueue.main.async {
                // 強制切回 portrait
                AppDelegate.shared.rotateScreen(to: .portrait)
            }
        }
        .onReceive(viewModel.$didPlayToEnd) { ended in
            if ended {
                showControls = true
            }
        }
        .onReceive(viewModel.orientationToRotate.compactMap { $0 }) { newOrientation in
            // 通知 AppDelegate 更新鎖定
            AppDelegate.shared.orientationLock = newOrientation
            AppDelegate.shared.rotateScreen(to: newOrientation)
        }
        .onReceive(viewModel.resetAutoHide) { _ in
            scheduleAutoHideControls()
        }
        .onReceive(viewModel.requestRotate, perform: { newOrientation in
            AppDelegate.shared.orientationLock = newOrientation
            AppDelegate.shared.rotateScreen(to: newOrientation)
        })
        .onChange(of: viewModel.isSeeking, perform: { isSeeking in
            if isSeeking {
                autoHideControlsTask?.cancel()
            } else {
                scheduleAutoHideControls()
            }
        })
        .onChange(of: viewModel.isReadyToPlay, perform: { isReadyToPlay in
            if isReadyToPlay {
                viewModel.playerAction.send(.play)
                scheduleAutoHideControls()
            }
        })
        .onRotate { orientation in
            // 偵測自動轉向的方向並通知改變轉向設定
            viewModel.autoChangeOrientation.send(orientation)
        }
    }
}

// MARK: - Private Methods

private extension PlayerContainerView {
    func setVideoPlayerView(player: AVPlayer, geometry: GeometryProxy) -> some View {
        VideoPlayerView(player: player)
            .frame(width: geometry.size.width, height: geometry.size.width * 9 / 16)
    }

    func setPlayerControlsViewBase() -> some View {
        //因ViewModel只有少數子View用不到的屬性，直接把VM注入環境，方便傳遞
        PlayerControlsViewBase()
            .environmentObject(viewModel)
            .transition(.opacity)            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func setPlayerTopView() -> some View {
        let title = viewModel.videoItem?.source.title ?? ""
        return PlayerTopView(title: title, action: { dismiss() }, color: .white)
            .padding(.top, 20)
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
        PlayerContainerView(viewModel: PlayerContainerViewModel.mock)
    }
}
