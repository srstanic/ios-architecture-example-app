//
//  MobileShopAPIClient.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

enum MobileShopAPIClientError: Error {
    case failedToLoadModel
}

struct MobileShopAPIRequest: Equatable {
    let path: String
}

protocol MobileShopAPIClient {
    func request<ModelType: Codable>(
        _ request: MobileShopAPIRequest,
        completion: @escaping (Result<ModelType, Error>) -> Void
    )
}

extension MobileShopAPIClient {
    func request<ModelType: Codable>(path: String, completion: @escaping (Result<ModelType, Error>) -> Void) {
        let apiRequest = MobileShopAPIRequest(path: path)
        request(apiRequest, completion: completion)
    }
}
