//
//  VideoItem.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/13.
//

import Foundation

struct VideoItem: Identifiable {
    let id = UUID()
    let source:VideoSource
}

extension VideoItem {
    static let mock = VideoItem(source: .bigBuckBunny)
}
