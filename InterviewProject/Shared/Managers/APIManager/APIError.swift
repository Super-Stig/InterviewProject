//
//  APIError.swift
//  InterviewProject
//
//  Created by Cameron Taylor on 7/31/24.
//

import Foundation

/// An enumeration representing errors that can occur when interacting with the API.
///
/// - invalidPath: Indicates that the provided path is invalid.
/// - decoding: Indicates that there was an error decoding the response.
enum APIError: Error, Identifiable {
    case invalidPath
    case decoding
    
    var id: Self { self }
    
    /// A localized description of the API error.
    var localizedDescription: String {
        switch self {
        case .invalidPath:
            return "Invalid Path"
        case .decoding:
            return "There was an error decoding the type"
        }
    }
}
