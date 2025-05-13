//
//  VideoListView.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/13.
//

import SwiftUI

struct VideoListView: View {
    @ObservedObject var viewModel = VideoListViewModel()

    //MARK: - Private Properties
    @State private var selectedItem:VideoItem?
    
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
            //Direct to player
        }
    }
}

struct VideoListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView(viewModel: VideoListViewModel())
    }
}
