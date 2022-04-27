//
//  OpenseaModel.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/27.
//

import Foundation

struct AddressCollectionModel: Codable, Hashable {
    let id = UUID()
    var name: String
    let stats: [String: Double?]
    let externalURL: String?
    let imageURL: String?
    let slug: String

    enum CodingKeys: String, CodingKey {
        case name, stats
        case externalURL = "external_url"
        case imageURL = "image_url"
        case slug
    }
}

struct SingleAssetStatsModel: Codable {
    let stats: [String: Double]
}

struct Post: Codable {
    var collection: CollectionsModel
}

struct CollectionsModel: Codable {
    let stats: [String: Double?]
    var name: String
    let imageURL: String?
    let externalURL: String?
    
    enum CodingKeys: String, CodingKey {
        case stats, name
        case imageURL = "image_url"
        case externalURL = "external_url"
    }
}

