//
//  BithumbModel.swift
//  NFT-Helper
//
//  Created by sookim on 2022/05/03.
//

import Foundation

// MARK: - Model
struct BithumbModel: Codable {
    let type: String
    let content: Content
}

struct Content: Codable {
    let tickType, date, time, openPrice: String
    let closePrice, lowPrice, highPrice, value: String
    let volume, sellVolume, buyVolume, prevClosePrice: String
    let chgRate, chgAmt, volumePower, symbol: String
}

struct RequestBit: Codable {
    let type: String
    let symbols: [String]
    let tickTypes: [String]
}
