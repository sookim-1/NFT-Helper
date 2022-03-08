//
//  EndPoint.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/27.
//

import Foundation

enum Endpoint {
    case collections(assetOwner: String, offset: Int, limit: Int)
    case collectionStats(collectionSlug: String)
}

extension Endpoint {
    var url: URL {
        switch self {
        case .collections(let assetOwner, let offset, let limit):
            return .makeForEndpoint("collections?asset_owner=\(assetOwner)&offset=\(offset)&limit=\(limit)")
        case .collectionStats(let slug):
            return .makeForEndpoint("collection/\(slug)/stats")
        }
    }
}

private extension URL {
    static let baseURL = "https://api.opensea.io/api/v1/"
    
    static func makeForEndpoint(_ endpoint: String) -> URL {
        URL(string: baseURL + endpoint)!
    }
}
