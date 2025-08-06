//
//  Post.swift
//  ios101-project6-tumblr
//

import Foundation

struct Blog: Decodable {
    let response: Response
}

struct Response: Decodable {
    let posts: [Post]
}

struct Post: Decodable {
    let summary: String
    let caption: String
    let photos: [Photo]
    let image: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case summary
        case caption
        case photos
        case image
        case title
    }
}

struct Photo: Decodable {
     let originalSize: PhotoInfo

    enum CodingKeys: String, CodingKey {

        // Maps API key name to a more "swifty" version (i.e. lowerCamelCasing and no `_`)
        case originalSize = "original_size"
    }
}

struct PhotoInfo: Decodable {
    let url: URL
}
