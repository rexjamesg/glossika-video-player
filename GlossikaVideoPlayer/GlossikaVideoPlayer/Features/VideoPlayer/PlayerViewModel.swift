//
//  PlayerViewModel.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/13.
//

import AVFoundation
import Combine
import Foundation

// MARK: - PlayerViewModel

class PlayerViewModel: ObservableObject {
    // MARK: - Public Properties

    // MARK: - Input

    let player: AVPlayer
    let playPauseTapped = PassthroughSubject<Void, Never>()
    let rewindTapped = PassthroughSubject<Void, Never>()
    let fastForwardTapped = PassthroughSubject<Void, Never>()
    let seekToTime = PassthroughSubject<Double, Never>()

    // MARK: - Output

    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 1
    @Published var bufferProgress: Double = 0

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private var timeObserver: Any?

    init(url: URL) {
        player = AVPlayer(url: url)
        bind()
        observerTime()
        
    }

    deinit {
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }
}

// MARK: - Bind

private extension PlayerViewModel {
    func bind() {
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
                
            }.store(in: &cancellables)
        
        fastForwardTapped
            .sink { [weak self] in
                guard let self = self else { return }
                
            }.store(in: &cancellables)
        
        //跳轉播放時間
        seekToTime
            .sink { [weak self] time in
                guard let self = self else { return }
                //時間基準（1 秒 = 600 單位）
                self.player.seek(to: CMTime(seconds: time, preferredTimescale: 600))
            }.store(in: &cancellables)
        
        
    }
}

//MARK: - Private Methods
private extension PlayerViewModel {
    func observerTime() {
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main, using: { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
            self.duration = self.player.currentItem?.duration.seconds ?? 1
        })
    }
    
    func observerBuffer() {
        player.currentItem?.publisher(for: \.loadedTimeRanges)
            .sink(receiveValue: { [weak self] ranges in
                guard let self = self else { return }
                if let timeRanges = ranges.first?.timeRangeValue {
                    let bufferedTime = CMTimeGetSeconds(timeRanges.start)+CMTimeGetSeconds(timeRanges.duration)
                    let time = self.duration > 0 ? self.duration:1
                    self.bufferProgress = bufferedTime/time
                }
            }).store(in: &cancellables)
    }
}
