//
//  APIManager.swift
//  InterviewProject
//
//  Created by Cameron Taylor on 7/31/24.
//

import Foundation

/// typealias for network response containing data and URLResponse
typealias NetworkResponse = (data: Data, response: URLResponse)

/// A class dedicated for API Managment
class APIManager: APIManagement {
    
    //MARK: Dependencies
    var urlSession: URLSession
    
    //MARK: Custom Init
    /// The Main Init for APIManager
    /// - Parameter urlSession: A configured urlSession for networking defalut is URLSession.shared
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /// Creates a URLRequest from the given APIEndpoint
    ///
    /// - Parameter endpoint: The APIEndpoint for which to create the request
    /// - Returns: A URLRequest object
    /// - Throws: An error of type ApiError if the path is invalid
    func attemptToCreateRequest<E:Endpoint>(from endpoint: E) throws -> URLRequest {
        guard
            let urlPath = URL(string: endpoint.baseURL.appending(endpoint.path)),
            var urlComponents = URLComponents(string: endpoint.baseURL.appending(endpoint.path))
        else {
            throw APIError.invalidPath
        }
        
        // Adds Parameters if avalible
        if let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters
        }
        
        // Builds Request
        var request = URLRequest(url: urlComponents.url ?? urlPath)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    /// Performs a network request and decodes the response data into the specified type
    ///
    /// - Parameters:
    ///   - endpoint: The APIEndpoint defining the request details
    /// - Returns: An instance of type D representing the decoded response data
    /// - Throws: An error if the request fails or if the response data cannot be decoded
    func attemptToGetData<D: Decodable, E: Endpoint>(from endpoint: E) async throws -> D {
        let decoder = JSONDecoder()
        let request = try attemptToCreateRequest(from: endpoint)
        let response: NetworkResponse = try await urlSession.data(for: request)
        return try decoder.decode(D.self, from: response.data)
    }
}
