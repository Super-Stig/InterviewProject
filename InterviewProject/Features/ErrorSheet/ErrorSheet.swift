//
//  URLErrorSheet.swift
//  InterviewProject
//
//  Created by Cameron Taylor on 8/1/24.
//

import Foundation
import SwiftUI

/// An extension on `View` to present a full-screen cover for handling URL errors.
extension View {
    /// Presents a full-screen cover when a URL error is bound.
    ///
    /// - Parameter item: A binding to an optional `URLError` that triggers the presentation.
    @ViewBuilder func urlErrorSheet(item: Binding<URLError?>) -> some View {
        self
            .fullScreenCover(item: item) { _ in
                ErrorSheet(networkError: item, internalError: .constant(nil))
            }
    }
    
    /// Presents a full-screen cover when an internal Decoding error is bound.
    ///
    /// - Parameter item: A binding to an optional `APIError` that triggers the presentation.
    @ViewBuilder func internalErrorSheet(item: Binding<APIError?>) -> some View {
        self
            .fullScreenCover(item: item) { _ in
                ErrorSheet(networkError: .constant(nil), internalError: item)
            }
    }
}

extension URLError: Identifiable {
    /// The identifier for `URLError`, based on its code.
    public var id: Self.Code { self.code }
}

/// A view that displays detailed information about the error.
struct ErrorSheet: View {
    @Binding var networkError: URLError?
    @Binding var internalError: APIError?
    
    var body: some View {
        VStack {
            header
            details
                .padding()
            Spacer()
            closeButton
        }
    }
    
    /// A header view displaying an colored bar.
    private var header: some View {
        Rectangle()
            .if(networkError != nil){ view in
                view
                    .foregroundStyle(Constants.networkHeaderColor)
            }
            .if(internalError != nil) { view in
                view
                    .foregroundStyle(Constants.internalHeaderColor)
            }
            .frame(height: Constants.headerHeight)
            .ignoresSafeArea()
    }
    
    /// A button to close the error sheet and dismiss the error.
    private var closeButton: some View {
        Button {
            networkError = nil
            internalError = nil
        } label: {
            ZStack {
                Capsule()
                Text(Constants.closeButtonText)
                    .bold()
                    .font(.title)
                    .foregroundStyle(.white)
            }
        }
        .frame(height: Constants.closeButtonHeight)
        .padding()
    }
    
    /// A view displaying detailed error information.
    private var details: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if networkError != nil {
                    Text(Constants.networkErrorFoundTitle)
                        .font(.largeTitle)
                        .bold()
                }
                
                if internalError != nil {
                    Text(Constants.internalErrorFoundTitle)
                        .font(.largeTitle)
                        .bold()
                }
                
                Text(Constants.errorCodeTitle + "\(networkError?.errorCode ?? 0)")
                    .font(.headline)
                
                Text(Constants.reasonTitle)
                    .padding(.top)
                    .font(.title)
                    .bold()
                
                Text(networkError?.localizedDescription ?? internalError?.localizedDescription ?? Constants.noDescriptionAvailable)
                
                Text(Constants.fullErrorTitle)
                    .padding(.top)
                    .font(.title2)
                    .bold()
                if let networkError {
                    Text(String(describing: networkError))
                }
                if let internalError {
                    Text(String(describing: internalError))
                }
            }
        }
    }
    
    /// Private constants used for styling and text.
    private struct Constants {
        static let networkHeaderColor: Color = .orange
        static let internalHeaderColor: Color = .red
        static let headerHeight: CGFloat = 65
        
        static let closeButtonText: String = "OK"
        static let closeButtonHeight: CGFloat = 75
        
        static let networkErrorFoundTitle: String = "Network Error Found"
        static let internalErrorFoundTitle: String = "Internal Error Found"
        static let errorCodeTitle: String = "Code: "
        static let reasonTitle: String = "Reason:"
        static let fullErrorTitle: String = "Full Error:"
        static let noDescriptionAvailable: String = "No description available."
    }
}

#Preview {
    ErrorSheet(networkError: .constant(.init(.timedOut)), internalError: .constant(nil))
}

