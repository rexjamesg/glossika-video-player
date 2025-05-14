//
//  PlayerBufferView.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/14.
//

import SwiftUI

// MARK: - PlayerBufferView

struct PlayerBufferView: View {
    @ObservedObject var viewModel: PlayerContainerViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                setTimeAndFullScreenButton()
                setBufferAndSliderView(geometry: geometry)
            }.frame(maxHeight: .infinity, alignment: .bottom)
        }
    }

    // 方便顯示時間 01:23 / 04:05
    private func timeString(_ seconds: Double) -> String {
        guard seconds.isFinite else {
                return "00:00"  // 返回預設值
            }
        let time = Int(seconds)
        return String(format: "%02d:%02d", time / 60, time % 60)
    }
}

//MARK: - Private Methods
private extension PlayerBufferView {
    func setTimeAndFullScreenButton() -> some View {
        HStack() {
            Text("\(timeString(viewModel.currentTime)) / \(timeString(viewModel.duration))")
                .font(.caption)
                .foregroundColor(.white)
            Spacer()
            Button {
                // 全螢幕切換動作
            } label: {
                Image(systemName: "arrow.up.left.and.arrow.down.right") // 建議 icon
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
}

struct PlayerBufferView_Previews: PreviewProvider {
    static var previews: some View {
                
        PlayerBufferView(viewModel: PlayerContainerViewModel.mock)
            .previewLayout(.sizeThatFits)
            .aspectRatio(16 / 9, contentMode: .fit)
            .background(.gray)
    }
}

