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

    let loadURL = PassthroughSubject<URL, Never>()
    let resetAutoHide = PassthroughSubject<Void, Never>()
    let toggleFullScreenTapped = PassthroughSubject<Void, Never>()
    let requestRotate = PassthroughSubject<UIInterfaceOrientationMask, Never>()
    let setSeekingStatus = PassthroughSubject<Bool, Never>()

    let playTapped = PassthroughSubject<Void, Never>()
    let pauseTapped = PassthroughSubject<Void, Never>()
    let fastForwardTapped = PassthroughSubject<Void, Never>()
    let rewindTapped = PassthroughSubject<Void, Never>()
    let playPauseTapped = PassthroughSubject<Void, Never>()
    let seekToTime = PassthroughSubject<Double, Never>()

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

    // MARK: - Private Properties

    private var playerService: PlayerService?
    private var cancellables = Set<AnyCancellable>()

    init() {
        bind()
    }

    func load(url: URL) {
        playerService = PlayerService(url: url)
        bindPlayerService()
    }
}

// MARK: - Bind

private extension PlayerContainerViewModel {
    func bind() {
        loadURL
            .sink { [weak self] url in
                self?.load(url: url)                
            }
            .store(in: &cancellables)

        playTapped.sink { [weak self] in
            guard let self = self else { return }
            self.playerService?.playTapped.send()
        }.store(in: &cancellables)

        pauseTapped.sink { [weak self] in
            guard let self = self else { return }
            self.playerService?.pauseTapped.send()
        }.store(in: &cancellables)

        playPauseTapped.sink { [weak self] in
            guard let self = self else { return }
            self.playerService?.playPauseTapped.send()
        }.store(in: &cancellables)

        fastForwardTapped.sink { [weak self] in
            guard let self = self else { return }
            self.playerService?.fastForwardTapped.send()
        }.store(in: &cancellables)

        rewindTapped.sink { [weak self] in
            guard let self = self else { return }
            self.playerService?.rewindTapped.send()
        }.store(in: &cancellables)

        seekToTime.sink { [weak self] time in
            guard let self = self else { return }
            self.playerService?.seekToTime.send(time)
        }.store(in: &cancellables)

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
                    : .landscapeRight

                // 發出旋轉請求
                self.requestRotate.send(newOrientation)
                // 更新狀態
                self.isFullScreen.toggle()
            }
            .store(in: &cancellables)
    }

    func bindPlayerService() {
        playerService?.$isPlaying
            .receive(on: RunLoop.main)
            .assign(to: &$isPlaying)

        playerService?.$currentTime
            .receive(on: RunLoop.main)
            .assign(to: &$currentTime)

        playerService?.$duration
            .receive(on: RunLoop.main)
            .assign(to: &$duration)

        playerService?.$bufferProgress
            .receive(on: RunLoop.main)
            .assign(to: &$bufferProgress)

        playerService?.$isReadyToPlay
            .receive(on: RunLoop.main)
            .assign(to: &$isReadyToPlay)

        playerService?.$isLoading
            .receive(on: RunLoop.main)
            .assign(to: &$isLoading)
    }
}

// MARK: - Mock Data

extension PlayerContainerViewModel {
    // static let mock = PlayerContainerViewModel(url: URL(string: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_2MB.mp4")!)

    static let mock = PlayerContainerViewModel()
}
