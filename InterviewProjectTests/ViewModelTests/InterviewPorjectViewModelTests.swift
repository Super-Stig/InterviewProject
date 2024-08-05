//
//  InterviewProjectViewModelTests.swift
//  InterviewProjectTests
//
//  Created by Cameron Taylor on 8/1/24.
//

import XCTest
@testable import InterviewProject

final class InterviewProjectViewModelTests: XCTestCase {
    
    var viewModel: InterviewProjectViewModel!
    var mockAPIManager: MockAPIManager!
    
    override func setUp() {
        mockAPIManager = MockAPIManager()
        viewModel = InterviewProjectViewModel(apiManager: mockAPIManager)
        super.setUp()
    }
    
    override func tearDown() {
        mockAPIManager = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_searchQueryUpdatesAndCallsAPI() async throws {
        // Arrange
        let expectedQuery = "test query"
        
        // Act
        viewModel.searchQuery = expectedQuery
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Assert
        guard let endpoint = mockAPIManager.attemptToGetData_endpointParameter as? FlickerAPI else {
            XCTFail("Did not receive FlickerAPI Endpoint")
            return
        }
        
        switch endpoint {
        case .imageSearch(let query):
            XCTAssertEqual(query, expectedQuery)
            XCTAssertEqual(mockAPIManager.attemptToGetData_calls, 1)
        }
    }
    
    func test_apiResponseOnSuccess() async throws {
        // Arrange
        mockAPIManager.mock_Data = MockEndpoint.buildFileData(for: type(of: self), with: "MockFlickerResponse")
        
        // Act
        viewModel.createRetreveDataTask()
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Assert
        XCTAssertNotNil(viewModel.apiResponse)
        XCTAssertEqual(viewModel.apiResponse?.title, "Recent Uploads tagged porcupine")
    }
    
    func test_errorResponseOnURLFailure() async throws {
        // Arrange
        let expectedError = URLError(.badURL)
        mockAPIManager.mock_error = expectedError
        
        // Act
        viewModel.searchQuery = "test query"
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Assert
        XCTAssertNil(viewModel.apiResponse)
        XCTAssertNil(viewModel.internalError)
        XCTAssertNotNil(viewModel.errorResponse)
        XCTAssertEqual(viewModel.errorResponse, expectedError)
    }
    
    func test_errorResponseOnEndpointFailure() async throws {
        // Arrange
        mockAPIManager.mock_error = APIError.decoding
        
        // Act
        viewModel.searchQuery = "test query"
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Assert
        XCTAssertNil(viewModel.apiResponse)
        XCTAssertNotNil(viewModel.internalError)
        XCTAssertNil(viewModel.errorResponse)
    }
    
    func test_searchTaskIsCancelled() async throws {
        // Arrange
        let firstQuery = "first query"
        let secondQuery = "second query"
        
        // Act
        viewModel.searchQuery = firstQuery
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        viewModel.searchQuery = secondQuery
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Assert
        guard let endpoint = mockAPIManager.attemptToGetData_endpointParameter as? FlickerAPI else {
            XCTFail("Did not receive FlickerAPI Endpoint")
            return
        }
        
        switch endpoint {
        case .imageSearch(let query):
            XCTAssertEqual(query, secondQuery)
            XCTAssertEqual(mockAPIManager.attemptToGetData_calls, 2)
        }
    }
    
    func test_clearSearchResults() async throws {
        // Arrange
        let firstQuery = "first query"
        mockAPIManager.mock_Data = MockEndpoint.buildFileData(for: type(of: self), with: "MockFlickerResponse")
        viewModel.searchQuery = firstQuery
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Act
        viewModel.clearResults()
        
        // Assert
        XCTAssertNil(viewModel.apiResponse)
        XCTAssertTrue(viewModel.searchQuery.isEmpty)
    }
}
