//
//  VideoListCell.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/13.
//

import Kingfisher
import SwiftUI

// MARK: - VideoListCell

struct VideoListCell: View {
    let item: VideoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            if let url = item.source.fullImageURL {
                KFImage(url)
                    .placeholder {
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .aspectRatio(16 / 9, contentMode: .fit)
                            ProgressView()
                        }
                    }
                    .resizable()
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .cornerRadius(10)
            }

            Text(item.source.title)
                .font(.title3)
                .fontWeight(.bold)

            Text(item.source.description)
                .font(.body)
                .foregroundColor(.secondary)
        })
        .padding(.vertical, 8)
    }
}

// MARK: - VideoListCell_Previews

struct VideoListCell_Previews: PreviewProvider {
    static var previews: some View {
        VideoListCell(item: VideoItem.mock)
            .previewLayout(/*@START_MENU_TOKEN@*/ .sizeThatFits/*@END_MENU_TOKEN@*/)
            .background(.gray.opacity(0.1))
    }
}
