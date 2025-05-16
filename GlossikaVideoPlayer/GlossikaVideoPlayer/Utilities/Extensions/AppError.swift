//
//  AppError.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/16.
//

import Foundation

// MARK: - AppError

enum AppError: Error {
    case network(NetworkError)
    case api(APIError)
    case local(LocalError)
    case unknowError
}

// MARK: - AppError + LocalizedError

extension AppError: LocalizedError {
    var description: String {
        switch self {
        case let .network(networkError):
            return networkError.description
        case let .api(apiError):
            return apiError.description
        case let .local(localError):
            return localError.description
        case .unknowError:
            return "未知的錯誤"
        }
    }
}

// MARK: - NetworkError

enum NetworkError {
    case unreachable
    case unableToDecode(type: String)
    case timeout
    case httpStatus(code: Int)
    case unknownError
}

extension NetworkError {
    var description: String {
        switch self {
        case .unreachable:
            return "Network is unreachable. Please check your connection."
        case let .unableToDecode(type):
            return "Unable to decode response into type '\(type)'."
        case .timeout:
            return "The request timed out. Please try again."
        case let .httpStatus(code):
            return "HTTP Error \(code)."
        case .unknownError:
            return "UnknownError"
        }
    }
}

// MARK: - APIError

enum APIError {
    case message(String)
}

extension APIError {
    var description: String {
        switch self {
        case let .message(string):
            return string
        }
    }
}

// MARK: - LocalError

enum LocalError {
    case noSelf
    case invalidURL
}

extension LocalError {
    var description: String {
        switch self {
        case .noSelf:
            return ""
        case .invalidURL:
            return "影片連結錯誤"
        }
    }
}
