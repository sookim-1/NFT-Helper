//
//  URLSession+Ext.swift
//  NFT-Helper
//
//  Created by sookim on 2022/02/27.
//

import Foundation

extension URLSession {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void

    @discardableResult
    func dataTask(_ endpoint: URLRequest, handler: @escaping Handler) -> URLSessionDataTask {
        let task = dataTask(with: endpoint, completionHandler: handler)
        task.resume()

        return task
    }

    static func request<T: Decodable>(_ session: URLSession = .shared, endpoint: URLRequest, completion: @escaping (Result<T, NetWorkErrorMessage>) -> Void) {
        session.dataTask(endpoint) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(.failure(.invalidAddress))
                    return
                }

                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(.invalidAddress))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(T.self, from: data)
                    completion(.success(userData))
                } catch {
                    completion(.failure(.decodeError))
                }
            }
        }
    }

}
