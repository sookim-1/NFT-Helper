//
//  NetworkManager.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/27.
//

import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}

    func getCollections(url: URL, completion: @escaping (Result<[AddressCollectionModel], NetWorkErrorMessage>) -> Void) {
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.request(endpoint: request, completion: completion)
    }
    
    func getCollectionStats(url: URL, completion: @escaping (Result<SingleAssetStatsModel, NetWorkErrorMessage>) -> Void) {
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.request(endpoint: request, completion: completion)
    }
    
    func addCollection(url: URL, completion: @escaping (Result<Post, NetWorkErrorMessage>) -> Void) {
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.request(endpoint: request, completion: completion)
    }
    
    func getCurrentPrice(url: String, completion: @escaping (Result<CoinPrice, NetWorkErrorMessage>) -> Void) {
        var urlComponents = URLComponents(string: "\(url)")
        let countQuery = URLQueryItem(name: "count", value: "1")
        urlComponents?.queryItems?.append(countQuery)
        
        guard let url = urlComponents?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.request(endpoint: request, completion: completion)
    }
    
}
