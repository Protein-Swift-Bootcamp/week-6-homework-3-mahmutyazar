//
//  News.swift
//  New York Times App
//
//  Created by Mahmut Yazar on 9.01.2023.
//
import Foundation

// MARK: - News
struct News: Codable {
    let status, copyright: String?
    let numResults: Int?
    let results: [Result]?

    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case results
    }
}

// MARK: - Result
struct Result: Codable {
    let slugName, section, subsection, title: String?
    let abstract, uri: String?
    let url: String?
    let byline: String?
    let thumbnailStandard: String?
    let itemType: ItemType?
    let source: Source?
    let updatedDate, createdDate, publishedDate, firstPublishedDate: Date?
    let materialTypeFacet, kicker, subheadline: String?
    let desFacet, orgFacet, perFacet, geoFacet: [String]?
    let relatedUrls: [RelatedURL]?
    let multimedia: [Multimedia]?

    enum CodingKeys: String, CodingKey {
        case slugName = "slug_name"
        case section, subsection, title, abstract, uri, url, byline
        case thumbnailStandard = "thumbnail_standard"
        case itemType = "item_type"
        case source
        case updatedDate = "updated_date"
        case createdDate = "created_date"
        case publishedDate = "published_date"
        case firstPublishedDate = "first_published_date"
        case materialTypeFacet = "material_type_facet"
        case kicker, subheadline
        case desFacet = "des_facet"
        case orgFacet = "org_facet"
        case perFacet = "per_facet"
        case geoFacet = "geo_facet"
        case relatedUrls = "related_urls"
        case multimedia
    }
}

enum ItemType: String, Codable {
    case article = "Article"
    case slideshow = "Slideshow"
    case video = "Video"
}

// MARK: - Multimedia
struct Multimedia: Codable {
    let url: String?
    let format: Format?
    let height, width: Int?
    let type: TypeEnum?
    let subtype: Subtype?
    let caption, copyright: String?
}

enum Format: String, Codable {
    case mediumThreeByTwo210 = "mediumThreeByTwo210"
    case mediumThreeByTwo440 = "mediumThreeByTwo440"
    case normal = "Normal"
    case standardThumbnail = "Standard Thumbnail"
}

enum Subtype: String, Codable {
    case photo = "photo"
}

enum TypeEnum: String, Codable {
    case image = "image"
}

// MARK: - RelatedURL
struct RelatedURL: Codable {
    let suggestedLinkText: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case suggestedLinkText = "suggested_link_text"
        case url
    }
}

enum Source: String, Codable {
    case newYorkTimes = "New York Times"
}
