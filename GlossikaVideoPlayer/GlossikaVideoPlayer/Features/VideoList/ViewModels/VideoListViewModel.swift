//
//  VideoListViewModel.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/13.
//

import Foundation
import Combine

class VideoListViewModel: ObservableObject {
    
    //MARK: - Public Properties
    // MARK: - Input
    let selectItem = PassthroughSubject<VideoItem, Never>()
    
    // MARK: - Output
    let errorMessage = PassthroughSubject<String, Never>()
    @Published var selectedItem: VideoItem?
    @Published private(set) var videoItems = [VideoItem]()
    
    //MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        videoItems = VideoSource.allCases.map { VideoItem(source: $0) }
        bind()
    }
}

//MARK: - Bind
private extension VideoListViewModel {
    func bind() {
        // 處理影片：如果有 URL 回傳提供播放器播放，否則發出錯誤訊息。
        selectItem.flatMap { item -> AnyPublisher<Result<VideoItem, AppError>, Never> in
            if item.source.url != nil {
                return Just(.success(item)).eraseToAnyPublisher()
            } else {
                return Just(.failure(.local(.invalidURL))).eraseToAnyPublisher()
            }
        }.sink { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let item):
                self.selectedItem = item
            case .failure(let error):
                self.errorMessage.send(error.description)
            }
        }.store(in: &cancellables)
    }
}
