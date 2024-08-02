//
//  APIEndpoint.swift
//  InterviewProject
//
//  Created by Cameron Taylor on 7/31/24.
//

import Foundation

/// Enum representing different API endpoints.
///
/// - today: Endpoint for today's data.
/// - tomorrow: Endpoint for tomorrow's data.
enum FlickerAPI {
    case imageSearch(String)
}

/// Extension to provide additional properties for `APIEndpoint`.
extension FlickerAPI: Endpoint {
    
    /// the Base URL for the API we wish to access
    var baseURL: String {
        "https://api.flickr.com"
    }
    
    /// The path for each endpoint.
    var path: String {
        return switch self {
        case.imageSearch:
            "/services/feeds/photos_public.gne"
        }
    }
    
    /// The HTTP method for the endpoint. Defaults to GET.
    var method: Method {
        return .GET
    }
    
    /// The query parameters for the endpoint (if any). Currently not implemented.
    var parameters: [URLQueryItem]? {
        return switch self {
        case let .imageSearch(query):
            [URLQueryItem(name: "format", value: "json"),
              URLQueryItem(name: "nojsoncallback", value: "1"),
              URLQueryItem(name: "tags", value: query)]
        }
    }
}
