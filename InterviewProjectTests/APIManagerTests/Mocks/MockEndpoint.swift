//
//  MockEndpoint.swift
//  InterviewProjectTests
//
//  Created by Cameron Taylor on 8/1/24.
//

import Foundation
@testable import InterviewProject

enum MockEndpoint: Endpoint {
    case testGet([String])
    case testPost([String])
    case testPut([String])
    case testDelete([String])
    
    
    var baseURL: String {
        "https://theiosdude.api.com"
    }
    
    var path: String {
        "test"
    }
    
    var method: Method {
        return switch self {
        case .testGet:
                .GET
        case .testPost:
                .POST
        case .testPut:
                .PUT
        case .testDelete:
                .DELETE
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .testGet(let querys), .testPost(let querys), .testPut(let querys), .testDelete(let querys):
            if querys.isEmpty { return nil }
            return querys.map { URLQueryItem(name: "\(self.baseName)", value: $0) }
        }
    }
    
    static func buildFileData(for classType: AnyClass, with fileName: String) -> Data? {
        guard let url = Bundle(for: classType).url(forResource: fileName, withExtension: "json") else {
            return nil }
        return try? Data(contentsOf: url)
    }
    
    var baseName: String {
        return switch self {
        case .testGet:
            "TestGet"
        case .testPost:
            "TestPost"
        case .testPut:
            "TestPut"
        case .testDelete:
            "TestDelete"
        }
    }
}
