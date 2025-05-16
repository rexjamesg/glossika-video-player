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

    // MARK: - Private Properties
    @State private var selectedItem: VideoItem?
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.videoItems, id: \.id) { item in
                    Button {
                        viewModel.selectItem.send(item)
                    } label: {
                        VideoListCell(item: item)
                    }
                    .padding(.vertical, 8)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(.white)
        }
        .onAppear {
            //列表僅允許直式
            AppDelegate.shared.orientationLock = .portrait
        }
        .onDisappear {
            AppDelegate.shared.orientationLock = .all
        }
        .fullScreenCover(item: $viewModel.selectedItem) { video in
            //依照選擇的影片彈出播放器界面
            makePlayerContainerView(item: video)
        }
        .onReceive(viewModel.errorMessage) { msg in
            //錯誤Toast入口
            withAnimation(.easeInOut(duration: 0.5)) {
                toastMessage = msg
                showToast = true
            }
        }
        .bottomToast(isPresented: $showToast, message: toastMessage, type: .error)
    }
}

// MARK: - Private Methods

private extension VideoListView {
    func makePlayerContainerView(item: VideoItem) -> some View {
        let viewModel = PlayerContainerViewModel()
        viewModel.loadVideo.send(item)
        return PlayerContainerView(viewModel: viewModel)
    }
}

// MARK: - VideoListView_Previews

struct VideoListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView(viewModel: VideoListViewModel())
    }
}
