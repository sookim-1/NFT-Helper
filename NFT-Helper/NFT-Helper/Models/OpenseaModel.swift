//
//  OpenseaModel.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/27.
//

import Foundation

struct AddressCollectionModel: Codable, Hashable {
    let name: String
    let externalURL: String?
    let imageURL: String
    let slug: String
    let ownedAssetCount: Int

    enum CodingKeys: String, CodingKey {
        case name
        case externalURL = "external_url"
        case imageURL = "image_url"
        case slug
        case ownedAssetCount = "owned_asset_count"
    }
}

struct SingleAssetStatsModel: Codable {
    let stats: [String: Double]
}
