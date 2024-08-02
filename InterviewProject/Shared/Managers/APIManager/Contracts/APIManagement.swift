//
//  APIManagement.swift
//  InterviewProject
//
//  Created by Cameron Taylor on 8/1/24.
//

import Foundation

/// A protocol defining the API management interface for creating requests and fetching data.
protocol APIManagement {
    /// Attempts to create a URL request from the given endpoint.
    ///
    /// - Parameter endpoint: The endpoint to create a request from.
    /// - Throws: An error if the request cannot be created.
    /// - Returns: A URLRequest for the given endpoint.
    func attemptToCreateRequest<E: Endpoint>(from endpoint: E) throws -> URLRequest
    
    /// Attempts to retrieve data from the given endpoint.
    ///
    /// - Parameter endpoint: The endpoint to retrieve data from.
    /// - Throws: An error if the data cannot be retrieved or decoded.
    /// - Returns: A decoded object of type `D` from the data.
    func attemptToGetData<D: Decodable, E: Endpoint>(from endpoint: E) async throws -> D
}

