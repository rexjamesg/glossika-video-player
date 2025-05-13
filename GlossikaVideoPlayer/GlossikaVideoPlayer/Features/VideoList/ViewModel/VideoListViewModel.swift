//
//  VideoListViewModel.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/13.
//

import Foundation

class VideoListViewModel: ObservableObject {
    @Published private(set) var videoItems = [VideoItem]()
    
    init() {
        videoItems = VideoSource.allCases.map { VideoItem(source: $0) }
    }
}
