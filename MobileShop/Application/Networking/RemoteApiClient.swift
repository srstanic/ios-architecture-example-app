//
//  RemoteApiClient.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

struct RemoteApiRequest: Equatable {
    let path: String
}

protocol RemoteApiClient {
    func request<ModelType: Codable>(
        _ request: RemoteApiRequest,
        completion: @escaping (Result<ModelType, Error>) -> Void
    )
}

