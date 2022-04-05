//
//  WalletAddress.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/04.
//

import Foundation

enum AddressType: Codable {
    case none
    case metamask
    case kaikas
}

struct WalletAddress: Codable, Hashable {
    let address: String
    let type: AddressType
}
