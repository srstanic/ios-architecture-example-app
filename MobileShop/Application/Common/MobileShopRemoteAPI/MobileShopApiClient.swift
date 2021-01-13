//
//  MobileShopApiClient.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

enum MobileShopApiClientError: Error {
    case failedToLoadModel
}

final class MobileShopApiClient: RemoteApiClient {
    init(scheme: String, host: String, pathPrefix: String) {
        self.scheme = scheme
        self.host = host
        self.pathPrefix = pathPrefix
    }
    private let scheme: String
    private let host: String
    private let pathPrefix: String

    func request<ModelType: Codable>(
        _ request: RemoteApiRequest,
        completion: @escaping (Result<ModelType, Error>) -> Void
    ) {
        let session = URLSession.shared
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.path = self.pathPrefix + "/" + request.path

        guard let url = urlComponents.url else {
            return
        }

        session.dataTask(with: url, completionHandler: { data, response, error in
            guard error == nil else {
                print("Error: \(error!)")
                completion(.failure(MobileShopApiClientError.failedToLoadModel))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Unknown response")
                completion(.failure(MobileShopApiClientError.failedToLoadModel))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("Status code: \(httpResponse.statusCode)")
                completion(.failure(MobileShopApiClientError.failedToLoadModel))
                return
            }

            let decoder = JSONDecoder()
            if
                let data = data,
                let decodedData = try? decoder.decode(ModelType.self, from: data)
            {
                completion(.success(decodedData))
            } else {
                print("Unable to decode data")
                completion(.failure(MobileShopApiClientError.failedToLoadModel))
            }
        }).resume()
    }

    static func development() -> Self {
        return .init(
            scheme: "https",
            host: "my-json-server.typicode.com",
            pathPrefix: "/srstanic/ios-architecture-mock-api"
        )
    }
}
