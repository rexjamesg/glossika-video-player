//
//  BottomToastView.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/14.
//

import SwiftUI

enum ToastType {
    case success
    case error
    case info
    
    var backgroundColor: Color {
        switch self {
        case .success:
            return .green.opacity(0.85)
        case .error:
            return .red.opacity(0.85)
        case .info:
            return .black.opacity(0.85)
        }
    }
}

struct BottomToastView: View {
    let message: String
    let type: ToastType
    
    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(type.backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(10.0)
                .padding(.bottom, 24)
        }
        .transition(.toastSlide)
    }
}

struct BottomToastView_Previews: PreviewProvider {
    static var previews: some View {
        BottomToastView(message: "Test Message", type: .info)
    }
}
