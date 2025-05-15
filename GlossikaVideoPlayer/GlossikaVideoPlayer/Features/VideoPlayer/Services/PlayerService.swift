//
//  PlayerService.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/14.
//

import AVKit
import Combine
import Foundation

// MARK: - PlayerService

final class PlayerService: ObservableObject {
    // MARK: - Public Properties

    let player: AVPlayer

    // MARK: - Input

    let playTapped = PassthroughSubject<Void, Never>()
    let pauseTapped = PassthroughSubject<Void, Never>()
    let playPauseTapped = PassthroughSubject<Void, Never>()
    let rewindTapped = PassthroughSubject<Void, Never>()
    let fastForwardTapped = PassthroughSubject<Void, Never>()
    let seekToTime = PassthroughSubject<Double, Never>()

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private var timeObserver: Any?

    // MARK: - Output

    @Published var isLoading = true
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 1
    @Published var bufferProgress: Double = 0
    @Published var isReadyToPlay = false

    init(url: URL) {
        player = AVPlayer(url: url)

        player.automaticallyWaitsToMinimizeStalling = false
        player.currentItem?.preferredForwardBufferDuration = 0

        bind()
        observeTime()
        observeStatus()
        observeTimeControlStatus()
    }

    deinit {
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }
}

// MARK: - Bind

private extension PlayerService {
    func bind() {
        playTapped.sink { [weak self] in
            guard let self = self else { return }
            self.player.play()
            self.isPlaying = true
        }.store(in: &cancellables)

        pauseTapped.sink { [weak self] in
            guard let self = self else { return }
            self.player.pause()
            self.isPlaying = false
        }.store(in: &cancellables)

        playPauseTapped
            .sink { [weak self] in
                guard let self = self else { return }
                if self.isPlaying {
                    self.player.pause()
                } else {
                    self.player.play()
                }
                self.isPlaying.toggle()
            }.store(in: &cancellables)

        rewindTapped
            .sink { [weak self] in
                guard let self = self else { return }
                let targetTime = max(self.currentTime - 10, 0)

                let cmTime = CMTime(seconds: targetTime, preferredTimescale: 600)

                // 精確跳轉
                self.player.currentItem?.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero
                ) { finished in
                    // 立刻播放
                    if self.isPlaying {
                        self.player.setRate(1.0, time: cmTime, atHostTime: CMTime.invalid)
                    }
                }
            }.store(in: &cancellables)

        fastForwardTapped
            .sink { [weak self] in
                guard let self = self else { return }
                let targetTime = min(self.currentTime + 10, self.duration)
                self.player.seek(to: CMTime(seconds: targetTime, preferredTimescale: 600))
            }.store(in: &cancellables)

        // 跳轉播放時間
        seekToTime
            .sink { [weak self] time in
                guard let self = self else { return }
                // 時間基準（1 秒 = 600 單位）
                self.isLoading = true
                self.player.seek(to: CMTime(seconds: time, preferredTimescale: 600)) { _ in
                    self.isLoading = false
                }
            }.store(in: &cancellables)
    }
}

// MARK: - Private Methods

private extension PlayerService {
    func observeStatus() {
        player.currentItem?.publisher(for: \.status)
            .sink { [weak self] status in
                guard let self = self else { return }

                switch status {
                case .readyToPlay:
                    self.observeBuffer()
                    self.isReadyToPlay = true
                    self.isLoading = false
                case .failed:
                    self.player.pause()
                    self.isReadyToPlay = false
                    self.isPlaying = false
                case .unknown:
                    self.player.pause()
                    self.isReadyToPlay = false
                    self.isPlaying = false
                @unknown default:
                    fatalError()
                }
            }
            .store(in: &cancellables)
    }

    func observeTime() {
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
            self.duration = self.player.currentItem?.duration.seconds ?? 1
        }
    }

    func observeBuffer() {
        player.currentItem?.publisher(for: \.loadedTimeRanges)
            .sink { [weak self] ranges in
                guard let self = self,
                      let timeRange = ranges.first?.timeRangeValue else { return }

                let duration = self.duration
                guard duration > 0 else {
                    self.bufferProgress = 0
                    return
                }

                let buffered = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration)
                self.bufferProgress = min(buffered / duration, 1.0)
            }
            .store(in: &cancellables)
    }

    func observeTimeControlStatus() {
        player.publisher(for: \.timeControlStatus)
            .receive(on: RunLoop.main)
            .sink { [weak self] status in
                guard let self = self else { return }
                switch status {
                case .waitingToPlayAtSpecifiedRate:
                    // AVPlayer 正在緩衝/等待播放
                    self.isLoading = true
                case .playing:
                    // 已經在播放
                    self.isLoading = false
                case .paused:
                    // 暫停時當作家載完成
                    self.isLoading = false
                @unknown default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
