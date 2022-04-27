//
//  CoinPrice.swift
//  NFT-Helper
//
//  Created by sookim on 2022/04/15.
//

import Foundation

struct CoinPrice: Codable {
    let status: String
    let data: [CoinData]
}

struct CoinData: Codable {
    let price: String
}
