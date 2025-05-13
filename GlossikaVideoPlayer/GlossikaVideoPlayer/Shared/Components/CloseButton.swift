//
//  CloseButton.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/14.
//

import SwiftUI

// MARK: - CloseButton

struct CloseButton: View {
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 24))
                .padding()
        }
    }
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton(action: {} )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(.gray.opacity(0.1))
    }
}
