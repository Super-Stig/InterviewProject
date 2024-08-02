//
//  SearchImagesScreen.swift
//  InterviewProject
//
//  Created by Cameron Taylor on 7/31/24.
//

import Foundation
import SwiftUI

/// A view that displays a searchable grid of images.
struct SearchImagesScreen: View {
    
    //MARK: View Model
    @State private var viewModel: InterviewProjectViewModel = .init()
    
    //MARK: Main Body
    var body: some View {
        NavigationStack {
            imageStackView
                .toolbar {
                    Button{
                        viewModel.clearResults()
                    } label: {
                        Image(systemName: Constants.systmeImg)
                            .bold()
                    }
                }
        }
        .searchable(text: $viewModel.searchQuery)
        .urlErrorSheet(item: $viewModel.errorResponse)
        .internalErrorSheet(item: $viewModel.internalError)
    }
    
    /// A view that displays a grid of images based on the search query.
    var imageStackView: some View {
        ScrollView {
            LazyVGrid(columns: Constants.columns, spacing: .zero) {
                if let response = viewModel.apiResponse {
                    ForEach(response.items) { item in
                        NavigationLink(destination: FlickerItemDetailsView(item: item)) {
                            FlickerImageLinkView(item)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: Constants
    /// Constants used for styling the grid.
    private struct Constants {
        static let columns = [GridItem(.adaptive(minimum: 85))]
        static let systmeImg = "rectangle.on.rectangle.slash"
    }
}

//MARK: Preview
#Preview {
    SearchImagesScreen()
}

