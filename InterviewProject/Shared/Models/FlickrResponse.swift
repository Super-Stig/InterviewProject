//
//  FlickrResponse.swift
//  InterviewProject
//
//  Created by Cameron Taylor on 7/31/24.
//

import Foundation
import ImageIO

// MARK: - Response Object from API
struct FlickrResponse: Codable {
    let title: String
    let link: String
    let description: String
    let modified: String
    let generator: String
    let items: [Item]
}

// MARK: - Item
struct Item: Codable, Identifiable {
    let id: UUID = UUID()
    let title: String
    let link: String
    let media: Media
    let dateTaken: String
    let description: String
    let published: String
    let author, authorID, tags: String
    
    enum CodingKeys: String, CodingKey {
        case title, link, media
        case dateTaken = "date_taken"
        case description, published, author
        case authorID = "author_id"
        case tags
    }
    
    
    func getImageSize() -> String {
        if let imageSource = CGImageSourceCreateWithURL(URL(string: media.imageLink)! as CFURL, nil) {
            if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
                let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as! Int
                let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as! Int
                return "\(pixelWidth) x \(pixelHeight)"
            }
        }
        
        return "None"
    }
    
    static let debugObj: Self = .init(
        title: "Noah's ark carving",
        link: "https://www.flickr.com//photos//182882235@N04//53889952607//",
        media: Media(imageLink:"https://live.staticflickr.com//65535//53889952607_0b06e04282_m.jpg"),
        dateTaken: "2012-10-14T13:18:00-08:00",
        description: "",
        published: "2024-07-30T11:34:21Z",
        author: "nobody@flickr.com (\"wwimble\")",
        authorID: "182882235@N04",
        tags: "columbusmuseumofart elijahpierce woodcarving noahsark animals fish cattle birds rhinoceros hippopotamus chimpanzee monkey camel bear baboon rabbit goat peacock turtle deer donkey porcupine snake panther lion man ark")
}

// MARK: - Media
struct Media: Codable {
    let imageLink: String
    
    /// Retrieves the dimensions of the image.
    ///
    /// - Returns: A string representing the image size in the format "width x height" or "None" if the size couldn't be determined.
    func getImageSize() -> String {
        //Checking the URL
        guard let url = URL(string: imageLink), let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return "None"
        }
        
        // Checking the Image Properties and atempt cast to Int
        guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
              let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as? Int,
              let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as? Int else {
            return "None"
        }
        
        // Returned Value
        return "\(pixelWidth) x \(pixelHeight)"
    }
    
    enum CodingKeys: String, CodingKey {
        case imageLink = "m"
    }
}



