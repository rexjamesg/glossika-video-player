//
//  PlayerContainerViewModel.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/13.
//

import AVFoundation
import Combine
import Foundation
import UIKit

// MARK: - PlayerContainerViewModel

class PlayerContainerViewModel: ObservableObject {
    // MARK: - Public Properties

    var player: AVPlayer? { playerService?.player }

    // MARK: - Input

    let loadVideo = PassthroughSubject<VideoItem, Never>()
    let resetAutoHide = PassthroughSubject<Void, Never>()
    let toggleFullScreenTapped = PassthroughSubject<Void, Never>()
    let requestRotate = PassthroughSubject<UIInterfaceOrientationMask, Never>()
    let setSeekingStatus = PassthroughSubject<Bool, Never>()
    let autoChangeOrientation = PassthroughSubject<UIDeviceOrientation, Never>()

    // Player事件
    let playerAction = PassthroughSubject<PlayerAction, Never>()

    // MARK: - Output

    let orientationToRotate = PassthroughSubject<UIInterfaceOrientationMask, Never>()
    /// 是否是全螢幕（橫向）狀態
    @Published private(set) var isFullScreen = false
    @Published private(set) var bufferProgress: Double = 0
    @Published private(set) var isLoading = true
    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var currentTime: Double = 0
    @Published private(set) var duration: Double = 1
    @Published private(set) var isReadyToPlay = false
    @Published private(set) var isSeeking: Bool = false
    @Published private(set) var didPlayToEnd = false

    private(set) var videoItem: VideoItem?

    // MARK: - Private Properties

    private var playerService: PlayerService?
    private var cancellables = Set<AnyCancellable>()

    init() {
        bind()
    }

    func load(url: URL) {
        playerService = PlayerService(url: url)
        bindPlayerService()
        bindActionSubject()
    }
}

// MARK: - Bind

private extension PlayerContainerViewModel {
    func bind() {
        loadVideo.sink { [weak self] videoItem in
            guard let self = self else { return }
            self.videoItem = videoItem
            if let url = videoItem.source.url {
                self.load(url: url)
            }
        }
        .store(in: &cancellables)

        requestRotate.sink { [weak self] orientation in
            guard let self = self else { return }
            self.orientationToRotate.send(orientation)
        }.store(in: &cancellables)

        setSeekingStatus.sink { [weak self] seekingStatus in
            guard let self = self else { return }
            self.isSeeking = seekingStatus
        }.store(in: &cancellables)

        // 處理全螢幕切換的輸入
        toggleFullScreenTapped
            .sink { [weak self] in
                guard let self = self else { return }
                let newOrientation: UIInterfaceOrientationMask = self.isFullScreen
                    ? .portrait
                    : .landscape

                // 發出旋轉請求
                self.requestRotate.send(newOrientation)
                // 更新狀態
                self.isFullScreen.toggle()
            }
            .store(in: &cancellables)

        // 處理自動轉向
        autoChangeOrientation
            .sink { [weak self] orientation in
                guard let self = self else { return }
                if orientation == .landscapeRight || orientation == .landscapeLeft {
                    self.isFullScreen = true
                    self.requestRotate.send(.landscape)
                } else {
                    self.requestRotate.send(.all)
                    self.isFullScreen = false
                }
            }.store(in: &cancellables)
    }

    func bindActionSubject() {
        playerAction
            .sink { [weak self] action in
                guard let self = self else { return }
                // 重設 didPlayToEnd，只要使用者又seek或play，就要回到還沒結束狀態
                switch action {
                case .seek, .play, .togglePlay, .rewind, .fastForward:
                    self.didPlayToEnd = false
                default: break
                }
                self.playerService?.playerAction.send(action)
            }
            .store(in: &cancellables)
    }

    /// 監聽 PlayerService 狀態，更新 UI 綁定的 published 屬性
    func bindPlayerService() {
        playerService?.$isPlaying
            .receive(on: RunLoop.main)
            .assign(to: &$isPlaying)

        playerService?.$currentTime
            .map { seconds -> Double in
                // 在真正播放超過 1 秒前，一律回傳 0
                seconds > 1 ? seconds : 0
            }
            .receive(on: RunLoop.main)
            .assign(to: &$currentTime)

        playerService?.$duration
            .receive(on: RunLoop.main)
            .assign(to: &$duration)

        playerService?.$bufferProgress
            .map { [weak self] progress in
                // 如果還沒進入播放（currentTime==0），就回傳 0
                (self?.currentTime ?? 0) == 0 ? 0 : progress
            }
            .receive(on: RunLoop.main)
            .assign(to: &$bufferProgress)

        playerService?.$isReadyToPlay
            .receive(on: RunLoop.main)
            .assign(to: &$isReadyToPlay)

        playerService?.$isLoading
            .receive(on: RunLoop.main)
            .assign(to: &$isLoading)

        playerService?.$didPlayToEnd
            .receive(on: RunLoop.main)
            .assign(to: &$didPlayToEnd)
    }
}

// MARK: - Mock Data

extension PlayerContainerViewModel {
    static let mock = PlayerContainerViewModel()
}
