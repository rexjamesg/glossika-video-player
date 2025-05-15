//
//  VideoListView.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/13.
//

import SwiftUI

// MARK: - VideoListView

struct VideoListView: View {
    @ObservedObject var viewModel = VideoListViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    // MARK: - Private Properties

    @State private var selectedItem: VideoItem?
    @State private var showToast = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.videoItems, id: \.id) { item in
                    Button {
                        if item.source.url != nil {
                            selectedItem = item
                        } else {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showToast = true
                            }
                        }
                    } label: {
                        VideoListCell(item: item)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .onAppear {
            AppDelegate.shared.orientationLock = .portrait            
        }
        .onDisappear {
            AppDelegate.shared.orientationLock = .all
        }
        .fullScreenCover(item: $selectedItem) { video in
            if let url = video.source.url {
                makePlayerContainer(for: url)
            }
        }
        .bottomToast(isPresented: $showToast, message: "無效的影片網址", type: .error)
    }
}

// MARK: - Private Methods

private extension VideoListView {
    func makePlayerContainer(for url: URL) -> PlayerContainerView {
        let vm = PlayerContainerViewModel()
        vm.load(url: url)
        return PlayerContainerView(viewModel: vm)
    }
}

// MARK: - VideoListView_Previews

struct VideoListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView(viewModel: VideoListViewModel())
    }
}
