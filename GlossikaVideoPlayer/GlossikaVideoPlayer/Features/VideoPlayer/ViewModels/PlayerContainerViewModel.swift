//
//  PlayerContainerViewModel.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/13.
//

import AVFoundation
import Combine
import Foundation


extension PlayerContainerViewModel {
    static let mock = PlayerContainerViewModel(url: URL(string: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_2MB.mp4")!)
}

// MARK: - PlayerContainerViewModel

class PlayerContainerViewModel: ObservableObject {
    // MARK: - Public Properties

    var player: AVPlayer { playerService.player }

    // MARK: - Input
    
    var playTapped: PassthroughSubject<Void, Never> {
        playerService.playTapped
    }

    var pauseTapped: PassthroughSubject<Void, Never> {
        playerService.pauseTapped
    }

    var fastForwardTapped: PassthroughSubject<Void, Never> {
        playerService.fastForwardTapped
    }

    var rewindTapped: PassthroughSubject<Void, Never> {
        playerService.rewindTapped
    }

    var playPauseTapped: PassthroughSubject<Void, Never> {
        playerService.playPauseTapped
    }

    var seekToTime: PassthroughSubject<Double, Never> {
        playerService.seekToTime
    }

    // MARK: - Output

    @Published var bufferProgress: Double = 0
    @Published var isPlaying: Bool = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 1
    @Published var isReadyToPlay = false

    // MARK: - Private Properties

    private let playerService: PlayerService
    private var cancellables = Set<AnyCancellable>()

    init(url: URL) {
        playerService = PlayerService(url: url)

        playerService.$isPlaying
            .receive(on: RunLoop.main)
            .assign(to: &$isPlaying)

        playerService.$currentTime
            .receive(on: RunLoop.main)
            .assign(to: &$currentTime)

        playerService.$duration
            .receive(on: RunLoop.main)
            .assign(to: &$duration)

        playerService.$bufferProgress
            .receive(on: RunLoop.main)
            .assign(to: &$bufferProgress)
        
        playerService.$isReadyToPlay
            .receive(on: RunLoop.main)
            .assign(to: &$isReadyToPlay)
    }
}

// MARK: - Bind

private extension PlayerContainerViewModel {
    func bind() {
        playTapped.sink { [weak self] in
            guard let self = self else { return }
            self.playerService.playTapped.send()
        }.store(in: &cancellables)
        
        pauseTapped.sink { [weak self] in
            guard let self = self else { return }
            self.playerService.pauseTapped.send()
        }.store(in: &cancellables)
        
        playPauseTapped.sink { [weak self] in
            guard let self = self else { return }
            self.playerService.playTapped.send()
        }.store(in: &cancellables)
        
        fastForwardTapped.sink { [weak self] in
            guard let self = self else { return }
            self.playerService.fastForwardTapped.send()
        }.store(in: &cancellables)
        
        rewindTapped.sink { [weak self] in
            guard let self = self else { return }
            self.playerService.rewindTapped.send()
        }.store(in: &cancellables)
    }
}

// MARK: - Private Methods

private extension PlayerContainerViewModel {}
