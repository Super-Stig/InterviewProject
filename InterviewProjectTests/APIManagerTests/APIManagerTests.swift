//
//  APIManagerTests.swift
//  InterviewProjectTests
//
//  Created by Cameron Taylor on 8/2/24.
//

import XCTest

final class APIManagerTests: XCTestCase {
    
    var classToTest: APIManager!
    
    override func setUp() {
        super.setUp()
        classToTest = APIManager(urlSession: mockSession)
    }
    
    override func tearDown() {
        classToTest = nil
        MockURLSession.error = nil
        MockURLSession.requestHandler = nil
        super.tearDown()
    }
    
    private var mockSession: URLSession {
        let config: URLSessionConfiguration = .ephemeral
        config.protocolClasses = [MockURLSession.self]
        return URLSession(configuration: config)
    }
    
    func test_apiCall_successfulResponse() async throws {
        let endpoint = MockEndpoint.testGet([])
        
        successfulResponse(at: endpoint)
        let things: [MockModelPerson] = try await classToTest.attemptToGetData(from: endpoint)
        XCTAssertNotNil(things)
        XCTAssertEqual(things.count, 2)
        XCTAssertEqual(things.first?.firstName, "Lee")
    }
    
    func test_apiCall_failedResponse() async throws {
        let endpoint = MockEndpoint.testGet([])
        
        failedResponse(at: endpoint, with: URLError(.badURL))
        do {
            let things: [MockModelPerson] = try await classToTest.attemptToGetData(from: endpoint)
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .badURL)
        }
    }
    
    func test_buildRequest() throws {
        let endpoint = MockEndpoint.testGet([])
        let expectedRequest = URLRequest(url: buildURL(from: endpoint)!)
        let testedRequest = try classToTest.attemptToCreateRequest(from: endpoint)
        
        XCTAssertEqual(testedRequest.url, expectedRequest.url)
        XCTAssertEqual(testedRequest.httpMethod, expectedRequest.httpMethod)
    }
    
    func test_buildURL() throws {
        let endpoint = MockEndpoint.testGet(["value"])
        let expectedUrl = buildURL(from: endpoint)
        let testedURL = try classToTest.attemptToCreateRequest(from: endpoint).url
        
        XCTAssertNotNil(testedURL)
        XCTAssertEqual(expectedUrl?.absoluteString, testedURL?.absoluteString)
    }
    
    // MARK: - Helper Methods
    
    private func successfulResponse<E: Endpoint>(at endpoint: E) {
        let url = buildURL(from: endpoint)!
        let data = buildData()
        MockURLSession.requestHandler = { request in
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"])!
            return (response, data)
        }
    }
    
    private func failedResponse<E: Endpoint>(at endpoint: E, with error: URLError = URLError(.badURL)) {
        let url = buildURL(from: endpoint)!
        MockURLSession.error = error
        MockURLSession.requestHandler = { request in
            let response = HTTPURLResponse(
                url: url,
                statusCode: error.errorCode,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"])!
            return (response, Data())
        }
    }
    
    private func buildURL<E: Endpoint>(from endpoint: E) -> URL? {
        var urlComponents = URLComponents(string: endpoint.baseURL.appending(endpoint.path))
        urlComponents?.queryItems = endpoint.parameters
        return urlComponents?.url
    }
    
    private func buildData() -> Data {
        let response =
        """
        [
            {
                "first_name": "Lee",
                "last_name": "Burrows"
            },
            {
                "first_name": "Dolly",
                "last_name": "Burrows"
            }
        ]
        """
        return response.data(using: .utf8)!
    }
}

