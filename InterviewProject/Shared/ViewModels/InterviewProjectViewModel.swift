//
//  InterviewProjectViewModel.swift
//  InterviewProject
//
//  Created by Cameron Taylor on 7/31/24.
//

import Foundation

@Observable class InterviewProjectViewModel {
    
    // MARK: Dependencies
    var apiManager: APIManagement
    
    // MARK: Viewed Data
    var apiResponse: FlickrResponse?
    var searchQuery: String = "" {
        didSet {
            if searchQuery.isEmpty { return }
            attemptToRetrieveData()
        }
    }
    var searchTask: Task<Void, Error>?
    var errorResponse: URLError?
    var internalError: APIError?
    
    // MARK: Initializer
    
    /// Initializes the view model with a given API manager.
    ///
    /// - Parameter apiManager: The API manager to be used for network requests. Defaults to a new instance of `APIManager`.
    init(apiManager: APIManagement = APIManager()) {
        self.apiManager = apiManager
    }
    
    // MARK: Methods
    
    /// Attempts to retrieve data from the API based on the current search query.
    func attemptToRetrieveData() {
        searchTask?.cancel()
        searchTask = Task {
            do {
                apiResponse = try await apiManager.attemptToGetData(from: FlickerAPI.imageSearch(searchQuery))
            } catch URLError.cancelled {
                // No action needed for a cancelled request
            } catch {
                errorResponse = error as? URLError
                internalError = error as? APIError
            }
            searchTask = nil
        }
    }
    
    /// cleans up the search query and sets the apiResponse to nil
    func clearResults() {
        searchQuery = ""
        apiResponse = nil
    }
}

