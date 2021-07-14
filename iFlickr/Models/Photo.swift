//
//  Photo.swift
//  iFlickr
//
//  Created by Mike Conner on 7/13/21.
//

import Foundation

struct Photos: Decodable {
    let items: [Photo]
}

struct Photo: Decodable {
    let title: String
    let media: Media
    let dateTaken: String
    let published: String
    let descriptionField: String
    let tags: String
    
    enum CodingKeys: String, CodingKey {
        case title, media, published, tags
        case dateTaken   = "date_taken"
        case descriptionField = "description"
    }
}

struct Media: Decodable {
    let m: String
}
