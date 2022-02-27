//
//  NetworkManager.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/27.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func getCollections(url: URL, completion: @escaping (Result<[AddressCollectionModel], Error>) -> Void) {
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.request(endpoint: request, completion: completion)
    }
    
    func getCollectionStats(url: URL, completion: @escaping (Result<SingleAssetStatsModel, Error>) -> Void) {
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.request(endpoint: request, completion: completion)
    }
}
