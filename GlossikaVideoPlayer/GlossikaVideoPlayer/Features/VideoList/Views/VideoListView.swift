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

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.videoItems, id: \.id) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        VideoListCell(item: item)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .fullScreenCover(item: $selectedItem) { video in            
            if let url = video.source.url {
                PlayerContainerView(url: url)
            } else {
                ZStack(alignment: .topLeading, content: {
                    Color.white.ignoresSafeArea()

                    CloseButton(action: { selectedItem = nil })
                    .padding(.top, 24)
                    .padding(.leading, 24)
                    .foregroundColor(.blue)
                    
                    VStack(spacing: 16) {
                        Spacer()
                        Text("無效的影片網址")
                            .font(.title2)
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                })
            }
        }
    }
}

// MARK: - VideoListView_Previews

struct VideoListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView(viewModel: VideoListViewModel())
    }
}
