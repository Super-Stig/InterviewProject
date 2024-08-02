//
//  Endpoint.swift
//  InterviewProject
//
//  Created by Cameron Taylor on 8/1/24.
//

import Foundation

/// A protocol representing the properties and requirements for an API endpoint.
protocol Endpoint {
    /// The base URL of the API endpoint.
    var baseURL: String { get }
    
    /// The path of the API endpoint.
    var path: String { get }
    
    /// The HTTP method used for the API endpoint.
    var method: Method { get }
    
    /// The URL query parameters for the API endpoint.
    var parameters: [URLQueryItem]? { get }
}

