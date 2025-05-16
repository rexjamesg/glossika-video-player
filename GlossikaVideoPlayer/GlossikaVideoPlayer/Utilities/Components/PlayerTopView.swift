//
//  PlayerTopView.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/14.
//

import SwiftUI

// MARK: - CloseButton

struct PlayerTopView: View {
        
    let title: String
    let action: () -> Void
    let color: Color

    var body: some View {
        ZStack {
            Text(title)
                .foregroundColor(.white)
                .font(.headline)
            
            HStack {
                Button(action: action) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(color)
                }
                Spacer()
            }
        }
        // 3️⃣ 讓整個區塊撐滿寬度
        .frame(maxWidth: .infinity)
        // 4️⃣ 設定左右相同 padding（也就是左右間距）
        .padding(.horizontal, 16)
    }
}

// MARK: - CloseButton_Previews

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayerTopView(title: "Test", action: {}, color: .white)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(.gray.opacity(0.1))
    }
}
