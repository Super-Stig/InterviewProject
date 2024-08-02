//
//  MockAPIManager.swift
//  InterviewProjectTests
//
//  Created by Cameron Taylor on 8/1/24.
//

import Foundation
@testable import InterviewProject

/// A mock implementation of `APIManagement` for testing purposes.
class MockAPIManager: APIManagement {
    /// An optional error to simulate API errors.
    var mock_error: Error?
    
    /// An optional data object to simulate API responses.
    var mock_Data: Data?
    
    /// A count of how many times `attemptToCreateRequest` has been called.
    var attemptToCreateRequest_calls: Int = 0
    
    /// The endpoint parameter passed to the last `attemptToCreateRequest` call.
    var attemptToCreateRequest_endpointParameter: Endpoint?
    
    /// A count of how many times `attemptToGetData` has been called.
    var attemptToGetData_calls: Int = 0
    
    /// The endpoint parameter passed to the last `attemptToGetData` call.
    var attemptToGetData_endpointParameter: Endpoint?
    
    /// Attempts to create a request from the given endpoint.
    /// - Parameter endpoint: The endpoint to create a request from.
    /// - Throws: An error if `mock_error` is set or if the URL is invalid.
    /// - Returns: A URLRequest for the given endpoint.
    func attemptToCreateRequest<E>(from endpoint: E) throws -> URLRequest where E : Endpoint {
        attemptToCreateRequest_calls += 1
        attemptToCreateRequest_endpointParameter = endpoint
        if let error = mock_error {
            throw error
        }
        
        guard let url = URL(string: endpoint.baseURL) else {
            throw APIError.invalidPath
        }
        return URLRequest(url: url)
    }
    
    /// Attempts to retrieve data from the given endpoint.
    /// - Parameter endpoint: The endpoint to retrieve data from.
    /// - Throws: An error if `mock_error` is set or if decoding fails.
    /// - Returns: A decoded object of type `D` from the data.
    func attemptToGetData<D, E>(from endpoint: E) async throws -> D where D : Decodable, E : Endpoint {
        attemptToGetData_calls += 1
        attemptToGetData_endpointParameter = endpoint
        if let error = mock_error {
            throw error
        }
        
        let jsonDecoder = JSONDecoder()
        guard let data = mock_Data else {
            throw APIError.decoding
        }
        return try jsonDecoder.decode(D.self, from: data)
    }
}

