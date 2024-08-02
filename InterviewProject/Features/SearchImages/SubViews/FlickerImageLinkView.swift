//
//  ImgListView.swift
//  InterviewProject
//
//  Created by Cameron Taylor on 7/31/24.
//

import Foundation
import SwiftUI

/// A View that will display the a given item's `Media` Image link as an `AsyncImage` from a `FlickerResponse`
struct FlickerImageLinkView: View {
    
    //MARK: Parameters
    let item: Item
    var imgSize: CGSize
    var scaleEffect: ScaleEffect
    
    /// Initializes an `ImgListView` with the specified parameters.
    ///
    /// - Parameters:
    ///   - item: The item containing the image data to display.
    ///   - imgSize: The size of the image frame. Defaults to `Constants.imageSize` IE Width: 100, Height: 100.
    ///   - scaleEffect: The scaling effect to apply to the image (`.fill` or `.fit`). Defaults to `.fill`.
    init(_ item: Item,
         imgSize: CGSize = Constants.imageSize,
         scaleEffect: ScaleEffect = .fill) {
        self.item = item
        self.imgSize = imgSize
        self.scaleEffect = scaleEffect
    }
    
    //MARK: Main Body
    var body: some View {
        AsyncImage(
            url: URL(string: item.media.imageLink),
            transaction: Transaction(animation: .easeInOut)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                display(image)
            case .failure(let error):
                failedToRetrieveImgView(error)
            @unknown default:
                failedToRetrieveImgView()
            }
        }
            .frame(width: imgSize.width, height: imgSize.height)
    }
    
    //MARK: Sub Views
    
    /// Displays the given image with specific styling.
    /// - Parameter image: The image to display.
    @ViewBuilder func display(_ image: Image) -> some View {
        image
            .resizable()
            .if(scaleEffect == .fill) { view in
                view
                    .frame(width: imgSize.width, height: imgSize.height)
                    .scaledToFill()
                    .border(.black)
            }
            .if(scaleEffect == .fit) { view in
                view
                    .scaledToFit()
                    .frame(width: imgSize.width, height: imgSize.height)
            }
            .transition(.scale)
    }
    
    /// Displays a view indicating the image failed to load.
    /// - Parameter error: The error that occurred, if any.
    @ViewBuilder func failedToRetrieveImgView(_ error: Error? = nil) -> some View {
        VStack {
            Image(systemName: Constants.systemIcon)
            if let error = error {
                Text(error.localizedDescription)
            }
        }
    }
    
    //MARK: Scale Effect
    enum ScaleEffect {
        case fill
        case fit
    }
    
    
    //MARK: Constants
    /// Constants used for styling the image and error view.
    private struct Constants {
        static let imageSize: CGSize = CGSize(width: 100, height: 100)
        static let systemIcon: String = "wifi.slash"
    }
}

//MARK: Preview
#Preview {
    FlickerImageLinkView(.debugObj, scaleEffect: .fit)
}

