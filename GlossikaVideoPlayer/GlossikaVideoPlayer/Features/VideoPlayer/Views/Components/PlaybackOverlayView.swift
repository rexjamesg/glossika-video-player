//
//  PlaybackOverlayView.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/14.
//

import SwiftUI

// MARK: - PlaybackOverlayView

struct PlaybackOverlayView: View {
    @ObservedObject var viewModel: PlayerContainerViewModel

    var body: some View {
        GeometryReader { geometry in
            // 先算出當前是不是橫屏
            let isLandscape = geometry.size.width > geometry.size.height
            // 動態底部間距：安全區 + 16 (直式) 或安全區 + 32 (橫式)
            let bottomPadding = geometry.safeAreaInsets.bottom + (isLandscape ? 32 : 16)
            VStack {
                setTimeAndFullScreenButton()
                setBufferAndSliderView(geometry: geometry)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.leading, geometry.safeAreaInsets.leading + 24)
            .padding(.trailing, geometry.safeAreaInsets.trailing + 24)
            .padding(.bottom, bottomPadding)
        }
        .ignoresSafeArea() // 讓 safeAreaInsets 可以正確取值
    }
}

// MARK: - Private Methods

private extension PlaybackOverlayView {
    func setTimeAndFullScreenButton() -> some View {
        HStack {
            Text("\(timeString(viewModel.currentTime)) / \(timeString(viewModel.duration))")
                .font(.caption)
                .foregroundColor(.white)
            Spacer()
            Button {
                viewModel.toggleFullScreenTapped.send()
            } label: {
                Image(systemName: viewModel.isFullScreen
                    ? "arrow.down.right.and.arrow.up.left" // 退出全螢幕 icon
                    : "arrow.up.left.and.arrow.down.right") // 進入全螢幕 icon
                    .font(.title3)
            }
            .foregroundColor(.white)
        }.padding(.horizontal)
    }

    func setBufferAndSliderView(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .leading) {
            // 進度條基底
            Capsule()
                .fill(.gray.opacity(0.3))
                .frame(height: 4)
            // 目前buffer進度
            Capsule()
                .fill(.gray.opacity(0.6))
                .frame(width: CGFloat(geometry.size.width) * viewModel.bufferProgress,
                       height: 4)

            if viewModel.isReadyToPlay {
                PlayerSlider(viewModel: viewModel)
            }
        }
    }

    // 方便顯示時間 01:23 / 04:05
    func timeString(_ seconds: Double) -> String {
        guard seconds.isFinite else {
            return "00:00" // 返回預設值
        }
        let time = Int(seconds)
        return String(format: "%02d:%02d", time / 60, time % 60)
    }
}

// MARK: - PlaybackOverlayView_Previews

struct PlaybackOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackOverlayView(viewModel: PlayerContainerViewModel.mock)
            .previewLayout(.sizeThatFits)
            .aspectRatio(16 / 9, contentMode: .fit)
            .background(.gray)
    }
}
