//
//  ItemDetailsView.swift
//  InterviewProject
//
//  Created by Cameron Taylor on 8/1/24.
//

import Foundation
import SwiftUI

/// A view displaying details of a Flickr item.
struct FlickerItemDetailsView: View {
    //MARK: Parameters
    var item: Item
    
    //MARK: Main Body
    var body: some View {
        ScrollView {
            ZStack {
                VStack(spacing: .zero) {
                    displayImage
                    itemDetails
                    Spacer()
                }
            }
        }
    }
    
    //MARK: Subviews
    /// Displays the image with a background and overlay text showing the image size.
    var displayImage: some View {
        GeometryReader { geoProxy in
            ZStack {
                Color.black
                FlickerImageLinkView(
                    item,
                    imgSize: CGSize(width: geoProxy.size.width, height: Constants.imageHeight),
                    scaleEffect: .fit
                )
            }
            .fixedSize()
        }
        .frame(height: Constants.imageHeight)
        .overlay {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(item.media.getImageSize())
                        .padding(Constants.materialPadding)
                        .background(.thickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.materialCornerRadius))
                        .padding(Constants.heightWidthTextPadding)
                }
            }
        }
    }
    
    /// Displays the item details including title, author, dates, and description.
    var itemDetails: some View {
        VStack(alignment: .leading) {
            titleDetails
                .padding(.top)
            Group {
                Text(item.author)
                    .font(.headline)
                detail(title: Constants.dateTakenTitle, info: item.dateTaken)
                    .padding(.top)
                detail(title: Constants.datePublishedTitle, info: item.published)
            }
            .padding(.horizontal)
        }
    }
    
    // for the user to scroll to see the whole title
    var titleDetails: some View {
        ScrollView(.horizontal) {
            Text(item.title)
                .font(.largeTitle)
                .bold()
                .lineLimit(Constants.titleLineLimit)
                .padding(.horizontal)
        }
    }
    
    /// A reusable view for displaying a detail row with a title and information.
    /// - Parameters:
    ///   - title: The title of the detail.
    ///   - info: The information of the detail.
    @ViewBuilder func detail(title: String, info: String) -> some View {
        HStack {
            Text(title + Constants.titleSeparator)
                .bold()
            Spacer()
            Text(info)
        }
    }
    
    //MARK: Constants
    /// Constants used for styling the view.
    private struct Constants {
        static let imageHeight: CGFloat = 300
        
        static let materialPadding: CGFloat = 5
        static let materialCornerRadius: CGFloat = 8
        static let heightWidthTextPadding: CGFloat = 8
        
        static let titleLineLimit: Int = 1
        
        static let dateTakenTitle = "Date Taken"
        static let datePublishedTitle = "Date Published"
        static let titleSeparator = ": "
    }
}

//MARK: Preview
#Preview {
    FlickerItemDetailsView(item: .debugObj) 
}
