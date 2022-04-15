//
//  MintMetadata.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/14.
//

import Foundation

enum ChainList: Codable {
    case eth
    case klaytn
    case none
}

struct MintMetadata: Codable, Hashable {
    var name: String
    var chainName: ChainList
    var price: Double
    var isWhiteList: Bool
    var mintDate: Date
    var mintTime: Date
}
