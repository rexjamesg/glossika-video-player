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
        VStack(alignment: .leading, spacing: 20) {
            // 1. 頂部圖片
            KFImage(item.source.fullImageURL)
                .placeholder {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                        ProgressView()
                    }
                }
                .resizable()
                .scaledToFill()
                .frame(height: 180) // 固定高度
                .clipped() // 剪裁超出部分
                .cornerRadius(8) // 圓角

            // 2. 標題
            Text(item.source.title)
                .font(.headline)
                .lineLimit(2)

            // 3. 說明文字
            Text(item.source.description)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - VideoListCell_Previews

struct VideoListCell_Previews: PreviewProvider {
    static var previews: some View {
        VideoListCell(item: VideoItem.mock)
            .previewLayout(/*@START_MENU_TOKEN@*/ .sizeThatFits/*@END_MENU_TOKEN@*/)
    }
}
