//
//  PlayerService.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/14.
//

import AVKit
import Combine
import Foundation

// MARK: - PlayerAction

// 列舉所有player相關操作
enum PlayerAction {
    case play
    case pause
    case fastForward(seconds: Double)
    case rewind(seconds: Double)
    case togglePlay
    case seek(to: Double)
}

extension PlayerAction {
    /// 省略秒數，使用預設 10 秒
    static func rewind() -> PlayerAction {
        .rewind(seconds: 10)
    }

    /// 省略秒數，使用預設 10 秒
    static func fastForward() -> PlayerAction {
        .fastForward(seconds: 10)
    }
}

// MARK: - PlayerService

final class PlayerService: ObservableObject {
    // MARK: - Public Properties

    let player: AVPlayer

    // MARK: - Input

    // Player事件
    let playerAction = PassthroughSubject<PlayerAction, Never>()

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
        // 取消 AVPlayer 自動停頓以最小化緩衝
        player.automaticallyWaitsToMinimizeStalling = false
        // 設定零預取，完全由自己控制 buffer 行為
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
        playerAction.sink { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .play:
                self.player.play()
                self.isPlaying = true

            case .pause:
                self.player.pause()
                self.isPlaying = false

            case .togglePlay:
                if self.isPlaying {
                    self.player.pause()
                } else {
                    self.player.play()
                }
                self.isPlaying.toggle()

            case .rewind:
                let targetTime = max(self.currentTime - 10, 0)
                let cmTime = CMTime(seconds: targetTime, preferredTimescale: 600)

                // 精確 seek，避免畫面跳動
                self.player.currentItem?.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero) { _ in
                    // 立刻播放
                    if self.isPlaying {
                        self.player.setRate(1.0, time: cmTime, atHostTime: CMTime.invalid)
                    }
                }

            case .fastForward:
                let targetTime = min(self.currentTime + 10, self.duration)
                self.player.seek(to: CMTime(seconds: targetTime, preferredTimescale: 600))

            case let .seek(time):
                self.isLoading = true
                self.player.seek(to: CMTime(seconds: time, preferredTimescale: 600)) { _ in
                    self.isLoading = false
                }
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
