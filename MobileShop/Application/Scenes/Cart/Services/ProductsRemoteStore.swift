//
//  ProductsRemoteStore.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import Foundation

typealias RemoteStoreProductsResultHandler = (Result<[RemoteStoreProduct], Error>) -> Void

struct RemoteStoreProduct: Codable {
    let id: String
    let title: String
    let price: Double
}

final class ProductsRemoteStore: RemoteStore {
    func getProducts(withIds productIds: [String], completion: @escaping RemoteStoreProductsResultHandler) {
        apiClient.request(path: "products") { (productsResult: Result<[RemoteStoreProduct], Error>) in
            switch productsResult {
            case .success(let allProducts):
                let products = allProducts.filter { productIds.contains($0.id) }
                completion(.success(products))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
