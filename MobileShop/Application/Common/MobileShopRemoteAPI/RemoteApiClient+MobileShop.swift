//
//  RemoteApiClient+MobileShop.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

extension RemoteApiClient {
    func request<ModelType: Codable>(path: String, completion: @escaping (Result<ModelType, Error>) -> Void) {
        let apiRequest = RemoteApiRequest(path: path)
        request(apiRequest, completion: completion)
    }
}
